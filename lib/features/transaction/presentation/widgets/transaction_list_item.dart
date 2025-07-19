import 'package:flutter/material.dart';
import 'package:shrm_homework_app/config/theme/app_colors.dart';
import 'package:shrm_homework_app/core/widgets/currency_display.dart';
import 'package:shrm_homework_app/features/transaction/data/models/transaction_response/transaction_response.dart';

class TransactionListItem extends StatelessWidget {
  final TransactionResponse transaction;
  final bool? showAvatar;
  final bool? showTime;
  final GestureTapCallback? onTap;
  const TransactionListItem({
    super.key,
    required this.transaction,
    this.showAvatar,
    this.showTime,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            radius: 14,
            child: Text(
              transaction.category.emoji,
              style: const TextStyle(fontSize: 20),
            ),
          ),

          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(transaction.category.name),
                  if (transaction.comment?.isNotEmpty ?? false)
                    Text(transaction.comment!),
                ],
              ),
              CurrencyDisplay(
                transaction: transaction,
                showTime: showTime,
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

          onTap: onTap,
        ),
      ],
    );
  }
}
