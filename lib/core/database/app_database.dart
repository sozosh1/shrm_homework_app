import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'tables/accounts_table.dart';
import 'tables/categories_table.dart';
import 'tables/transactions_table.dart';
import 'tables/backup_operations_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    AccountsTable,
    CategoriesTable,
    TransactionsTable,
    BackUpOperationsTable,
  ],
)
@singleton
class AppDatabase extends _$AppDatabase with ChangeNotifier {
  final Talker _talker;

  AppDatabase(this._talker) : super(_openConnection(_talker));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        _talker.log('🎯 Database tables created');

        await _insertInitialCategories();
        _talker.log('📂 Initial categories inserted');

        await _insertInitialAccount();
        _talker.log('💳 Initial account inserted');

        await _insertSampleTransactions();
        _talker.log('💰 Sample transactions inserted');

        // Проверка вставленных данных после миграции
        final transactions = await select(transactionsTable).get();
        _talker.info(
          '✅ Verified ${transactions.length} transactions after migration',
        );
      },
      onUpgrade: (Migrator m, int from, int to) async {
        _talker.log('🔄 Database upgraded from $from to $to');
      },
    );
  }

  Future<TransactionsTableData> createTransaction({
    required int accountId,
    required int categoryId,
    required double amount,
    required String comment,
    DateTime? transactionDate,
  }) async {
    _talker.info('💰 Creating transaction: $amount for account $accountId');
    try {
      final transaction = await into(transactionsTable).insertReturning(
        TransactionsTableCompanion.insert(
          accountId: accountId,
          categoryId: categoryId,
          amount: amount,
          comment: Value(comment),
          transactionDate: transactionDate ?? DateTime.now(),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
      _talker.info('✅ Transaction created successfully: ID ${transaction.id}');
      // Уведомляем поток об изменении
      notifyListeners();
      return transaction;
    } catch (e, stackTrace) {
      _talker.error('❌ Failed to create transaction', e, stackTrace);
      rethrow;
    }
  }

  Stream<List<Map<String, dynamic>>> getTransactionHistoryStream() {
    _talker.info('Starting transaction history stream at ${DateTime.now()}');
    return select(transactionsTable)
        .watch()
        .asyncMap((transactions) async {
          _talker.info('Processing ${transactions.length} raw transactions');
          final filteredTransactions =
              transactions.where((t) => t.accountId == 1).toList();
          _talker.info(
            'Filtered transactions for account 1: ${filteredTransactions.length}',
          );

          if (filteredTransactions.isEmpty) {
            _talker.warning('No transactions found for account 1');
            return [
              {'type': 'daily', 'data': []},
              {'type': 'monthly', 'data': []},
            ];
          }

          final now = DateTime.now();
          final dateFormat = DateFormat('yyyy-MM-dd');
          final monthFormat = DateFormat('yyyy-MM');

          // Получаем данные о категориях для определения типа транзакции
          final categories = await select(categoriesTable).get();
          final categoriesMap = {for (var c in categories) c.id: c};

          // Агрегация по дням (последние 30 дней) с разделением на доходы и расходы
          final dailyIncomeTotal = <String, double>{};
          final dailyExpenseTotal = <String, double>{};

          for (var tx in filteredTransactions) {
            final dateKey = dateFormat.format(tx.transactionDate);
            final category = categoriesMap[tx.categoryId];

            if (category != null) {
              if (category.isIncome) {
                dailyIncomeTotal[dateKey] =
                    (dailyIncomeTotal[dateKey] ?? 0) + tx.amount;
              } else {
                dailyExpenseTotal[dateKey] =
                    (dailyExpenseTotal[dateKey] ?? 0) + tx.amount;
              }
            }
            _talker.debug(
              'Daily aggregation: $dateKey -> Income: ${dailyIncomeTotal[dateKey] ?? 0}, Expense: ${dailyExpenseTotal[dateKey] ?? 0}',
            );
          }

          final dailyData = <Map<String, dynamic>>[];
          for (int i = 0; i < 30; i++) {
            final date = now.subtract(Duration(days: i));
            final dateKey = dateFormat.format(date);
            final incomeAmount = dailyIncomeTotal[dateKey] ?? 0.0;
            final expenseAmount = dailyExpenseTotal[dateKey] ?? 0.0;

            // Добавляем доходы и расходы как отдельные записи
            if (incomeAmount > 0) {
              dailyData.insert(0, {
                'date': date,
                'amount': incomeAmount,
                'isIncome': true,
              });
            }

            if (expenseAmount > 0) {
              dailyData.insert(0, {
                'date': date,
                'amount': expenseAmount,
                'isIncome': false,
              });
            }

            // Если нет данных за день, добавляем нулевую запись
            if (incomeAmount == 0 && expenseAmount == 0) {
              dailyData.insert(0, {
                'date': date,
                'amount': 0.0,
                'isIncome': true, // По умолчанию
              });
            }
          }

          // Агрегация по месяцам (последние 12 месяцев) с разделением на доходы и расходы
          final monthlyIncomeTotal = <String, double>{};
          final monthlyExpenseTotal = <String, double>{};

          for (var tx in filteredTransactions) {
            final monthKey = monthFormat.format(tx.transactionDate);
            final category = categoriesMap[tx.categoryId];

            if (category != null) {
              if (category.isIncome) {
                monthlyIncomeTotal[monthKey] =
                    (monthlyIncomeTotal[monthKey] ?? 0) + tx.amount;
              } else {
                monthlyExpenseTotal[monthKey] =
                    (monthlyExpenseTotal[monthKey] ?? 0) + tx.amount;
              }
            }
            _talker.debug(
              'Monthly aggregation: $monthKey -> Income: ${monthlyIncomeTotal[monthKey] ?? 0}, Expense: ${monthlyExpenseTotal[monthKey] ?? 0}',
            );
          }

          final monthlyData = <Map<String, dynamic>>[];
          for (int i = 0; i < 12; i++) {
            final date = DateTime(now.year, now.month - i);
            final monthKey = monthFormat.format(date);
            final lastDay = DateTime(date.year, date.month + 1, 0);
            final incomeAmount = monthlyIncomeTotal[monthKey] ?? 0.0;
            final expenseAmount = monthlyExpenseTotal[monthKey] ?? 0.0;

            // Добавляем доходы и расходы как отдельные записи
            if (incomeAmount > 0) {
              monthlyData.insert(0, {
                'date': lastDay,
                'amount': incomeAmount,
                'isIncome': true,
              });
            }

            if (expenseAmount > 0) {
              monthlyData.insert(0, {
                'date': lastDay,
                'amount': expenseAmount,
                'isIncome': false,
              });
            }

            // Если нет данных за месяц, добавляем нулевую запись
            if (incomeAmount == 0 && expenseAmount == 0) {
              monthlyData.insert(0, {
                'date': lastDay,
                'amount': 0.0,
                'isIncome': true, // По умолчанию
              });
            }
          }

          final result = [
            {'type': 'daily', 'data': dailyData},
            {'type': 'monthly', 'data': monthlyData},
          ];
          _talker.info('Generated history data: $result');
          return result;
        })
        .handleError((error, stackTrace) {
          _talker.error(
            'Error in transaction history stream: $error',
            stackTrace,
          );
          return [
            {'type': 'daily', 'data': []},
            {'type': 'monthly', 'data': []},
          ];
        });
  }

  Future<List<TransactionsTableData>> getAllTransactions() async {
    _talker.info('📊 Fetching all transactions');
    try {
      final transactions = await select(transactionsTable).get();
      _talker.info('✅ Retrieved ${transactions.length} transactions');
      return transactions;
    } catch (e, stackTrace) {
      _talker.error('❌ Failed to fetch transactions', e, stackTrace);
      rethrow;
    }
  }

  Future<void> _insertInitialCategories() async {
    _talker.debug('📝 Inserting initial categories...');
    await batch((batch) {
      batch.insertAll(categoriesTable, [
        CategoriesTableCompanion.insert(
          id: const Value(1),
          name: 'Зарплата',
          emodji: '💰',
          isIncome: true,
        ),
        CategoriesTableCompanion.insert(
          id: const Value(2),
          name: 'Фриланс',
          emodji: '💰',
          isIncome: true,
        ),
        CategoriesTableCompanion.insert(
          id: const Value(3),
          name: 'Продукты',
          emodji: '🛒',
          isIncome: false,
        ),
        CategoriesTableCompanion.insert(
          id: const Value(4),
          name: 'Транспорт',
          emodji: '🚗',
          isIncome: false,
        ),
        CategoriesTableCompanion.insert(
          id: const Value(5),
          name: 'Развлечения',
          emodji: '🎬',
          isIncome: false,
        ),
      ]);
    });
  }

  Future<void> _insertInitialAccount() async {
    _talker.debug('💳 Inserting initial account...');
    final now = DateTime.now();
    await into(accountsTable).insert(
      AccountsTableCompanion.insert(
        name: 'Основной счет',
        balance: 100.0,
        currency: const Value('RUB'),
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  Future<void> _insertSampleTransactions() async {
    _talker.debug('💰 Inserting sample transactions...');
    final now = DateTime.now();
    final random = Random();

    final transactions = <TransactionsTableCompanion>[];

    // Генерация данных за последние 6 месяцев
    for (int monthOffset = 0; monthOffset < 6; monthOffset++) {
      final monthDate = DateTime(now.year, now.month - monthOffset);
      final daysInMonth = DateTime(monthDate.year, monthDate.month + 1, 0).day;

      // 1. Добавляем доходы (зарплата + фриланс)

      // Зарплата (в начале месяца)
      transactions.add(
        TransactionsTableCompanion.insert(
          accountId: 1,
          categoryId: 1,
          amount: 75000 + random.nextDouble() * 10000, // 75-85 тыс.
          comment: Value('Зарплата за ${DateFormat('MMMM')}'),
          transactionDate: monthDate.add(const Duration(days: 5)),
          createdAt: monthDate.add(const Duration(days: 5)),
          updatedAt: monthDate.add(const Duration(days: 5)),
        ),
      );

      // Фриланс (1-3 раза в месяц)
      final freelanceCount = 1 + random.nextInt(2);
      for (int i = 0; i < freelanceCount; i++) {
        transactions.add(
          TransactionsTableCompanion.insert(
            accountId: 1,
            categoryId: 2,
            amount: 10000 + random.nextDouble() * 20000, // 10-30 тыс.
            comment: Value('Проект ${i + 1} (${DateFormat('MMMM')})'),
            transactionDate: monthDate.add(
              Duration(days: 10 + random.nextInt(15)),
            ),
            createdAt: monthDate.add(Duration(days: 10 + random.nextInt(15))),
            updatedAt: monthDate.add(Duration(days: 10 + random.nextInt(15))),
          ),
        );
      }

      // 2. Добавляем регулярные расходы (продукты, транспорт)

      // Продукты (2-4 раза в месяц)
      final groceriesCount = 2 + random.nextInt(3);
      for (int i = 0; i < groceriesCount; i++) {
        transactions.add(
          TransactionsTableCompanion.insert(
            accountId: 1,
            categoryId: 3,
            amount: (2000 + random.nextInt(3000)).toDouble(),
            comment: Value(_getGroceriesComment(random)),
            transactionDate: monthDate.add(
              Duration(days: random.nextInt(daysInMonth)),
            ),
            createdAt: monthDate.add(
              Duration(days: random.nextInt(daysInMonth)),
            ),
            updatedAt: monthDate.add(
              Duration(days: random.nextInt(daysInMonth)),
            ),
          ),
        );
      }

      // Транспорт (3-6 раз в месяц)
      final transportCount = 3 + random.nextInt(4);
      for (int i = 0; i < transportCount; i++) {
        transactions.add(
          TransactionsTableCompanion.insert(
            accountId: 1,
            categoryId: 4,
            amount: (500 + random.nextInt(1500)).toDouble(), 
            comment: Value(_getTransportComment(random)),
            transactionDate: monthDate.add(
              Duration(days: random.nextInt(daysInMonth)),
            ),
            createdAt: monthDate.add(
              Duration(days: random.nextInt(daysInMonth)),
            ),
            updatedAt: monthDate.add(
              Duration(days: random.nextInt(daysInMonth)),
            ),
          ),
        );
      }

      // 3. Добавляем развлечения (1-2 раза в месяц)
      final entertainmentCount = 1 + random.nextInt(2);
      for (int i = 0; i < entertainmentCount; i++) {
        transactions.add(
          TransactionsTableCompanion.insert(
            accountId: 1,
            categoryId: 5,
            amount: (1000 + random.nextInt(4000)).toDouble(), 
            comment: Value(_getEntertainmentComment(random)),
            transactionDate: monthDate.add(
              Duration(days: random.nextInt(daysInMonth)),
            ),
            createdAt: monthDate.add(
              Duration(days: random.nextInt(daysInMonth)),
            ),
            updatedAt: monthDate.add(
              Duration(days: random.nextInt(daysInMonth)),
            ),
          ),
        );
      }
    }

    // Добавляем несколько специальных транзакций
    final specialTransactions = [
      
      TransactionsTableCompanion.insert(
        accountId: 1,
        categoryId: 3,
        amount: -12500.0,
        comment: Value('Оплата годового запаса кофе'),
        transactionDate: DateTime(now.year, now.month - 2, 15),
        createdAt: DateTime(now.year, now.month - 2, 15),
        updatedAt: DateTime(now.year, now.month - 2, 15),
      ),
     
      TransactionsTableCompanion.insert(
        accountId: 1,
        categoryId: 2,
        amount: 4500.0,
        comment: Value('Возврат за отмененный заказ'),
        transactionDate: DateTime(now.year, now.month - 1, 20),
        createdAt: DateTime(now.year, now.month - 1, 20),
        updatedAt: DateTime(now.year, now.month - 1, 20),
      ),
    ];

    transactions.addAll(specialTransactions);

    await batch((batch) {
      batch.insertAll(transactionsTable, transactions);
    });
    _talker.info('✅ Inserted ${transactions.length} sample transactions');
  }
}

String _getGroceriesComment(Random random) {
  const comments = [
    'Продукты на неделю',
    'Супермаркет',
    'Овощи и фрукты',
    'Молочные продукты',
    'Мясо и рыба',
    'Бакалея',
    'Детское питание',
  ];
  return comments[random.nextInt(comments.length)];
}

String _getTransportComment(Random random) {
  const comments = [
    'Такси до работы',
    'Метро',
    'Автобус',
    'Заправка',
    'Парковка',
    'Каршеринг',
  ];
  return comments[random.nextInt(comments.length)];
}

String _getEntertainmentComment(Random random) {
  const comments = [
    'Поход в кино',
    'Концерт',
    'Ресторан',
    'Билеты в театр',
    'Подписка на стриминг',
    'Квест-комната',
  ];
  return comments[random.nextInt(comments.length)];
}

LazyDatabase _openConnection(Talker talker) {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app_database.db'));

    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }
    final cachebase = (await getTemporaryDirectory()).path;
    sqlite3.tempDirectory = cachebase;

    talker.info('📂 Database path: ${file.path}');

    final executor = NativeDatabase.createInBackground(file);
    return _LoggedDatabaseExecutor(executor, talker);
  });
}

class _LoggedDatabaseExecutor extends QueryExecutor {
  final QueryExecutor _executor;
  final Talker _talker;

  _LoggedDatabaseExecutor(this._executor, this._talker);

  @override
  SqlDialect get dialect => _executor.dialect;

  @override
  Future<bool> ensureOpen(QueryExecutorUser user) async {
    _talker.debug('🔓 Ensuring database connection is open');
    final result = await _executor.ensureOpen(user);
    _talker.info('✅ Database connection established');
    return result;
  }

  @override
  Future<void> runBatched(BatchedStatements statements) async {
    _talker.info(
      '📦 Executing batch with ${statements.statements.length} statements',
    );
    final stopwatch = Stopwatch()..start();
    try {
      await _executor.runBatched(statements);
      stopwatch.stop();
      _talker.info(
        '✅ Batch executed successfully in ${stopwatch.elapsedMilliseconds}ms',
      );
    } catch (e, stackTrace) {
      stopwatch.stop();
      _talker.error(
        '❌ Batch execution failed after ${stopwatch.elapsedMilliseconds}ms',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<int> runDelete(String statement, List<Object?> args) async {
    _talker.debug('🗑️ DELETE: $statement');
    _talker.verbose('📊 Args: $args');
    final stopwatch = Stopwatch()..start();
    try {
      final result = await _executor.runDelete(statement, args);
      stopwatch.stop();
      _talker.info(
        '✅ DELETE completed in ${stopwatch.elapsedMilliseconds}ms, affected rows: $result',
      );
      return result;
    } catch (e, stackTrace) {
      stopwatch.stop();
      _talker.error(
        '❌ DELETE failed after ${stopwatch.elapsedMilliseconds}ms',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<int> runInsert(String statement, List<Object?> args) async {
    _talker.debug('➕ INSERT: $statement');
    _talker.verbose('📊 Args: $args');
    final stopwatch = Stopwatch()..start();
    try {
      final result = await _executor.runInsert(statement, args);
      stopwatch.stop();
      _talker.info(
        '✅ INSERT completed in ${stopwatch.elapsedMilliseconds}ms, ID: $result',
      );
      return result;
    } catch (e, stackTrace) {
      stopwatch.stop();
      _talker.error(
        '❌ INSERT failed after ${stopwatch.elapsedMilliseconds}ms',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<List<Map<String, Object?>>> runSelect(
    String statement,
    List<Object?> args,
  ) async {
    _talker.debug('🔍 SELECT: $statement');
    _talker.verbose('📊 Args: $args');
    final stopwatch = Stopwatch()..start();
    try {
      final result = await _executor.runSelect(statement, args);
      stopwatch.stop();
      _talker.info(
        '✅ SELECT completed in ${stopwatch.elapsedMilliseconds}ms, returned ${result.length} rows',
      );
      return result;
    } catch (e, stackTrace) {
      stopwatch.stop();
      _talker.error(
        '❌ SELECT failed after ${stopwatch.elapsedMilliseconds}ms',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<int> runUpdate(String statement, List<Object?> args) async {
    _talker.debug('✏️ UPDATE: $statement');
    _talker.verbose('📊 Args: $args');
    final stopwatch = Stopwatch()..start();
    try {
      final result = await _executor.runUpdate(statement, args);
      stopwatch.stop();
      _talker.info(
        '✅ UPDATE completed in ${stopwatch.elapsedMilliseconds}ms, affected rows: $result',
      );
      return result;
    } catch (e, stackTrace) {
      stopwatch.stop();
      _talker.error(
        '❌ UPDATE failed after ${stopwatch.elapsedMilliseconds}ms',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<void> runCustom(String statement, [List<Object?>? args]) async {
    _talker.debug('⚙️ CUSTOM: $statement');
    _talker.verbose('📊 Args: $args');
    final stopwatch = Stopwatch()..start();
    try {
      await _executor.runCustom(statement, args);
      stopwatch.stop();
      _talker.info('✅ CUSTOM completed in ${stopwatch.elapsedMilliseconds}ms');
    } catch (e, stackTrace) {
      stopwatch.stop();
      _talker.error(
        '❌ CUSTOM failed after ${stopwatch.elapsedMilliseconds}ms',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  @override
  TransactionExecutor beginTransaction() {
    _talker.info('🔄 BEGIN TRANSACTION');
    return _LoggedTransactionExecutor(_executor.beginTransaction(), _talker);
  }

  @override
  Future<void> close() async {
    _talker.info('🚪 Closing database connection');
    await _executor.close();
    _talker.info('✅ Database connection closed');
  }

  @override
  QueryExecutor beginExclusive() {
    _talker.debug('🔒 Starting exclusive transaction');
    return _executor.beginExclusive();
  }
}

class _LoggedTransactionExecutor extends TransactionExecutor {
  final TransactionExecutor _executor;
  final Talker _talker;

  _LoggedTransactionExecutor(this._executor, this._talker);

  @override
  SqlDialect get dialect => _executor.dialect;

  @override
  Future<bool> ensureOpen(QueryExecutorUser user) async {
    _talker.debug('🔓 [TX] Ensuring transaction connection is open');
    return await _executor.ensureOpen(user);
  }

  @override
  TransactionExecutor beginTransaction() {
    _talker.info('🔄 Starting nested transaction');
    return _LoggedTransactionExecutor(_executor.beginTransaction(), _talker);
  }

  @override
  Future<void> send() async {
    _talker.info('✅ COMMIT TRANSACTION');
    await _executor.send();
  }

  @override
  Future<void> rollback() async {
    _talker.warning('🔄 ROLLBACK TRANSACTION');
    await _executor.rollback();
  }

  @override
  Future<List<Map<String, Object?>>> runSelect(
    String statement,
    List<Object?> args,
  ) async {
    _talker.debug('🔍 [TX] SELECT: $statement');
    return _executor.runSelect(statement, args);
  }

  @override
  Future<int> runInsert(String statement, List<Object?> args) async {
    _talker.debug('➕ [TX] INSERT: $statement');
    return _executor.runInsert(statement, args);
  }

  @override
  Future<int> runUpdate(String statement, List<Object?> args) async {
    _talker.debug('✏️ [TX] UPDATE: $statement');
    return _executor.runUpdate(statement, args);
  }

  @override
  Future<int> runDelete(String statement, List<Object?> args) async {
    _talker.debug('🗑️ [TX] DELETE: $statement');
    return _executor.runDelete(statement, args);
  }

  @override
  Future<void> runCustom(String statement, [List<Object?>? args]) async {
    _talker.debug('⚙️ [TX] CUSTOM: $statement');
    await _executor.runCustom(statement, args);
  }

  @override
  Future<void> runBatched(BatchedStatements statements) async {
    _talker.info(
      '📦 [TX] Running batched statements: ${statements.statements.length} queries',
    );
    await _executor.runBatched(statements);
  }

  @override
  QueryExecutor beginExclusive() {
    _talker.debug('🔒 [TX] Starting exclusive transaction');
    return _executor.beginExclusive();
  }

  @override
  bool get supportsNestedTransactions => true;
}
