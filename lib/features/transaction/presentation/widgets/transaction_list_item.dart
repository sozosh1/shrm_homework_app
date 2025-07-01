import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shrm_homework_app/config/router/app_router.dart';
import 'package:shrm_homework_app/config/theme/app_colors.dart';
import 'package:shrm_homework_app/core/widgets/currency_display.dart';
import 'package:shrm_homework_app/features/transaction/data/models/transaction_response/transaction_response.dart';
import 'package:shrm_homework_app/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:shrm_homework_app/features/transaction/presentation/bloc/transaction_event.dart';

class TransactionListItem extends StatelessWidget {
  final TransactionResponse transaction;
  final bool? showAvatar;
  final bool? showTime;
  const TransactionListItem({
    super.key,
    required this.transaction,
    this.showAvatar,
    this.showTime,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(height: 0.5, thickness: 0.5),
        ListTile(
          leading: CircleAvatar(
            backgroundColor: AppColors.lightGreenBackground,
            radius: 12,
            child: Text(
              transaction.category.emodji,
              style: const TextStyle(fontSize: 20),
            ),
          ),

          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(transaction.category.name),
                  if (transaction.comment?.isNotEmpty ?? false)
                    Expanded(child: Text(transaction.comment!)),
                ],
              ),
              CurrencyDisplay(
                amount: transaction.amount,
                accountCurrency: transaction.account.currency,
              ),
            ],
          ),

          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey,
          ),
          onTap: () async {
            final result = await context.router.push(EditTransactionRoute(transaction: transaction));
            if (result == true && context.mounted) {
              // Try to refresh the transaction list if a TransactionBloc is available
              try {
                context.read<TransactionBloc>().add(
                  const TransactionEvent.refreshTransactions(),
                );
              } catch (e) {
                // If no TransactionBloc is available, that's fine
                // Other screens might handle refreshing differently
              }
            }
          },
        ),
        Divider(height: 0.5, thickness: 0.5),
      ],
    );
  }
}
