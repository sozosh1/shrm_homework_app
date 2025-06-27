import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shrm_homework_app/config/theme/app_colors.dart';
import 'package:shrm_homework_app/core/di/di.dart';
import 'package:shrm_homework_app/core/widgets/error_widget.dart';
import 'package:shrm_homework_app/features/category/presentation/bloc/category_bloc.dart';
import 'package:shrm_homework_app/features/category/presentation/bloc/category_event.dart';
import 'package:shrm_homework_app/features/category/presentation/bloc/category_state.dart';
import 'package:shrm_homework_app/features/category/presentation/widgets/category_list_item.dart';
import 'package:shrm_homework_app/features/category/presentation/widgets/search_bar.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CategoryBloc>()..add(const LoadCategories()),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(title: const Text('Мои статьи'), elevation: 0),
        body: const CategoriesView(),
      ),
    );
  }
}

class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryInitial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CategoryLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CategoryLoaded) {
          return Column(
            children: [
              CategorySearchBar(
                value: state.searchQuery,
                onChanged: (query) {
                  context.read<CategoryBloc>().add(
                    SearchCategories(query: query),
                  );
                },
                onClear: () {
                  context.read<CategoryBloc>().add(const ClearSearch());
                },
              ),
              if (state.isSearching)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Icon(Icons.search, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Text(
                        'Найдено: ${state.filteredCategories.length} из ${state.allCategories.length}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),

              Expanded(
                child:
                    state.filteredCategories.isEmpty
                        ? _buildEmptyState(state.isSearching, state.searchQuery)
                        : RefreshIndicator(
                          onRefresh: () async {
                            context.read<CategoryBloc>().add(
                              const LoadCategories(),
                            );
                          },
                          child: ListView.builder(
                            itemCount: state.filteredCategories.length,
                            itemBuilder: (context, index) {
                              return CategoryListItem(
                                category: state.filteredCategories[index],
                                searchQuery:
                                    state.isSearching
                                        ? state.searchQuery
                                        : null,
                              );
                            },
                          ),
                        ),
              ),
            ],
          );
        } else if (state is CategoryError) {
          return AppErrorWidget(
            message: state.message,
            onRetry: () {
              context.read<CategoryBloc>().add(const LoadCategories());
            },
          );
        }
        return const Center(child: Text('Неизвестное состояние'));
      },
    );
  }

  Widget _buildEmptyState(bool isSearching, String searchQuery) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSearching ? Icons.search_off : Icons.category_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            isSearching
                ? 'Ничего не найдено по запросу "$searchQuery"'
                : 'Категории не найдены',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          if (isSearching) ...[
            const SizedBox(height: 8),
            Text(
              'Попробуйте изменить поисковый запрос',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
