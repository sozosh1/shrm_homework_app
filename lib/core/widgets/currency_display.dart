import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shrm_homework_app/core/di/di.dart';
import 'package:shrm_homework_app/core/services/currency_service.dart';
import 'package:shrm_homework_app/core/utils/currency_formatter.dart';
import 'package:shrm_homework_app/features/transaction/data/models/transaction_response/transaction_response.dart';

class CurrencyDisplay extends StatelessWidget {
  final TransactionResponse? transaction;
  final double amount;
  final String? accountCurrency;
  final TextStyle? style;
  final TextAlign? textAlign;
  final bool? showTime;
  const CurrencyDisplay({
    super.key,
    required this.amount,
    this.accountCurrency,
    this.style,
    this.textAlign,
    this.showTime,
    this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    final currencyService = getIt<CurrencyService>();

    return StreamBuilder<String>(
      stream: currencyService.currencyStream,
      builder: (context, snapshot) {
        final currency =
            accountCurrency ?? snapshot.data ?? currencyService.currentCurrency;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              CurrencyFormatter.format(amount, currency),
              style: style,
              textAlign: textAlign,
            ),
            if (showTime ?? false)
              Text(
                DateFormat.Hm().format(
                  transaction?.updatedAt ?? transaction!.createdAt,
                ),
                style: TextStyle(fontSize: 10),
              ),
          ],
        );
      },
    );
  }
}
