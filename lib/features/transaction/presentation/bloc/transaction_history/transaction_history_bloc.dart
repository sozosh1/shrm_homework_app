import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shrm_homework_app/features/transaction/data/models/transaction_response/transaction_response.dart';
import 'package:shrm_homework_app/features/transaction/domain/repository/transaction_repository.dart';

import 'transaction_history_event.dart';
import 'transaction_history_state.dart';

@injectable
class TransactionHistoryBloc
    extends Bloc<TransactionHistoryEvent, TransactionHistoryState> {
  final TransactionRepository _repository;

  TransactionHistoryBloc(this._repository)
    : super(const TransactionHistoryState.initial()) {
    on<LoadTransactionHistoryInitial>(_onLoadTransactionHistoryInitial);
    on<LoadTransactionHistoryByPeriod>(_onLoadTransactionHistoryByPeriod);
    on<UpdateStartDate>(_onUpdateStartDate);
    on<UpdateEndDate>(_onUpdateEndDate);
    on<ChangeSorting>(_onChangeSorting);
    on<RefreshHistory>(_onRefreshHistory);
  }

  Future<void> _onLoadTransactionHistoryInitial(
    LoadTransactionHistoryInitial event,
    Emitter<TransactionHistoryState> emit,
  ) async {
    final defaultEnd = DateTime.now();
    final defaultStart = DateTime(
      defaultEnd.year,
      defaultEnd.month - 1,
      defaultEnd.day,
    );

    add(
      TransactionHistoryEvent.loadTransactionHistoryByPeriod(
        startDate: defaultStart,
        endDate: defaultEnd,
        isIncome: event.isIncome,
        sortBy: 'date',
      ),
    );
  }

  Future<void> _onLoadTransactionHistoryByPeriod(
    LoadTransactionHistoryByPeriod event,
    Emitter<TransactionHistoryState> emit,
  ) async {
    emit(const TransactionHistoryState.initial());
    try {
      final allTransactions = await _repository.getAllTransactions();

      final startOfDay = DateTime(
        event.startDate.year,
        event.startDate.month,
        event.startDate.day,
      );

      final endOfDay = DateTime(
        event.endDate.year,
        event.endDate.month,
        event.endDate.day,
        23,
        59,
        59,
      );

      final filteredTransactions =
          allTransactions.where((transaction) {
            final transactionDate = DateTime.parse(transaction.transactionDate);
            final isInPeriod =
                transactionDate.isAfter(startOfDay) &&
                transactionDate.isBefore(endOfDay);
            final isCorrectType =
                transaction.category.isIncome == event.isIncome;
            return isInPeriod && isCorrectType;
          }).toList();

      final totalAmout = filteredTransactions
          .fold<double>(
            0,
            (sum, transaction) => sum + double.parse(transaction.amount),
          )
          .toStringAsFixed(2);

      final currency =
          filteredTransactions.isNotEmpty
              ? filteredTransactions.first.account.currency
              : 'RUB';

      _sortTransactions(filteredTransactions, event.sortBy ?? 'date');

      emit(
        TransactionHistoryState.loaded(
          transactions: filteredTransactions,
          totalAmout: totalAmout,
          isIncome: event.isIncome,
          currency: currency,
          startDate: event.startDate,
          endDate: event.endDate,
          sortBy: event.sortBy ?? 'date',
        ),
      );
    } catch (e) {
      emit(TransactionHistoryState.error(message: 'Произошла ошибка: $e'));
    }
  }

  Future<void> _onUpdateStartDate(
    UpdateStartDate event,
    Emitter<TransactionHistoryState> emit,
  ) async {
    final currentState = state;
    if (currentState is TransactionHistoryLoaded) {
      DateTime newEndDate = currentState.endDate;

      //Если в результате редактирования начала периода оно оказалось позже конца, то конец сделать совпадающим с началом периода
      if (event.startDate.isAfter(currentState.endDate)) {
        newEndDate = event.startDate;
      }
      add(
        TransactionHistoryEvent.loadTransactionHistoryByPeriod(
          startDate: event.startDate,
          endDate: newEndDate,
          isIncome: currentState.isIncome,
          sortBy: currentState.sortBy,
        ),
      );
    }
  }

  Future<void> _onUpdateEndDate(
    UpdateEndDate event,
    Emitter<TransactionHistoryState> emit,
  ) async {
    final currentState = state;
    if (currentState is TransactionHistoryLoaded) {
      DateTime newStartDay = currentState.endDate;

      // Если в результате редактирования конца периода он оказался раньше начала, то начало сделать совпадающим с концом периода
      if (event.endDate.isBefore(currentState.startDate)) {
        newStartDay = event.endDate;
      }
      add(
        TransactionHistoryEvent.loadTransactionHistoryByPeriod(
          startDate: newStartDay,
          endDate: event.endDate,
          isIncome: currentState.isIncome,
          sortBy: currentState.sortBy,
        ),
      );
    }
  }

  FutureOr<void> _onChangeSorting(
    ChangeSorting event,
    Emitter<TransactionHistoryState> emit,
  ) {
    final currentState = state;
    if (currentState is TransactionHistoryLoaded) {
      add(
        TransactionHistoryEvent.loadTransactionHistoryByPeriod(
          startDate: currentState.startDate,
          endDate: currentState.endDate,
          isIncome: currentState.isIncome,
          sortBy: event.sortBy,
        ),
      );
    }
  }

  FutureOr<void> _onRefreshHistory(
    RefreshHistory event,
    Emitter<TransactionHistoryState> emit,
  ) {
    final currentState = state;
    if (currentState is TransactionHistoryLoaded) {
      add(
        TransactionHistoryEvent.loadTransactionHistoryByPeriod(
          startDate: currentState.startDate,
          endDate: currentState.endDate,
          isIncome: currentState.isIncome,
          sortBy: currentState.sortBy,
        ),
      );
    }
  }
}

void _sortTransactions(List<TransactionResponse> transactions, String sortBy) {
  if (sortBy == 'amout') {
    transactions.sort(
      (a, b) => double.parse(b.amount).compareTo(double.parse(a.amount)),
    );
  } else {
    transactions.sort(
      (a, b) => DateTime.parse(
        b.transactionDate,
      ).compareTo(DateTime.parse(a.transactionDate)),
    );
  }
}
