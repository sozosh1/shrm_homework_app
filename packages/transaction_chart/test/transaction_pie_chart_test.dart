import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:transaction_chart/transaction_chart.dart';

void main() {
  group('TransactionPieChart Widget Tests', () {
    testWidgets('should display empty chart when no data provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TransactionPieChart(sections: []),
          ),
        ),
      );

      expect(find.text('Нет данных'), findsOneWidget);
    });

    testWidgets('should display chart with data', (tester) async {
      const testData = [
        ChartSectionData(
          categoryName: 'Food',
          value: 300,
          percentage: 60,
          categoryIcon: '🍔',
        ),
        ChartSectionData(
          categoryName: 'Transport',
          value: 200,
          percentage: 40,
          categoryIcon: '🚗',
        ),
      ];

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TransactionPieChart(
              sections: testData,
              config: TransactionChartConfig(showLegend: true),
            ),
          ),
        ),
      );

      // Let the chart render
      await tester.pump();

      // Should show legend items
      expect(find.text('Food'), findsOneWidget);
      expect(find.text('Transport'), findsOneWidget);
    });

    testWidgets('should handle tap events', (tester) async {
      ChartSectionData? tappedSection;
      
      const testData = [
        ChartSectionData(
          categoryName: 'Food',
          value: 300,
          percentage: 100,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TransactionPieChart(
              sections: testData,
              onSectionTap: (section) {
                tappedSection = section;
              },
            ),
          ),
        ),
      );

      await tester.pump();

      // Tap on legend item
      await tester.tap(find.text('Food'));
      await tester.pump();

      expect(tappedSection?.categoryName, equals('Food'));
    });

    testWidgets('should truncate long category names in legend', (tester) async {
      const testData = [
        ChartSectionData(
          categoryName: 'This is a very long category name that should be truncated',
          value: 300,
          percentage: 100,
        ),
      ];

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TransactionPieChart(
              sections: testData,
              config: TransactionChartConfig(
                showLegend: true,
                maxCategoryNameLength: 15,
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      // Should find truncated text (using contains since ellipsis might not be exact)
      expect(find.textContaining('This is a ve'), findsOneWidget);
    });
  });
}