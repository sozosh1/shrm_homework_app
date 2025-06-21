import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shrm_homework_app/config/theme/app_colors.dart';
import 'package:shrm_homework_app/core/di/di.dart';
import 'package:shrm_homework_app/features/transaction/presentation/bloc/transaction_history/transaction_history_bloc.dart';
import 'package:shrm_homework_app/features/transaction/presentation/bloc/transaction_history/transaction_history_event.dart';
import 'package:shrm_homework_app/features/transaction/presentation/bloc/transaction_history/transaction_history_state.dart';
import 'package:shrm_homework_app/features/transaction/presentation/widgets/transaction_list_item.dart';

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
        appBar: AppBar(title: Text('Моя история')),
        body: const TransactionHistoryView(),
      ),
    );
  }
}

class TransactionHistoryView extends StatelessWidget {
  const TransactionHistoryView({super.key});

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
              // Фильтры по датам
              Container(
                color: AppColors.lightGreenBackground,
                child: Column(
                  children: [
                    // Поле "Начало"
                    _buildDateListTile(
                      context,
                      'Начало',
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

                    _buildDateListTile(
                      context,
                      'Конец',
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

                    _buildSortingListTile(
                      context,
                      'Сортировка',
                      state.sortBy == 'date' ? 'По дате' : 'По сумме',
                      () {
                        _showSortingDialog(context, state.sortBy);
                      },
                    ),

                    _buildSummaryListTile(
                      'Сумма',
                      '${state.totalAmount} ${state.currency == 'RUB' ? '₽' : state.currency}',
                    ),
                  ],
                ),
              ),
              // Список транзакций
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
                                  'Нет ${state.isIncome ? 'доходов' : 'расходов'} за выбранный период',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
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
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: state.transactions.length,
                              itemBuilder: (context, index) {
                                return TransactionListItem(
                                  transaction: state.transactions[index],
                                );
                              },
                            ),
                          ),
                ),
              ),
            ],
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
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, color: AppColors.textDark),
      ),
      trailing: Text(
        value,
        style: const TextStyle(fontSize: 16, color: AppColors.textDark),
      ),
      onTap: onTap,
    );
  }

  Widget _buildSortingListTile(
    BuildContext context,
    String title,
    String value,
    VoidCallback onTap,
  ) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, color: AppColors.textDark),
      ),
      trailing: Text(
        value,
        style: const TextStyle(fontSize: 16, color: AppColors.textDark),
      ),
      onTap: onTap,
    );
  }

  Widget _buildSummaryListTile(String title, String value) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, color: AppColors.textDark),
      ),
      trailing: Text(
        value,
        style: const TextStyle(fontSize: 16, color: AppColors.textDark),
      ),
    );
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
          title: const Text('Выберите сортировку'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('По дате'),
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
                title: const Text('По сумме'),
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
