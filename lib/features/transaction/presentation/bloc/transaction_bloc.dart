import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shrm_homework_app/features/transaction/data/models/transaction_request/transaction_request.dart';
import 'package:shrm_homework_app/features/transaction/domain/repository/transaction_repository.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'transaction_event.dart';
import 'transaction_state.dart';

@injectable
class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository _repository;
  final Talker _talker;

  TransactionBloc(this._repository, this._talker)
    : super(const TransactionState.initial()) {
    on<LoadTodayTransactions>(_onLoadTodayTransactions);
    on<RefreshTransactions>(_onRefreshTransactions);
    on<CreateTransaction>(_onCreateTransaction);
    on<UpdateTransaction>(_onUpdateTransaction);
    on<DeleteTransaction>(_onDeleteTransaction);
  }

  Future<void> _onLoadTodayTransactions(
    LoadTodayTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    emit(const TransactionState.loading());

    try {
      final allTransactions = await _repository.getAllTransactions();

      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      final endOfDay = DateTime(
        today.year,
        today.month,
        today.day,
        23,
        59,
        59,
        999,
      );

      final todayTransactions =
          allTransactions.where((transaction) {
            final transactionDate = transaction.transactionDate;
            final isToday =
                !transactionDate.isBefore(startOfDay) &&
                !transactionDate.isAfter(endOfDay);
            final isCorrectType =
                transaction.category.isIncome == event.isIncome;
            return isToday && isCorrectType;
          }).toList();

      todayTransactions.sort(
        (a, b) => b.transactionDate.compareTo(a.transactionDate),
      );

      final totalAmount = todayTransactions.fold<double>(
        0,
        (sum, transaction) => sum + transaction.amount,
      );

      final currency =
          todayTransactions.isNotEmpty
              ? todayTransactions.first.account.currency
              : 'RUB';

      emit(
        TransactionState.loaded(
          transactions: todayTransactions,
          totalAmount: totalAmount,
          isIncome: event.isIncome,
          currency: currency,
        ),
      );
    } catch (e, st) {
      emit(TransactionState.error(message: 'Ошибка загрузки транзакций: $e'));
      GetIt.I<Talker>().handle(e, st);
    }
  }

  Future<void> _onRefreshTransactions(
    RefreshTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    final currentState = state;
    if (currentState is TransactionLoaded) {
      add(
        TransactionEvent.loadTodayTransactions(isIncome: currentState.isIncome),
      );
    }
  }

  Future<void> _onCreateTransaction(
    CreateTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    emit(const TransactionState.saving());
    try {
      if (!_validateTransactionRequest(event.request)) {
        _talker.warning('Валидация не прошла при создании транзакции');
        emit(TransactionState.error(message: 'Все поля должны быть заполнены'));
        return;
      }

      _talker.info('Начинаем создание транзакции');
      await _repository.createTransaction(event.request);
      _talker.info('Транзакция создана успешно');
      emit(const TransactionState.saved());
    } catch (e, st) {
      _talker.error('Ошибка создания транзакции', e, st);
      emit(TransactionState.error(message: 'Ошибка создания транзакции: $e'));
      _talker.handle(e, st);
    }
  }

  Future<void> _onUpdateTransaction(
    UpdateTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    emit(const TransactionState.saving());

    try {
      if (!_validateTransactionRequest(event.request)) {
        _talker.warning('Валидация не прошла при обновлении транзакции с ID: ${event.id}');
        emit(TransactionState.error(message: 'Все поля должны быть заполнены'));
        return;
      }

      _talker.info('Начинаем обновление транзакции с ID: ${event.id}');
      await _repository.updateTransaction(event.id, event.request);
      _talker.info('Транзакция успешно обновлена с ID: ${event.id}');
      emit(const TransactionState.saved());
    } catch (e, st) {
      _talker.error('Ошибка обновления транзакции с ID: ${event.id}', e, st);
      emit(TransactionState.error(message: 'Ошибка обновления транзакции: $e'));
      _talker.handle(e, st);
    }
  }

  Future<void> _onDeleteTransaction(
    DeleteTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    emit(const TransactionState.saving());
    try {
      _talker.info('Начинаем удаление транзакции с ID: ${event.id}');
      await _repository.deleteTransaction(event.id);
      _talker.info('Транзакция успешно удалена с ID: ${event.id}');
      emit(const TransactionState.deleted());
    } catch (e, st) {
      _talker.error('Ошибка удаления транзакции с ID: ${event.id}', e, st);
      emit(TransactionState.error(message: 'Ошибка удаления транзакции: $e'));
      _talker.handle(e, st);
    }
  }

  bool _validateTransactionRequest(TransactionRequest request) {
    if (request.amount <= 0) {
      return false;
    }
    return true;
  }
}
