import 'package:drift/drift.dart';

class BackUpOperationsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get operationType => text()(); 
  TextColumn get entityType => text()(); 
  IntColumn get entityId => integer().nullable()();
  TextColumn get entityData => text()(); 
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  String get tableName => 'backup_operations';
}
