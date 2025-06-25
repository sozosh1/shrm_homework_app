import 'package:drift/drift.dart';

class AccountsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 255)();
  TextColumn get balance => text()();
  TextColumn get currency => text().withDefault(const Constant('RUB'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  String get tableName => 'accounts';
}
