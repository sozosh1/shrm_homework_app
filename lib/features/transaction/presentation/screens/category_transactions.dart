import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:shrm_homework_app/features/transaction/domain/models/category_analysis_item.dart';
import 'package:shrm_homework_app/features/transaction/presentation/widgets/transaction_list_item.dart';

@RoutePage()
class CategoryTransactionsScreen extends StatelessWidget {
  final CategoryAnalysisItem item;

  const CategoryTransactionsScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item.category.name)),
      body: ListView.separated(
        separatorBuilder: (context, index) => Divider(),
        itemCount: item.transactions.length,
        itemBuilder: (context, index) {
          
          final sortedTransactions = List.of(item.transactions)
            ..sort((a, b) => b.transactionDate.compareTo(a.transactionDate));
          return TransactionListItem(transaction: sortedTransactions[index]);
        },
      ),
    );
  }
}
