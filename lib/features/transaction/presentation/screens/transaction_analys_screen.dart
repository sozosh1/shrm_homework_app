import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shrm_homework_app/core/di/di.dart';
import 'package:shrm_homework_app/core/utils/currency_formatter.dart';
import 'package:shrm_homework_app/features/transaction/presentation/bloc/transaction_history/transaction_history_bloc.dart';
import 'package:shrm_homework_app/features/transaction/presentation/bloc/transaction_history/transaction_history_event.dart';
import 'package:shrm_homework_app/features/transaction/presentation/bloc/transaction_history/transaction_history_state.dart';

class TransactionAnalysScreen extends StatelessWidget {
  final bool isIncome;
  const TransactionAnalysScreen({super.key, required this.isIncome});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<TransactionHistoryBloc>()
        ..add(TransactionHistoryEvent.loadTransactionAnalysisByPeriod(
          startDate: DateTime.now().subtract(const Duration(days: 30)),
          endDate: DateTime.now(),
          isIncome: isIncome,
        )),
      child: Scaffold(
        appBar: AppBar(title: const Text('Анализ')),
        body: BlocBuilder<TransactionHistoryBloc, TransactionHistoryState>(
          builder: (context, state) {
            if (state is TransactionHistoryLoading ||
                state is TransactionHistoryInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is TransactionAnalysisLoaded) {
              return Column(
                children: [
                  // Фильтры и сумма
                  Container(
                    color: Colors.grey[100],
                    child: Column(
                      children: [
                        const Divider(thickness: 0.5, height: 0.5),
                        ListTile(
                          title: const Text('Период: начало'),
                          trailing: Text(_formatDate(state.startDate)),
                          onTap: () async {
                            final selectedDate = await showDatePicker(
                              context: context,
                              initialDate: state.startDate,
                              firstDate: DateTime(2020),
                              lastDate: state.endDate,
                            );
                            if (selectedDate != null) {
                              context.read<TransactionHistoryBloc>().add(
                                TransactionHistoryEvent.loadTransactionAnalysisByPeriod(
                                  startDate: selectedDate,
                                  endDate: state.endDate,
                                  isIncome: isIncome,
                                ),
                              );
                            }
                          },
                        ),
                        const Divider(height: 0.5, thickness: 0.5),
                        ListTile(
                          title: const Text('Период: конец'),
                          trailing: Text(_formatDate(state.endDate)),
                          onTap: () async {
                            final selectedDate = await showDatePicker(
                              context: context,
                              initialDate: state.endDate,
                              firstDate: state.startDate,
                              lastDate: DateTime.now(),
                            );
                            if (selectedDate != null) {
                              context.read<TransactionHistoryBloc>().add(
                                TransactionHistoryEvent.loadTransactionAnalysisByPeriod(
                                  startDate: state.startDate,
                                  endDate: selectedDate,
                                  isIncome: isIncome,
                                ),
                              );
                            }
                          },
                        ),
                        const Divider(height: 0.5, thickness: 0.5),
                        ListTile(
                          title: const Text('Сумма'),
                          trailing: Text(
                            CurrencyFormatter.format(
                              state.totalAmount,
                              state.currency,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Список категорий
                  Expanded(
                    child: state.items.isEmpty
                        ? const Center(
                            child: Text('Нет данных за выбранный период'),
                          )
                        : ListView.builder(
                            itemCount: state.items.length,
                            itemBuilder: (context, index) {
                              final item = state.items[index];
                              return ListTile(
                                leading: CircleAvatar(
                                  child: Text(item.category.emodji),
                                ),
                                title: Text(item.category.name),
                                subtitle:
                                    item.lastTransaction != null
                                        ? Text(
                                            'Последняя: '
                                            '${_formatDate(item.lastTransaction!.transactionDate)} — '
                                            '${item.lastTransaction!.comment ?? ''}',
                                          )
                                        : const Text('Нет транзакций'),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${((item.totalAmount / (state.totalAmount == 0 ? 1 : state.totalAmount)) * 100).toStringAsFixed(0)}%',
                                    ),
                                    Text(
                                      CurrencyFormatter.format(
                                        item.totalAmount,
                                        state.currency,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  // TODO: переход к списку транзакций по категории
                                },
                              );
                            },
                          ),
                  ),
                ],
              );
            }
            if (state is TransactionHistoryError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
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
    return '${months[date.month - 1]} ${date.year}';
  }
}
