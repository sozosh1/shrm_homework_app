import 'package:drift/drift.dart';

class SyncEventsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entityType => text()();
  IntColumn get entityId => integer()();
  TextColumn get operation => text()();
  DateTimeColumn get createdAt => dateTime()();
}