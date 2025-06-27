import 'package:flutter/material.dart';
import 'package:shrm_homework_app/config/theme/app_colors.dart';
import 'package:shrm_homework_app/core/utils/currency_formatter.dart';
import 'package:shrm_homework_app/features/transaction/data/models/transaction_response/transaction_response.dart';

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
              Text(
                CurrencyFormatter.format(
                  transaction.amount,
                  transaction.account.currency,
                ),
              ),
            ],
          ),

          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey,
          ),
          onTap: () {
            // TODO: Добавить детальный просмотр транзакции
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Транзакция: ${transaction.category.name}'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
        ),
        Divider(height: 0.5, thickness: 0.5),
      ],
    );
  }
}
