import 'package:drift/drift.dart';
import 'package:shrm_homework_app/core/database/tables/accounts_table.dart';
import 'package:shrm_homework_app/core/database/tables/categories_table.dart';

class TransactionsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get accountId => integer().references(AccountsTable, #id)();
  IntColumn get categoryId => integer().references(CategoriesTable, #id)();
  RealColumn get amount => real()();
  TextColumn get comment => text()();
  DateTimeColumn get transactionDate => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  String get tableName => 'transactions';
}
