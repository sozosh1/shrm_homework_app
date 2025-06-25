import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:sqlite3/sqlite3.dart';

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
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        await _insertInitialCategories();
      },
    );
  }

  Future<void> _insertInitialCategories() async {
    await batch((batch) {
      batch.insertAll(categoriesTable, [
        CategoriesTableCompanion.insert(
          id: const Value(1),
          name: 'Зарплата',
          emoji: '💰',
          isIncome: true,
        ),
        CategoriesTableCompanion.insert(
          id: const Value(2),
          name: 'Фриланс',
          emoji: '💰',
          isIncome: true,
        ),
        CategoriesTableCompanion.insert(
          id: const Value(3),
          name: 'Продукты',
          emoji: '🛒',
          isIncome: true,
        ),
        CategoriesTableCompanion.insert(
          id: const Value(4),
          name: 'Транспорт',
          emoji: '🚗',
          isIncome: false,
        ),
        CategoriesTableCompanion.insert(
          id: const Value(5),
          name: 'Развлечения',
          emoji: '🎬',
          isIncome: false,
        ),
      ]);
    });
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app_database.db'));

    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }
    final cachebase = (await getTemporaryDirectory()).path;
    sqlite3.tempDirectory = cachebase;
    return NativeDatabase.createInBackground(file);
  });
}
