import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shrm_homework_app/config/router/app_router.dart';
import 'package:shrm_homework_app/config/theme/app_colors.dart';
import 'package:shrm_homework_app/core/di/di.dart';
import 'package:shrm_homework_app/core/widgets/currency_display.dart';
import 'package:shrm_homework_app/core/widgets/error_widget.dart';
import 'package:shrm_homework_app/features/transaction/domain/models/category_analysis_item.dart';
import 'package:shrm_homework_app/features/transaction/presentation/bloc/transaction_history/transaction_history_bloc.dart';
import 'package:shrm_homework_app/features/transaction/presentation/bloc/transaction_history/transaction_history_event.dart';
import 'package:shrm_homework_app/features/transaction/presentation/bloc/transaction_history/transaction_history_state.dart';
import 'package:transaction_chart/transaction_chart.dart';

@RoutePage()
class TransactionAnalysScreen extends StatelessWidget {
  final bool isIncome;

  const TransactionAnalysScreen({super.key, required this.isIncome});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              getIt<TransactionHistoryBloc>()..add(
                TransactionHistoryEvent.loadTransactionAnalysisByPeriod(
                  startDate: DateTime.now().subtract(const Duration(days: 30)),
                  endDate: DateTime.now(),
                  isIncome: isIncome,
                ),
              ),
      child: Scaffold(
        appBar: AppBar(title: const Text('Анализ')),
        body: TransactionAnalysView(isIncome: isIncome),
      ),
    );
  }
}

class TransactionAnalysView extends StatelessWidget {
  final bool isIncome;

  const TransactionAnalysView({super.key, required this.isIncome});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionHistoryBloc, TransactionHistoryState>(
      builder: (context, state) {
        if (state is TransactionHistoryInitial ||
            state is TransactionHistoryLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TransactionAnalysisLoaded) {
          final chartConfig = TransactionChartConfig(
            data:
                state.analysisItems
                    .map(
                      (item) => ChartData(
                        categoryName: item.category.name,
                        color:
                            item.category.isIncome
                                ? Colors.greenAccent
                                : Colors.yellowAccent,
                        percentage: item.percentage,
                        amount: item.totalAmount,
                      ),
                    )
                    .toList(),
            currency: state.currency,
            animate: true,
          );

          return Column(
            children: [
              Container(
                color: AppColors.lightGreenBackground,
                child: Column(
                  children: [
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
                    const Divider(),
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
                    const Divider(),
                    _buildSummaryListTile(
                      'Сумма',
                      CurrencyDisplay(
                        amount: state.totalAmount,
                        accountCurrency: state.currency,
                      ),
                    ),
                    const Divider(height: 1),
                  ],
                ),
              ),
              if (state.analysisItems.isEmpty)
                const Expanded(
                  child: Center(
                    child: Text('Нет данных для анализа за выбранный период'),
                  ),
                )
              else
                Expanded(
                  child: Column(
                    children: [
                      TransactionPieChart(config: chartConfig),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.separated(
                          separatorBuilder:
                              (context, index) => const Divider(height: 1),
                          itemCount: state.analysisItems.length,
                          itemBuilder: (context, index) {
                            final item = state.analysisItems[index];
                            return CategoryAnalysisListItem(item: item);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        } else if (state is TransactionHistoryError) {
          return AppErrorWidget(
            message: state.message,
            onRetry: () {
              // Handle retry
            },
          );
        }
        return const SizedBox.shrink();
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
}

class CategoryAnalysisListItem extends StatelessWidget {
  final CategoryAnalysisItem item;

  const CategoryAnalysisListItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    
    return Hero(
      tag: 'category_${item.category.id}',
      child: Material(
        type: MaterialType.transparency,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: AppColors.lightGreenBackground,
            radius: 20,
            child: Text(
              item.category.emoji,
              style: const TextStyle(fontSize: 24),
            ),
          ),
          title: Text(item.category.name),
          subtitle: Text(item.lastTransaction.comment ?? 'Нет комментария'),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${item.percentage.toStringAsFixed(0)}%',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                ),
              ),
              CurrencyDisplay(
                amount: item.totalAmount,
                accountCurrency: item.lastTransaction.account.currency,
              ),
            ],
          ),
          onTap: () {
            context.router.push(CategoryTransactionsRoute(item: item));
          },
        ),
      ),
    );
  }
}
