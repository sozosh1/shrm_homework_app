import 'package:drift/drift.dart';

class CategoriesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 255)();
  TextColumn get emodji => text()();
  BoolColumn get isIncome => boolean()();

  @override
  String get tableName => 'categories';
}
