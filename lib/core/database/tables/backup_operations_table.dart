import 'package:drift/drift.dart';

class BackUpOperationsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get operationType => text()(); //create update delete
  TextColumn get entityType => text()(); // transactions account  categories
  IntColumn get entityId => integer().nullable()();
  TextColumn get entityData => text()(); // json
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  String get tableName => 'backup_operations';
}
