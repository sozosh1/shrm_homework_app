import 'package:flutter/material.dart';
import 'package:shrm_homework_app/config/theme/app_colors.dart';
import 'package:shrm_homework_app/core/utils/currency_formatter.dart';
import 'package:shrm_homework_app/features/transaction/data/models/transaction_response/transaction_response.dart';

class TransactionListItem extends StatelessWidget {
  final TransactionResponse transaction;

  const TransactionListItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1.0),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.lightGreenBackground,
          radius: 12,
          child: Text(
            transaction.category.emodji,
            style: const TextStyle(fontSize: 20),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                transaction.category.name,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Text(
              CurrencyFormatter.format(
                transaction.amount,
                transaction.account.currency,
              ),

              style: TextStyle(fontSize: 16, color: AppColors.textDark),
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
    );
  }
}
