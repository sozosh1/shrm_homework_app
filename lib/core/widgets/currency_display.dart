import 'package:flutter/material.dart';
import 'package:shrm_homework_app/core/di/di.dart';
import 'package:shrm_homework_app/core/services/currency_service.dart';
import 'package:shrm_homework_app/core/utils/currency_formatter.dart';

class CurrencyDisplay extends StatelessWidget {
  final double amount;
  final String? accountCurrency;
  final TextStyle? style;
  final TextAlign? textAlign;

  const CurrencyDisplay({
    super.key,
    required this.amount,
    this.accountCurrency,
    this.style,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    final currencyService = getIt<CurrencyService>();
    
    return StreamBuilder<String>(
      stream: currencyService.currencyStream,
      builder: (context, snapshot) {
        final currency = accountCurrency ?? snapshot.data ?? currencyService.currentCurrency;
        
        return Text(
          CurrencyFormatter.format(amount, currency),
          style: style,
          textAlign: textAlign,
        );
      },
    );
  }
} 