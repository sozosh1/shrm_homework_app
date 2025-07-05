
import 'dart:ui';

class TransactionChartConfig {
  final List<ChartData> data;
  final String currency;
  final bool animate;

  TransactionChartConfig({
    required this.data,
    required this.currency,
    required this.animate,
  });
}

class ChartData {
  final String categoryName;
  final Color color;
  final double percentage;
  final double amount;

  ChartData({
    required this.categoryName,
    required this.color,
    required this.percentage,
    required this.amount,
  });
}
