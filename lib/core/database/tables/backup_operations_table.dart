import 'package:drift/drift.dart';

class BackUpOperationsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get operationType => text()(); // create update delete
  TextColumn get entityType => text()();  // account transaction category
  IntColumn get entityId => integer().nullable()();
  TextColumn get entityData => text()(); //json data
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get syncedAt => dateTime().nullable()();
  TextColumn get syncError => text().nullable()();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();


  @override
  String get tableName => 'backup_operations';
}
