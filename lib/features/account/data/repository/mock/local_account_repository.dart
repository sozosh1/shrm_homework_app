// import 'package:drift/drift.dart';
// import 'package:injectable/injectable.dart';
// import 'package:intl/intl.dart';
// import 'package:shrm_homework_app/core/database/app_database.dart';
// import 'package:shrm_homework_app/features/account/data/models/account_responce/account_response.dart';
// import 'package:shrm_homework_app/features/account/data/models/account_update_request/account_update_request.dart';
// import 'package:shrm_homework_app/features/account/data/models/stat_item/stat_item.dart';
// import 'package:shrm_homework_app/features/account/data/models/account/account.dart';
// import 'package:shrm_homework_app/features/account/domain/repository/account_repository.dart';
// import 'package:talker_flutter/talker_flutter.dart';

// @Injectable(as: AccountRepository)
// class LocalAccountRepository implements AccountRepository {
  
//   static const _accountId = 1;
//   final AppDatabase _database;

//   LocalAccountRepository(this._database);
//   final Talker _talker = Talker();

//   @override
//   Future<AccountResponse> getAccount(int id) async {
    
//     final account = await _getAccountInternal();
//     final stats = await _getAccountStats();

//     return AccountResponse(
//       id: account.id,
//       name: account.name,
//       balance: account.balance,
//       currency: account.currency,
//       incomeStats: stats.incomeStats,
//       expenseStats: stats.expenseStats,
//       createdAt: account.createdAt,
//       updatedAt: account.updatedAt,
//     );
//   }

//   @override
//   Future<Account> updateAccount(int id, AccountUpdateRequest request) async {
    
//     await (_database.update(_database.accountsTable)
//       ..where((t) => t.id.equals(_accountId))).write(
//       AccountsTableCompanion(
//         name: Value(request.name),
//         balance: Value(request.balance),
//         currency: Value(request.currency),
//         updatedAt: Value(DateTime.now()),
//       ),
//     );

//     return _getAccountInternal();
//   }

//   Future<Account> _getAccountInternal() async {
//     final data =
//         await (_database.select(_database.accountsTable)
//           ..where((t) => t.id.equals(_accountId))).getSingle();
//     return Account(
//       id: data.id,
//       userId: 1,
//       name: data.name,
//       balance: data.balance,
//       currency: data.currency,
//       createdAt: data.createdAt,
//       updatedAt: data.updatedAt,
//     );
//   }

//   Future<({List<StatItem> incomeStats, List<StatItem> expenseStats})>
//   _getAccountStats() async {
//     final transactions =
//         await (_database.select(_database.transactionsTable)
//           ..where((t) => t.accountId.equals(_accountId))).get();

//     final categories = await _database.select(_database.categoriesTable).get();
    
//     final categoriesMap = {for (var c in categories) c.id: c};

//     final incomeStats = <StatItem>[];
//     final expenseStats = <StatItem>[];

//     final statsMap = <int, double>{};

//     for (final t in transactions) {
//       final category = categoriesMap[t.categoryId];
//       if (category == null) continue;

//       statsMap.update(
//         category.id,
//         (value) => value + t.amount,
//         ifAbsent: () => t.amount,
//       );
//     }

//     for (final e in statsMap.entries) {
//       final category = categoriesMap[e.key]!;
//       final stat = StatItem(
//         categoryId: category.id,
//         categoryName: category.name,
//         emoji: category.emoji,
//         amount: e.value,
//       );

//       if (category.isIncome) {
//         incomeStats.add(stat);
//       } else {
//         expenseStats.add(stat);
//       }
//     }
//     return (incomeStats: incomeStats, expenseStats: expenseStats);
//   }

  
//   @override
//   Stream<List<Map<String, dynamic>>> getTransactionHistoryStream() {
//     _talker.info(
//       'Starting transaction history stream for account $_accountId at ${DateTime.now()}',
//     );

    
//     return _database
//         .select(_database.transactionsTable)
//         .watch()
//         .asyncMap((transactions) async {
//           _talker.info(
//             'Processing ${transactions.length} transactions for account $_accountId',
//           );

//           if (transactions.isEmpty) {
//             _talker.warning('No transactions found for account $_accountId');
//             return [
//               {'type': 'daily', 'data': []},
//               {'type': 'monthly', 'data': []},
//             ];
//           }

          
//           final categories =
//               await _database.select(_database.categoriesTable).get();
//           final categoriesMap = {for (var c in categories) c.id: c};

