import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shrm_homework_app/features/account/domain/repository/account_repository.dart';
import 'package:shrm_homework_app/features/category/domain/repository/category_repository.dart';
import 'package:shrm_homework_app/features/transaction/data/models/transaction_request/transaction_request.dart';
import 'package:shrm_homework_app/features/transaction/domain/repository/transaction_repository.dart';

import 'package:talker_flutter/talker_flutter.dart';

import 'transaction_event.dart';
import 'transaction_state.dart';

@injectable
class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository _repository;
  final CategoryRepository _categoryRepository;
  final AccountRepository _accountRepository;
  final Talker _talker;

  TransactionBloc(
    this._repository,
    this._categoryRepository,
    this._accountRepository,
    this._talker,
  ) : super(const TransactionState.initial()) {
    on<LoadTodayTransactions>(_onLoadTodayTransactions);
    on<RefreshTransactions>(_onRefreshTransactions);
    on<CreateTransaction>(_onCreateTransaction);
    on<UpdateTransaction>(_onUpdateTransaction);
    on<DeleteTransaction>(_onDeleteTransaction);
    on<LoadCategories>(_onLoadCategories);
    on<LoadAccounts>(_onLoadAccounts);
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      final categories = await _categoryRepository.getCategoriesByType(
        event.isIncome,
      );
      emit(
        TransactionState.categoriesLoaded(
          categories: categories,
          isIncome: event.isIncome,
        ),
      );
    } catch (e, st) {
      emit(
        TransactionState.error(
          message: 'Ошибка загрузки категорий: ${e.toString()}',
        ),
      );
      _talker.handle(e, st);
    }
  }

  Future<void> _onLoadAccounts(
    LoadAccounts event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      final account = await _accountRepository.getAccount(100);
      emit(TransactionState.accountsLoaded(accounts: [account]));
    } catch (e, st) {
      emit(
        TransactionState.error(
          message: 'Ошибка загрузки счетов: ${e.toString()}',
        ),
      );
      _talker.handle(e, st);
    }
  }

  Future<void> _onLoadTodayTransactions(
    LoadTodayTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    emit(const TransactionState.loading());
    _talker.debug('Loading today transactions...');

    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

      final transactions = await _repository.getTransactionsByPeriod(
        100,
        startDate: startOfDay,
        endDate: endOfDay,
      );

      final filteredTransactions =
          transactions
              .where((t) => t.category.isIncome == event.isIncome)
              .toList()
            ..sort((a, b) => b.transactionDate.compareTo(a.transactionDate));

      final totalAmount = filteredTransactions.fold<double>(
        0,
        (sum, t) => sum + t.amount,
      );

      emit(
        TransactionState.loaded(
          transactions: filteredTransactions,
          totalAmount: totalAmount,
          isIncome: event.isIncome,
          currency:
              filteredTransactions.isNotEmpty
                  ? filteredTransactions.first.account.currency
                  : 'RUB',
        ),
      );
      _talker.debug('Today transactions loaded successfully');
    } on DioException catch (e) {
      final errorMsg = _handleDioError(e);
      emit(TransactionState.error(message: errorMsg));
      _talker.error(errorMsg);
    } catch (e, st) {
      emit(TransactionState.error(message: 'Ошибка загрузки: ${e.toString()}'));
      _talker.handle(e, st);
    }
  }

  Future<void> _onRefreshTransactions(
    RefreshTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    final currentState = state;
    if (currentState is TransactionLoaded) {
      _talker.debug('Refreshing transactions...');
      add(LoadTodayTransactions(isIncome: currentState.isIncome));
    }
  }

  Future<void> _onCreateTransaction(
    CreateTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    emit(const TransactionState.saving());
    _talker.debug('Creating transaction...');

    try {
      if (!_validateRequest(event.request)) {
        throw ArgumentError('Невалидные данные транзакции');
      }

      await _repository.createTransaction(
        event.request,
      );

      emit(const TransactionState.saved());
      _talker.debug('Transaction created');

      if (state is TransactionLoaded) {
        add(
          LoadTodayTransactions(
            isIncome: (state as TransactionLoaded).isIncome,
          ),
        );
      }
    } on DioException catch (e) {
      final errorMsg = _handleDioError(e);
      emit(TransactionState.error(message: errorMsg));
      _talker.error(errorMsg);
    } catch (e, st) {
      emit(TransactionState.error(message: 'Ошибка создания: ${e.toString()}'));
      _talker.handle(e, st);
    }
  }

  Future<void> _onUpdateTransaction(
    UpdateTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    emit(const TransactionState.saving());
    _talker.debug('Updating transaction ${event.id}...');

    try {
      if (!_validateRequest(event.request)) {
        throw ArgumentError('Невалидные данные транзакции');
      }

      await _repository.updateTransaction(event.id, event.request);

      emit(const TransactionState.saved());
      _talker.debug('Transaction ${event.id} updated successfully');

      if (state is TransactionLoaded) {
        add(
          LoadTodayTransactions(
            isIncome: (state as TransactionLoaded).isIncome,
          ),
        );
      }
    } on DioException catch (e) {
      final errorMsg = _handleDioError(e);
      emit(TransactionState.error(message: errorMsg));
      _talker.error(errorMsg);
    } catch (e, st) {
      emit(
        TransactionState.error(message: 'Ошибка обновления: ${e.toString()}'),
      );
      _talker.handle(e, st);
    }
  }

  Future<void> _onDeleteTransaction(
    DeleteTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    emit(const TransactionState.saving());
    _talker.debug('Deleting transaction ${event.id}...');

    try {
      await _repository.deleteTransaction(event.id);

      emit(const TransactionState.deleted());
      _talker.debug('Transaction ${event.id} deleted successfully');

      if (state is TransactionLoaded) {
        add(
          LoadTodayTransactions(
            isIncome: (state as TransactionLoaded).isIncome,
          ),
        );
      }
    } on DioException catch (e) {
      final errorMsg = _handleDioError(e);
      emit(TransactionState.error(message: errorMsg));
      _talker.error(errorMsg);
    } catch (e, st) {
      emit(TransactionState.error(message: 'Ошибка удаления: ${e.toString()}'));
      _talker.handle(e, st);
    }
  }

  String _handleDioError(DioException e) {
    if (e.response != null) {
      final statusCode = e.response?.statusCode;
      final errorData = e.response?.data?['message'] ?? e.response?.data;

      return 'Ошибка сервера ($statusCode): $errorData';
    }
    return 'Сетевая ошибка: ${e.message}';
  }

  bool _validateRequest(TransactionRequest request) {
    return request.amount > 0;
  }
}
