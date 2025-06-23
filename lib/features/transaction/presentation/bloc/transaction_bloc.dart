import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shrm_homework_app/features/transaction/domain/repository/transaction_repository.dart';

import 'transaction_event.dart';
import 'transaction_state.dart';

@injectable
class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository _repository;

  TransactionBloc(this._repository) : super(const TransactionState.initial()) {
    on<LoadTodayTransactions>(_onLoadTodayTransactions);
    on<RefreshTransactions>(_onRefreshTransactions);
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
    } catch (e) {
      emit(TransactionState.error(message: 'Ошибка загрузки транзакций: $e'));
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
}
