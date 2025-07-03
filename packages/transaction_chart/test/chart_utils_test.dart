import 'package:flutter_test/flutter_test.dart';
import 'package:transaction_chart/src/utils/chart_utils.dart';
import 'package:transaction_chart/src/models/transaction_chart_config.dart';

void main() {
  group('ChartUtils', () {
    test('calculatePercentages should correctly calculate percentages', () {
      final sections = [
        const ChartSectionData(categoryName: 'Food', value: 300, percentage: 0),
        const ChartSectionData(categoryName: 'Transport', value: 200, percentage: 0),
        const ChartSectionData(categoryName: 'Entertainment', value: 100, percentage: 0),
      ];

      final result = ChartUtils.calculatePercentages(sections);

      expect(result[0].percentage, equals(50.0)); // 300/600 * 100
      expect(result[1].percentage, equals(33.333333333333336)); // 200/600 * 100  
      expect(result[2].percentage, equals(16.666666666666668)); // 100/600 * 100
    });

    test('formatCurrency should format with 2 decimal places', () {
      expect(ChartUtils.formatCurrency(123.456), equals('123.46 ₽'));
      expect(ChartUtils.formatCurrency(100.0), equals('100.00 ₽'));
      expect(ChartUtils.formatCurrency(99.9), equals('99.90 ₽'));
    });

    test('formatPercentage should format with 1 decimal place', () {
      expect(ChartUtils.formatPercentage(33.333), equals('33.3%'));
      expect(ChartUtils.formatPercentage(100.0), equals('100.0%'));
      expect(ChartUtils.formatPercentage(0.1), equals('0.1%'));
    });

    test('truncateText should handle text overflow correctly', () {
      expect(ChartUtils.truncateText('Short', 10), equals('Short'));
      expect(ChartUtils.truncateText('This is a very long category name', 15), 
        equals('This is a ve...'));
      expect(ChartUtils.truncateText('Exactly15Chars!', 15), equals('Exactly15Chars!'));
    });

    test('calculateFadeProgress should handle animation phases correctly', () {
      // First half: fade out (1.0 -> 0.0)
      expect(ChartUtils.calculateFadeProgress(0.0), equals(1.0));
      expect(ChartUtils.calculateFadeProgress(0.25), equals(0.5));
      expect(ChartUtils.calculateFadeProgress(0.5), equals(0.0));
      
      // Second half: fade in (0.0 -> 1.0)
      expect(ChartUtils.calculateFadeProgress(0.75), equals(0.5));
      expect(ChartUtils.calculateFadeProgress(1.0), equals(1.0));
    });

    test('shouldShowOldContent should switch at 0.5', () {
      expect(ChartUtils.shouldShowOldContent(0.0), isTrue);
      expect(ChartUtils.shouldShowOldContent(0.49), isTrue);
      expect(ChartUtils.shouldShowOldContent(0.5), isFalse);
      expect(ChartUtils.shouldShowOldContent(0.51), isFalse);
      expect(ChartUtils.shouldShowOldContent(1.0), isFalse);
    });

    test('validateChartData should catch invalid data', () {
      expect(ChartUtils.validateChartData([]), isNotNull);
      
      const validData = [
        ChartSectionData(categoryName: 'Valid', value: 100, percentage: 0),
      ];
      expect(ChartUtils.validateChartData(validData), isNull);

      const negativeValue = [
        ChartSectionData(categoryName: 'Invalid', value: -100, percentage: 0),
      ];
      expect(ChartUtils.validateChartData(negativeValue), isNotNull);

      const emptyName = [
        ChartSectionData(categoryName: '', value: 100, percentage: 0),
      ];
      expect(ChartUtils.validateChartData(emptyName), isNotNull);
    });
  });
}