//           final now = DateTime.now(); 
//           final dateFormat = DateFormat('yyyy-MM-dd');
//           final monthFormat = DateFormat('yyyy-MM');

//           // Агрегация по дням (последние 30 дней) с разделением на доходы и расходы
//           final dailyIncomeTotal = <String, double>{};
//           final dailyExpenseTotal = <String, double>{};

//           for (var tx in transactions) {
//             if (tx.accountId == _accountId) {
//               final dateKey = dateFormat.format(tx.transactionDate);
//               final category = categoriesMap[tx.categoryId];

//               if (category != null) {
//                 if (category.isIncome) {
//                   dailyIncomeTotal[dateKey] =
//                       (dailyIncomeTotal[dateKey] ?? 0) + tx.amount;
//                 } else {
//                   dailyExpenseTotal[dateKey] =
//                       (dailyExpenseTotal[dateKey] ?? 0) + tx.amount;
//                 }
//               }
//             }
//           }

//           final dailyData = <Map<String, dynamic>>[];
//           for (int i = 0; i < 30; i++) {
//             final date = now.subtract(Duration(days: i));
//             final dateKey = dateFormat.format(date);
//             final incomeAmount = dailyIncomeTotal[dateKey] ?? 0.0;
//             final expenseAmount = dailyExpenseTotal[dateKey] ?? 0.0;

//             // Добавляем доходы и расходы как отдельные записи
//             if (incomeAmount > 0) {
//               dailyData.insert(0, {
//                 'date': date,
//                 'amount': incomeAmount,
//                 'isIncome': true,
//               });
//             }

//             if (expenseAmount > 0) {
//               dailyData.insert(0, {
//                 'date': date,
//                 'amount': expenseAmount,
//                 'isIncome': false,
//               });
//             }

//             // Если нет данных за день, добавляем нулевую запись
//             if (incomeAmount == 0 && expenseAmount == 0) {
//               dailyData.insert(0, {
//                 'date': date,
//                 'amount': 0.0,
//                 'isIncome': true, // По умолчанию
//               });
//             }
//           }

//           // Агрегация по месяцам (последние 12 месяцев) с разделением на доходы и расходы
//           final monthlyIncomeTotal = <String, double>{};
//           final monthlyExpenseTotal = <String, double>{};

//           for (var tx in transactions) {
//             if (tx.accountId == _accountId) {
//               final monthKey = monthFormat.format(tx.transactionDate);
//               final category = categoriesMap[tx.categoryId];

//               if (category != null) {
//                 if (category.isIncome) {
//                   monthlyIncomeTotal[monthKey] =
//                       (monthlyIncomeTotal[monthKey] ?? 0) + tx.amount;
//                 } else {
//                   monthlyExpenseTotal[monthKey] =
//                       (monthlyExpenseTotal[monthKey] ?? 0) + tx.amount;
//                 }
//               }
//             }
//           }

//           final monthlyData = <Map<String, dynamic>>[];
//           for (int i = 0; i < 12; i++) {
//             final date = DateTime(now.year, now.month - i);
//             final monthKey = monthFormat.format(date);
//             final lastDay = DateTime(date.year, date.month + 1, 0);
//             final incomeAmount = monthlyIncomeTotal[monthKey] ?? 0.0;
//             final expenseAmount = monthlyExpenseTotal[monthKey] ?? 0.0;

//             // Добавляем доходы и расходы как отдельные записи
//             if (incomeAmount > 0) {
//               monthlyData.insert(0, {
//                 'date': lastDay,
//                 'amount': incomeAmount,
//                 'isIncome': true,
//               });
//             }

//             if (expenseAmount > 0) {
//               monthlyData.insert(0, {
//                 'date': lastDay,
//                 'amount': expenseAmount,
//                 'isIncome': false,
//               });
//             }

//             // Если нет данных за месяц, добавляем нулевую запись
//             if (incomeAmount == 0 && expenseAmount == 0) {
//               monthlyData.insert(0, {
//                 'date': lastDay,
//                 'amount': 0.0,
//                 'isIncome': true, // По умолчанию
//               });
//             }
//           }

//           final result = [
//             {'type': 'daily', 'data': dailyData},
//             {'type': 'monthly', 'data': monthlyData},
//           ];
//           _talker.info('Generated history data: $result');
//           return result;
//         })
//         .handleError((error, stackTrace) {
//           _talker.error(
//             'Error in transaction history stream: $error',
//             stackTrace,
//           );
//           return [
//             {'type': 'daily', 'data': []},
//             {'type': 'monthly', 'data': []},
//           ];
//         });
//   }
// }
