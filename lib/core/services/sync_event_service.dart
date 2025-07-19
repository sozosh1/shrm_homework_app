
import 'package:injectable/injectable.dart';
import 'package:shrm_homework_app/core/database/app_database.dart';
import 'package:talker_flutter/talker_flutter.dart';

enum EntityType { transaction, account, category }

enum Operation { create, update, delete }

class SyncEvent {
  final int id;
  final EntityType entityType;
  final int entityId;
  final Operation operation;
  final DateTime createdAt;

  SyncEvent({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.operation,
    required this.createdAt,
  });
}

abstract class SyncEventService {
  Future<void> addEvent(EntityType entityType, int entityId, Operation operation);
  Future<List<SyncEvent>> getEvents();
  Future<void> deleteEvent(int id);
}

@Injectable(as: SyncEventService)
class SyncEventServiceImpl implements SyncEventService {
  final AppDatabase _database;
  final Talker _talker;

  SyncEventServiceImpl(this._database, this._talker);

  @override
  Future<void> addEvent(EntityType entityType, int entityId, Operation operation) async {
    try {
      await _database.into(_database.syncEventsTable).insert(
            SyncEventsTableCompanion.insert(
              entityType: entityType.toString(),
              entityId: entityId,
              operation: operation.toString(),
              createdAt: DateTime.now(),
            ),
          );
    } catch (e, s) {
      _talker.handle(e, s);
    }
  }

  @override
  Future<List<SyncEvent>> getEvents() async {
    try {
      final dbEvents = await _database.select(_database.syncEventsTable).get();
      return dbEvents.map((e) {
        return SyncEvent(
          id: e.id,
          entityType: EntityType.values.firstWhere((t) => t.toString() == e.entityType),
          entityId: e.entityId,
          operation: Operation.values.firstWhere((o) => o.toString() == e.operation),
          createdAt: e.createdAt,
        );
      }).toList();
    } catch (e, s) {
      _talker.handle(e, s);
      return [];
    }
  }

  @override
  Future<void> deleteEvent(int id) async {
    try {
      await (_database.delete(_database.syncEventsTable)..where((t) => t.id.equals(id))).go();
    } catch (e, s) {
      _talker.handle(e, s);
    }
  }
}