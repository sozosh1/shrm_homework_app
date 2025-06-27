import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:injectable/injectable.dart';
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
class AppDatabase extends _$AppDatabase {
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
          comment: comment,
          transactionDate: transactionDate ?? DateTime.now(),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
      _talker.info('✅ Transaction created successfully: ID ${transaction.id}');
      return transaction;
    } catch (e, stackTrace) {
      _talker.error('❌ Failed to create transaction', e, stackTrace);
      rethrow;
    }
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
        balance: 0.0,
        currency: const Value('RUB'),
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  Future<void> _insertSampleTransactions() async {
    _talker.debug('💰 Inserting sample transactions...');
    final now = DateTime.now();

    final transactions = <TransactionsTableCompanion>[
      TransactionsTableCompanion.insert(
        accountId: 1,
        categoryId: 1,
        amount: 80000.0,
        comment: 'Зарплата за май',
        transactionDate: now.subtract(const Duration(days: 5)),
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now.subtract(const Duration(days: 5)),
      ),
      TransactionsTableCompanion.insert(
        accountId: 1,
        categoryId: 2,
        amount: 25000.0,
        comment: 'Проект для стартапа',
        transactionDate: now.subtract(const Duration(days: 10)),
        createdAt: now.subtract(const Duration(days: 10)),
        updatedAt: now.subtract(const Duration(days: 10)),
      ),
      TransactionsTableCompanion.insert(
        accountId: 1,
        categoryId: 3,
        amount: -3500.0,
        comment: 'Продукты на неделю',
        transactionDate: now.subtract(const Duration(days: 2)),
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
      TransactionsTableCompanion.insert(
        accountId: 1,
        categoryId: 4,
        amount: -800.0,
        comment: 'Проездной на месяц',
        transactionDate: now.subtract(const Duration(days: 1)),
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
    ];

    await batch((batch) {
      batch.insertAll(transactionsTable, transactions);
    });
  }
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
