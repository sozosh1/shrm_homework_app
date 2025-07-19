import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:shrm_homework_app/core/di/di.dart';
import 'package:shrm_homework_app/core/widgets/currency_display.dart';
import 'package:shrm_homework_app/core/widgets/error_widget.dart';
import 'package:shrm_homework_app/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:shrm_homework_app/features/transaction/presentation/bloc/transaction_event.dart';
import 'package:shrm_homework_app/features/transaction/presentation/bloc/transaction_state.dart';
import 'package:shrm_homework_app/features/transaction/presentation/widgets/transaction_form_screen.dart';
import 'package:shrm_homework_app/features/transaction/presentation/widgets/transaction_list_item.dart';
import 'package:shrm_homework_app/config/router/app_router.dart';
import 'package:shrm_homework_app/core/services/haptic_service.dart';
import 'package:shrm_homework_app/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:shrm_homework_app/generated/l10n.dart';

class TransactionsScreen extends StatelessWidget {
  final bool isIncome;

  const TransactionsScreen({super.key, required this.isIncome});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              getIt<TransactionBloc>()..add(
                TransactionEvent.loadTodayTransactions(isIncome: isIncome),
              ),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                isIncome
                    ? S.of(context).incomeToday
                    : S.of(context).expenseToday,
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.history),
                  onPressed: () {
                    context.router.push(
                      TransactionHistoryRoute(isIncome: isIncome),
                    );
                  },
                ),
              ],
            ),
            body: TransactionsView(isIncome: isIncome),
            floatingActionButton: FloatingActionButton(
              heroTag: 'add transaction',
              shape: const CircleBorder(),
              elevation: 0.0,
              onPressed: () async {
                final settingsCubit = context.read<SettingsCubit>();
                if (settingsCubit.state.hapticFeedbackEnabled) {
                  HapticService.lightImpact();
                }
                final bloc = context.read<TransactionBloc>();
                final result = await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  useSafeArea: true,
                  builder:
                      (_) => BlocProvider.value(
                        value: bloc,
                        child: FractionallySizedBox(
                          heightFactor: 1,
                          child: TransactionFormScreen(isIncome: isIncome),
                        ),
                      ),
                );
                if (result == true) {
                  bloc.add(
                    TransactionEvent.loadTodayTransactions(isIncome: isIncome),
                  );
                }
              },

              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}

class TransactionsView extends StatelessWidget {
  final bool isIncome;

  const TransactionsView({super.key, required this.isIncome});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        if (state is TransactionLoaded) {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.of(context).total,
                      style: const TextStyle(fontSize: 16),
                    ),
                    CurrencyDisplay(
                      amount: state.totalAmount,
                      accountCurrency: state.currency,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              Divider(height: 1),

              // Список транзакций
              Expanded(
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
                                state.isIncome ? S.of(context).noIncomeToday : S.of(context).noExpensesToday,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        )
                        : RefreshIndicator(
                          onRefresh: () async {
                            context.read<TransactionBloc>().add(
                              const TransactionEvent.refreshTransactions(),
                            );
                          },
                          child: ListView.separated(
                            separatorBuilder:
                                (context, index) => Divider(height: 0.5),
                            itemCount: state.transactions.length,
                            itemBuilder: (context, index) {
                              return TransactionListItem(
                                transaction: state.transactions[index],
                                onTap: () async {
                                  final bloc = context.read<TransactionBloc>();
                                  final result = await showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    useSafeArea: true,
                                    builder:
                                        (_) => BlocProvider.value(
                                          value: bloc,
                                          child: FractionallySizedBox(
                                            heightFactor: 0.9,
                                            child: TransactionFormScreen(
                                              isIncome: state.isIncome,
                                              transaction:
                                                  state.transactions[index],
                                            ),
                                          ),
                                        ),
                                  );
                                  if (result == true) {
                                    bloc.add(
                                      TransactionEvent.loadTodayTransactions(
                                        isIncome: isIncome,
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                          ),
                        ),
              ),
            ],
          );
        } else if (state is TransactionError) {
          return AppErrorWidget(
            message: state.message,
            onRetry: () {
              context.read<TransactionBloc>().add(
                TransactionEvent.loadTodayTransactions(isIncome: isIncome),
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
