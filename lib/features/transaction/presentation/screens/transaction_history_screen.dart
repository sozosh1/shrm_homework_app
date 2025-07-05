import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shrm_homework_app/config/router/app_router.dart';
import 'package:shrm_homework_app/config/theme/app_colors.dart';
import 'package:shrm_homework_app/core/di/di.dart';
import 'package:shrm_homework_app/core/widgets/currency_display.dart';
import 'package:shrm_homework_app/core/widgets/error_widget.dart';
import 'package:shrm_homework_app/features/transaction/presentation/bloc/transaction_history/transaction_history_bloc.dart';
import 'package:shrm_homework_app/features/transaction/presentation/bloc/transaction_history/transaction_history_event.dart';
import 'package:shrm_homework_app/features/transaction/presentation/bloc/transaction_history/transaction_history_state.dart';
import 'package:shrm_homework_app/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:shrm_homework_app/features/transaction/presentation/widgets/transaction_form_screen.dart';
import 'package:shrm_homework_app/features/transaction/presentation/widgets/transaction_list_item.dart';
import 'package:shrm_homework_app/generated/l10n.dart';

class TransactionHistoryScreen extends StatelessWidget {
  final bool isIncome;

  const TransactionHistoryScreen({super.key, required this.isIncome});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              getIt<TransactionHistoryBloc>()..add(
                TransactionHistoryEvent.loadTransactionInitialHistory(
                  isIncome: isIncome,
                ),
              ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).myHistory),
          actions: [
            IconButton(
              icon: const Icon(Icons.pending_actions_outlined),
              onPressed: () {
                context.router.push(TransactionAnalysRoute(isIncome: isIncome));
              },
            ),
          ],
        ),
        body: TransactionHistoryView(isIncome: isIncome),
      ),
    );
  }
}

class TransactionHistoryView extends StatelessWidget {
  final bool isIncome;

  const TransactionHistoryView({super.key, required this.isIncome});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionHistoryBloc, TransactionHistoryState>(
      builder: (context, state) {
        if (state is TransactionHistoryInitial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TransactionHistoryLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TransactionHistoryLoaded) {
          return Column(
            children: [
              
              Container(
                color: AppColors.lightGreenBackground,
                child: Column(
                  children: [
                    _buildDateListTile(
                      context,
                      S.of(context).start,
                      _formatDateForDisplay(state.startDate),
                      () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: state.startDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (selectedDate != null) {
                          context.read<TransactionHistoryBloc>().add(
                            TransactionHistoryEvent.updateStartDate(
                              startDate: selectedDate,
                            ),
                          );
                        }
                      },
                    ),
                    Divider(),
                    _buildDateListTile(
                      context,
                      S.of(context).end,
                      _formatDateForDisplay(state.endDate),
                      () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: state.endDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (selectedDate != null) {
                          context.read<TransactionHistoryBloc>().add(
                            TransactionHistoryEvent.updateEndDate(
                              endDate: selectedDate,
                            ),
                          );
                        }
                      },
                    ),
                    Divider(),
                    _buildSortingListTile(
                      context,
                      S.of(context).sort,
                      state.sortBy == 'date'
                          ? S.of(context).byDate
                          : S.of(context).byAmount,
                      () {
                        _showSortingDialog(context, state.sortBy);
                      },
                    ),
                    Divider(),
                    _buildSummaryListTile(
                      S.of(context).amount,
                      CurrencyDisplay(
                        amount: state.totalAmount,
                        accountCurrency: state.currency,
                      ),
                    ),
                    Divider(height: 1),
                  ],
                ),
              ),

              Expanded(
                child: Container(
                  child:
                      state.transactions.isEmpty
                          ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  state.isIncome
                                      ? Icons.trending_up
                                      : Icons.trending_down,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  state.isIncome
                                      ? S.of(context).noIncomeForSelectedPeriod
                                      : S
                                          .of(context)
                                          .noExpensesForSelectedPeriod,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                          : RefreshIndicator(
                            onRefresh: () async {
                              context.read<TransactionHistoryBloc>().add(
                                const TransactionHistoryEvent.refreshHistory(),
                              );
                            },
                            child: ListView.separated(
                              separatorBuilder: (context, index) => Divider(),
                              itemCount: state.transactions.length + 1,
                              itemBuilder: (context, index) {
                                if (index < state.transactions.length) {
                                  return TransactionListItem(
                                    onTap: () async {
                                      final bloc = getIt<TransactionBloc>();
                                      final result = await showModalBottomSheet(
                                        useSafeArea: true,
                                        context: context,
                                        isScrollControlled: true,
                                        builder:
                                            (_) => BlocProvider.value(
                                              value: bloc,
                                              child: FractionallySizedBox(
                                                heightFactor: 1,
                                                child: TransactionFormScreen(
                                                  isIncome: state.isIncome,
                                                  transaction:
                                                      state.transactions[index],
                                                ),
                                              ),
                                            ),
                                      );
                                      if (result == true) {
                                        context.read<TransactionHistoryBloc>().add(
                                          const TransactionHistoryEvent.refreshHistory(),
                                        );
                                      }
                                    },
                                    showTime: true,
                                    transaction: state.transactions[index],
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                ),
              ),
            ],
          );
        } else if (state is TransactionHistoryError) {
          return AppErrorWidget(
            message: state.message,
            onRetry: () {
              context.read<TransactionHistoryBloc>().add(
                TransactionHistoryEvent.loadTransactionInitialHistory(
                  isIncome: isIncome,
                ),
              );
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildDateListTile(
    BuildContext context,
    String title,
    String value,
    VoidCallback onTap,
  ) {
    return ListTile(title: Text(title), trailing: Text(value), onTap: onTap);
  }

  Widget _buildSortingListTile(
    BuildContext context,
    String title,
    String value,
    VoidCallback onTap,
  ) {
    return ListTile(title: Text(title), trailing: Text(value), onTap: onTap);
  }

  Widget _buildSummaryListTile(String title, Widget value) {
    return ListTile(title: Text(title), trailing: value);
  }

  String _formatDateForDisplay(DateTime date) {
    final months = [
      'Январь',
      'Февраль',
      'Март',
      'Апрель',
      'Май',
      'Июнь',
      'Июль',
      'Август',
      'Сентябрь',
      'Октябрь',
      'Ноябрь',
      'Декабрь',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  void _showSortingDialog(BuildContext context, String currentSort) {
    final bloc = context.read<TransactionHistoryBloc>();
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(S.of(context).chooseSort),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(S.of(context).byDate),
                leading: Radio<String>(
                  value: 'date',
                  groupValue: currentSort,
                  onChanged: (value) {
                    if (value != null) {
                      bloc.add(
                        TransactionHistoryEvent.changeSorting(sortBy: value),
                      );
                      Navigator.of(dialogContext).pop();
                    }
                  },
                ),
              ),
              ListTile(
                title: Text(S.of(context).byAmount),
                leading: Radio<String>(
                  value: 'amount',
                  groupValue: currentSort,
                  onChanged: (value) {
                    if (value != null) {
                      bloc.add(
                        TransactionHistoryEvent.changeSorting(sortBy: value),
                      );
                      Navigator.of(dialogContext).pop();
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
