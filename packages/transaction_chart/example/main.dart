import 'package:flutter/material.dart';
import 'package:transaction_chart/transaction_chart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Transaction Chart Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ChartDemoScreen(),
    );
  }
}

class ChartDemoScreen extends StatefulWidget {
  const ChartDemoScreen({super.key});

  @override
  State<ChartDemoScreen> createState() => _ChartDemoScreenState();
}

class _ChartDemoScreenState extends State<ChartDemoScreen> {
  List<ChartSectionData> _currentData = [];
  int _dataSetIndex = 0;

  final List<List<ChartSectionData>> _dataSets = [
    [
      const ChartSectionData(
        categoryName: 'Food & Dining',
        value: 450.75,
        percentage: 45.0,
        categoryIcon: '🍔',
      ),
      const ChartSectionData(
        categoryName: 'Transportation',
        value: 280.50,
        percentage: 28.0,
        categoryIcon: '🚗',
      ),
      const ChartSectionData(
        categoryName: 'Entertainment',
        value: 170.25,
        percentage: 17.0,
        categoryIcon: '🎬',
      ),
      const ChartSectionData(
        categoryName: 'Shopping',
        value: 100.00,
        percentage: 10.0,
        categoryIcon: '🛒',
      ),
    ],
    [
      const ChartSectionData(
        categoryName: 'Groceries',
        value: 320.80,
        percentage: 40.0,
        categoryIcon: '🥗',
      ),
      const ChartSectionData(
        categoryName: 'Utilities',
        value: 240.60,
        percentage: 30.0,
        categoryIcon: '⚡',
      ),
      const ChartSectionData(
        categoryName: 'Healthcare',
        value: 160.40,
        percentage: 20.0,
        categoryIcon: '🏥',
      ),
      const ChartSectionData(
        categoryName: 'Education',
        value: 80.20,
        percentage: 10.0,
        categoryIcon: '📚',
      ),
    ],
  ];

  @override
  void initState() {
    super.initState();
    _currentData = _dataSets[0];
  }

  void _switchData() {
    setState(() {
      _dataSetIndex = (_dataSetIndex + 1) % _dataSets.length;
      _currentData = _dataSets[_dataSetIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Chart Demo'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Interactive Transaction Pie Chart',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap sections to see details, or switch data to see animation',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: TransactionPieChart(
                sections: _currentData,
                config: const TransactionChartConfig(
                  showLegend: true,
                  showTooltips: true,
                  animationDuration: Duration(milliseconds: 1000),
                  maxCategoryNameLength: 18,
                  radius: 120,
                  centerSpaceRadius: 50,
                ),
                onSectionTap: (section) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${section.categoryName}: ${ChartUtils.formatCurrency(section.value)}',
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _switchData,
              icon: const Icon(Icons.refresh),
              label: const Text('Switch Data Set'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Current Data Set: ${_dataSetIndex + 1}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}