import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shrm_homework_app/features/category/domain/usecases/fuzzy_search_usecase.dart';
import 'package:shrm_homework_app/features/category/presentation/bloc/category_event.dart';
import 'package:shrm_homework_app/features/category/presentation/bloc/category_state.dart';
import 'package:shrm_homework_app/features/category/domain/repository/category_repository.dart';

@injectable
class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository _categoryRepository;
  final FuzzySearchUseCase _fuzzySearchUseCase;

  CategoryBloc(
    this._categoryRepository,
    this._fuzzySearchUseCase,
  ) : super(const CategoryState.initial()) {
    on<LoadCategories>(_onLoadCategories);
    on<SearchCategories>(_onSearchCategories);
    on<ClearSearch>(_onClearSearch);
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<CategoryState> emit,
  ) async {
    emit(const CategoryState.loading());

    try {
      final categories = await _categoryRepository.getAllCategories();
      
      emit(CategoryState.loaded(
        allCategories: categories,
        filteredCategories: categories,
        searchQuery: '',
        isSearching: false,
      ));
    } catch (e) {
      emit(CategoryState.error(message: 'Ошибка загрузки категорий: $e'));
    }
  }

  Future<void> _onSearchCategories(
    SearchCategories event,
    Emitter<CategoryState> emit,
  ) async {
    final currentState = state;
    if (currentState is CategoryLoaded) {
      final query = event.query.trim();
      
      if (query.isEmpty) {
        emit(currentState.copyWith(
          filteredCategories: currentState.allCategories,
          searchQuery: '',
          isSearching: false,
        ));
        return;
      }

      // Используем fuzzy search пакет для поиска
      final filteredCategories = _fuzzySearchUseCase.execute(
        currentState.allCategories,
        query,
      );

      emit(currentState.copyWith(
        filteredCategories: filteredCategories,
        searchQuery: query,
        isSearching: true,
      ));
    }
  }

  Future<void> _onClearSearch(
    ClearSearch event,
    Emitter<CategoryState> emit,
  ) async {
    final currentState = state;
    if (currentState is CategoryLoaded) {
      emit(currentState.copyWith(
        filteredCategories: currentState.allCategories,
        searchQuery: '',
        isSearching: false,
      ));
    }
  }
}