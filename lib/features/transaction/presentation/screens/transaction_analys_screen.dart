import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shrm_homework_app/config/router/app_router.dart';
import 'package:shrm_homework_app/config/theme/app_colors.dart';
import 'package:shrm_homework_app/core/di/di.dart';
import 'package:shrm_homework_app/core/utils/currency_formatter.dart';
import 'package:shrm_homework_app/core/widgets/error_widget.dart';
import 'package:shrm_homework_app/features/transaction/domain/models/category_analysis_item.dart';
import 'package:shrm_homework_app/features/transaction/presentation/bloc/transaction_history/transaction_history_bloc.dart';
import 'package:shrm_homework_app/features/transaction/presentation/bloc/transaction_history/transaction_history_event.dart';
import 'package:shrm_homework_app/features/transaction/presentation/bloc/transaction_history/transaction_history_state.dart';

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
          return Column(
            children: [
              Container(
                color: AppColors.lightGreenBackground,
                child: Column(
                  children: [
                    const Divider(thickness: 0.5, height: 0.5),
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
                    const Divider(height: 0.5, thickness: 0.5),
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
                    const Divider(height: 0.5, thickness: 0.5),
                    _buildSummaryListTile(
                      'Сумма',
                      CurrencyFormatter.format(
                        state.totalAmount,
                        state.currency,
                      ),
                    ),
                    const Divider(height: 0.5, thickness: 0.5),
                  ],
                ),
              ),
              Expanded(
                child:
                    state.analysisItems.isEmpty
                        ? Center(
                          child: Text(
                            'Нет данных для анализа за выбранный период',
                          ),
                        )
                        : ListView.builder(
                          itemCount: state.analysisItems.length,
                          itemBuilder: (context, index) {
                            final item = state.analysisItems[index];
                            return CategoryAnalysisListItem(item: item);
                          },
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

  Widget _buildSummaryListTile(String title, String value) {
    return ListTile(title: Text(title), trailing: Text(value));
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
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: AppColors.lightGreenBackground,
            radius: 20,
            child: Text(
              item.category.emodji,
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
              Text(
                CurrencyFormatter.format(
                  item.totalAmount,
                  item.lastTransaction.account.currency,
                ),
              ),
            ],
          ),
          onTap: () {
            context.router.push(CategoryTransactionsRoute(item: item));
          },
        ),
        const Divider(height: 0.5, thickness: 0.5),
      ],
    );
  }
}
