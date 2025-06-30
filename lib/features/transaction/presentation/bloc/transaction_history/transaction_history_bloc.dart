import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shrm_homework_app/features/transaction/data/models/transaction_response/transaction_response.dart';
import 'package:shrm_homework_app/features/transaction/domain/models/category_analysis_item.dart';

import 'package:shrm_homework_app/features/transaction/domain/repository/transaction_repository.dart';
import 'package:talker_flutter/talker_flutter.dart';

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
    on<LoadTransactionAnalysisByPeriod>(_onLoadTransactionAnalysisByPeriod);
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

    final currentState = state;
    if (currentState is TransactionAnalysisLoaded) {
      add(
        TransactionHistoryEvent.loadTransactionAnalysisByPeriod(
          startDate: defaultStart,
          endDate: defaultEnd,
          isIncome: event.isIncome,
        ),
      );
    } else {
      add(
        TransactionHistoryEvent.loadTransactionHistoryByPeriod(
          startDate: defaultStart,
          endDate: defaultEnd,
          isIncome: event.isIncome,
          sortBy: 'date',
        ),
      );
    }
  }

  Future<void> _onLoadTransactionHistoryByPeriod(
    LoadTransactionHistoryByPeriod event,
    Emitter<TransactionHistoryState> emit,
  ) async {
    emit(const TransactionHistoryState.loading());

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
        999,
      );

      final filteredTransactions =
          allTransactions.where((transaction) {
            final transactionDate = transaction.transactionDate;
            final isInPeriod =
                !transactionDate.isBefore(startOfDay) &&
                !transactionDate.isAfter(endOfDay);
            final isCorrectType =
                transaction.category.isIncome == event.isIncome;
            return isInPeriod && isCorrectType;
          }).toList();

      final totalAmount = filteredTransactions.fold<double>(
        0,
        (sum, transaction) => sum + transaction.amount,
      );

      final currency =
          filteredTransactions.isNotEmpty
              ? filteredTransactions.first.account.currency
              : 'RUB';

      _sortTransactions(filteredTransactions, event.sortBy ?? 'date');

      emit(
        TransactionHistoryState.loaded(
          transactions: filteredTransactions,
          totalAmount: totalAmount,
          isIncome: event.isIncome,
          currency: currency,
          startDate: event.startDate,
          endDate: event.endDate,
          sortBy: event.sortBy ?? 'date',
        ),
      );
    } catch (e, st) {
      emit(TransactionHistoryState.error(message: 'Произошла ошибка: $e'));
      GetIt.I<Talker>().handle(e, st);
    }
  }

  Future<void> _onLoadTransactionAnalysisByPeriod(
    LoadTransactionAnalysisByPeriod event,
    Emitter<TransactionHistoryState> emit,
  ) async {
    emit(const TransactionHistoryState.loading());

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
        999,
      );

      final filteredTransactions =
          allTransactions.where((transaction) {
            final transactionDate = transaction.transactionDate;
            final isInPeriod =
                !transactionDate.isBefore(startOfDay) &&
                !transactionDate.isAfter(endOfDay);
            final isCorrectType =
                transaction.category.isIncome == event.isIncome;
            return isInPeriod && isCorrectType;
          }).toList();

      final totalAmount = filteredTransactions.fold<double>(
        0,
        (sum, transaction) => sum + transaction.amount,
      );

      final currency =
          filteredTransactions.isNotEmpty
              ? filteredTransactions.first.account.currency
              : 'RUB';

      final groupedByCategory = groupBy(
        filteredTransactions,
        (t) => t.category,
      );

      final analysisItems =
          groupedByCategory.entries.map((entry) {
            final category = entry.key;
            final transactions = entry.value;

            final categoryTotal = transactions.fold<double>(
              0,
              (sum, t) => sum + t.amount,
            );
            final lastTransaction =
                transactions.sortedBy((t) => t.transactionDate).last;
            final double percentage =
                totalAmount > 0 ? (categoryTotal / totalAmount) * 100 : 0;

            return CategoryAnalysisItem(
              category: category,
              totalAmount: categoryTotal,
              lastTransaction: lastTransaction,
              percentage: percentage,
              transactions: transactions,
            );
          }).toList();

      analysisItems.sort((a, b) => b.totalAmount.compareTo(a.totalAmount));

      emit(
        TransactionHistoryState.analysisLoaded(
          analysisItems: analysisItems,
          totalAmount: totalAmount,
          isIncome: event.isIncome,
          currency: currency,
          startDate: event.startDate,
          endDate: event.endDate,
        ),
      );
    } catch (e, st) {
      emit(TransactionHistoryState.error(message: 'Произошла ошибка: $e'));
      GetIt.I<Talker>().handle(e, st);
    }
  }

  Future<void> _onUpdateStartDate(
    UpdateStartDate event,
    Emitter<TransactionHistoryState> emit,
  ) async {
    final currentState = state;
    if (currentState is TransactionHistoryLoaded) {
      DateTime newEndDate = currentState.endDate;

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
    } else if (currentState is TransactionAnalysisLoaded) {
      DateTime newEndDate = currentState.endDate;

      if (event.startDate.isAfter(currentState.endDate)) {
        newEndDate = event.startDate;
      }

      add(
        TransactionHistoryEvent.loadTransactionAnalysisByPeriod(
          startDate: event.startDate,
          endDate: newEndDate,
          isIncome: currentState.isIncome,
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
      DateTime newStartDate = currentState.startDate;

      if (event.endDate.isBefore(currentState.startDate)) {
        newStartDate = event.endDate;
      }

      add(
        TransactionHistoryEvent.loadTransactionHistoryByPeriod(
          startDate: newStartDate,
          endDate: event.endDate,
          isIncome: currentState.isIncome,
          sortBy: currentState.sortBy,
        ),
      );
    } else if (currentState is TransactionAnalysisLoaded) {
      DateTime newStartDate = currentState.startDate;

      if (event.endDate.isBefore(currentState.startDate)) {
        newStartDate = event.endDate;
      }

      add(
        TransactionHistoryEvent.loadTransactionAnalysisByPeriod(
          startDate: newStartDate,
          endDate: event.endDate,
          isIncome: currentState.isIncome,
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
    } else if (currentState is TransactionAnalysisLoaded) {
      add(
        TransactionHistoryEvent.loadTransactionAnalysisByPeriod(
          startDate: currentState.startDate,
          endDate: currentState.endDate,
          isIncome: currentState.isIncome,
        ),
      );
    }
  }

  void _sortTransactions(
    List<TransactionResponse> transactions,
    String sortBy,
  ) {
    if (sortBy == 'amount') {
      transactions.sort((a, b) => b.amount.compareTo(a.amount));
    } else {
      // default sort by date
      transactions.sort(
        (a, b) => (b.transactionDate).compareTo(a.transactionDate),
      );
    }
  }
}
