import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:shrm_homework_app/config/theme/app_colors.dart';
import 'package:shrm_homework_app/core/di/di.dart';
import 'package:shrm_homework_app/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:shrm_homework_app/features/transaction/presentation/bloc/transaction_event.dart';
import 'package:shrm_homework_app/features/transaction/presentation/bloc/transaction_state.dart';
import 'package:shrm_homework_app/features/transaction/presentation/widgets/transaction_list_item.dart';
import 'package:shrm_homework_app/config/router/app_router.dart';

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
      child: Scaffold(
        appBar: AppBar(
          title: Text(isIncome ? 'Доходы сегодня' : 'Расходы сегодня'),
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
        body: const TransactionsView(),
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          elevation: 0.0,
          onPressed: () {
            // TODO: Добавить экран создания транзакции
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Функция добавления транзакции в разработке'),
              ),
            );
          },
          backgroundColor: AppColors.primaryGreen,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}

class TransactionsView extends StatelessWidget {
  const TransactionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        if (state is TransactionLoaded) {
          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: AppColors.lightGreenBackground,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Всего',
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textDark,
                      ),
                    ),
                    Text(
                      '${state.totalAmount} ${state.currency == 'RUB' ? '₽' : ''}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ),
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
                                'Нет ${state.isIncome ? 'доходов' : 'расходов'} за сегодня',
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
                          child: ListView.builder(
                            itemCount: state.transactions.length,
                            itemBuilder: (context, index) {
                              return TransactionListItem(
                                transaction: state.transactions[index],
                              );
                            },
                          ),
                        ),
              ),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
