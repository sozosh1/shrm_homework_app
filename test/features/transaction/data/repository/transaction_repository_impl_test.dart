import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shrm_homework_app/core/services/sync_event_service.dart';
import 'package:shrm_homework_app/features/transaction/data/datasources/local_transaction_data_source.dart';
import 'package:shrm_homework_app/features/transaction/data/datasources/remote_transaction_datasource.dart';
import 'package:shrm_homework_app/features/transaction/data/models/transaction_request/transaction_request.dart';
import 'package:shrm_homework_app/features/transaction/data/models/transaction_response/transaction_response.dart';
import 'package:shrm_homework_app/features/transaction/data/repository/transaction_repository_impl.dart';
import 'package:shrm_homework_app/features/account/data/models/account_brief/account_brief.dart';
import 'package:shrm_homework_app/features/category/data/models/category/category.dart';
import 'package:talker_flutter/talker_flutter.dart';


class MockLocalTransactionDataSource extends Mock implements LocalTransactionDataSource {}
class MockRemoteTransactionDataSource extends Mock implements RemoteTransactionDataSource {}
class MockSyncEventService extends Mock implements SyncEventService {}
class MockTalker extends Mock implements Talker {}

void main() {
  group('TransactionRepositoryImpl должен', () {
    late TransactionRepositoryImpl repository;
    late MockLocalTransactionDataSource mockLocalDataSource;
    late MockRemoteTransactionDataSource mockRemoteDataSource;
    late MockSyncEventService mockSyncEventService;
    late MockTalker mockTalker;

  
    final testTransactionRequest = TransactionRequest(
      accountId: 1,
      categoryId: 2,
      amount: 100.0,
      transactionDate: DateTime(2024, 1, 15),
      comment: 'Test transaction',
    );

    final testTransactionResponse = TransactionResponse(
      id: 1,
      account: const AccountBrief(
        id: 1,
        name: 'Test Account',
        balance: 1000.0,
        currency: 'RUB',
      ),
      category: const Category(
        id: 2,
        name: 'Test Category',
        emoji: '💰',
        isIncome: true,
      ),
      amount: 100.0,
      transactionDate: DateTime(2024, 1, 15),
      comment: 'Test transaction',
      createdAt: DateTime(2024, 1, 15, 10, 0),
      updatedAt: DateTime(2024, 1, 15, 10, 0),
    );

    final testSyncEvent = SyncEvent(
      id: 1,
      entityType: EntityType.transaction,
      entityId: 1,
      operation: Operation.create,
      createdAt: DateTime(2024, 1, 15),
    );

    setUpAll(() {
      
      registerFallbackValue(testTransactionRequest);
      registerFallbackValue(EntityType.transaction);
      registerFallbackValue(Operation.create);
      registerFallbackValue(<TransactionResponse>[]);
      registerFallbackValue(DateTime.now());
      registerFallbackValue(StackTrace.empty);
    });

    setUp(() {
      mockLocalDataSource = MockLocalTransactionDataSource();
      mockRemoteDataSource = MockRemoteTransactionDataSource();
      mockSyncEventService = MockSyncEventService();
      mockTalker = MockTalker();

      repository = TransactionRepositoryImpl(
        mockLocalDataSource,
        mockRemoteDataSource,
        mockSyncEventService,
        mockTalker,
      );
    });

    group('создавать транзакции', () {
      test('создать транзакцию локально и добавить событие синхронизации', () async {
        // Arrange
        when(() => mockLocalDataSource.createTransaction(any()))
            .thenAnswer((_) async => testTransactionResponse);
        when(() => mockSyncEventService.addEvent(
          any(),
          any(),
          any(),
        )).thenAnswer((_) async => {});

        // Act
        final result = await repository.createTransaction(testTransactionRequest);

        // Assert
        expect(result, equals(testTransactionResponse));
        verify(() => mockLocalDataSource.createTransaction(testTransactionRequest)).called(1);
        verify(() => mockSyncEventService.addEvent(
          EntityType.transaction,
          testTransactionResponse.id,
          Operation.create,
        )).called(1);
      });

      test('пробросить исключение при ошибке создания в локальном источнике', () async {
        // Arrange
        final exception = Exception('Local creation failed');
        when(() => mockLocalDataSource.createTransaction(any()))
            .thenThrow(exception);

        // Act & Assert
        expect(
          () => repository.createTransaction(testTransactionRequest),
          throwsA(equals(exception)),
        );
        verifyNever(() => mockSyncEventService.addEvent(any(), any(), any()));
      });

      test('пробросить исключение при ошибке добавления события синхронизации', () async {
        // Arrange
        final exception = Exception('Sync event failed');
        when(() => mockLocalDataSource.createTransaction(any()))
            .thenAnswer((_) async => testTransactionResponse);
        when(() => mockSyncEventService.addEvent(any(), any(), any()))
            .thenThrow(exception);

        // Act & Assert
        expect(
          () => repository.createTransaction(testTransactionRequest),
          throwsA(equals(exception)),
        );
        verify(() => mockLocalDataSource.createTransaction(testTransactionRequest)).called(1);
      });
    });

    group('получать транзакции', () {
      test('получить транзакцию с синхронизацией из удаленного источника', () async {
        // Arrange
        const transactionId = 1;
        when(() => mockSyncEventService.getEvents())
            .thenAnswer((_) async => []);
        when(() => mockRemoteDataSource.getTransaction(transactionId))
            .thenAnswer((_) async => testTransactionResponse);
        when(() => mockLocalDataSource.saveTransactions(any()))
            .thenAnswer((_) async => {});
        when(() => mockLocalDataSource.getTransaction(transactionId))
            .thenAnswer((_) async => testTransactionResponse);

        // Act
        final result = await repository.getTransaction(transactionId);

        // Assert
        expect(result, equals(testTransactionResponse));
        verify(() => mockSyncEventService.getEvents()).called(1);
        verify(() => mockRemoteDataSource.getTransaction(transactionId)).called(1);
        verify(() => mockLocalDataSource.saveTransactions([testTransactionResponse])).called(1);
        verify(() => mockLocalDataSource.getTransaction(transactionId)).called(1);
      });

      test('получить транзакцию из локального источника при ошибке синхронизации', () async {
        // Arrange
        const transactionId = 1;
        final exception = Exception('Remote sync failed');
        when(() => mockSyncEventService.getEvents())
            .thenAnswer((_) async => []);
        when(() => mockRemoteDataSource.getTransaction(any()))
            .thenThrow(exception);
        when(() => mockLocalDataSource.getTransaction(any()))
            .thenAnswer((_) async => testTransactionResponse);
        when(() => mockTalker.handle(any(), any(), any()))
            .thenReturn(null);

        // Act
        final result = await repository.getTransaction(transactionId);

        // Assert
        expect(result, equals(testTransactionResponse));
        verify(() => mockTalker.handle(exception, any(), 'Failed to sync getTransaction')).called(1);
        verify(() => mockLocalDataSource.getTransaction(transactionId)).called(1);
        verifyNever(() => mockLocalDataSource.saveTransactions(any()));
      });

      test('обработать события синхронизации перед получением транзакции', () async {
        // Arrange
        const transactionId = 1;
        when(() => mockSyncEventService.getEvents())
            .thenAnswer((_) async => [testSyncEvent]);
        when(() => mockLocalDataSource.getTransaction(testSyncEvent.entityId))
            .thenAnswer((_) async => testTransactionResponse);
        when(() => mockRemoteDataSource.createTransaction(any()))
            .thenAnswer((_) async => testTransactionResponse);
        when(() => mockLocalDataSource.saveTransactions(any()))
            .thenAnswer((_) async => {});
        when(() => mockSyncEventService.deleteEvent(any()))
            .thenAnswer((_) async => {});
        when(() => mockRemoteDataSource.getTransaction(any()))
            .thenAnswer((_) async => testTransactionResponse);
        when(() => mockLocalDataSource.getTransaction(transactionId))
            .thenAnswer((_) async => testTransactionResponse);

        // Act
        final result = await repository.getTransaction(transactionId);

        // Assert
        expect(result, equals(testTransactionResponse));
        verify(() => mockSyncEventService.getEvents()).called(1);
        verify(() => mockSyncEventService.deleteEvent(testSyncEvent.id)).called(1);
      });
    });

    group('обновлять транзакции', () {
      test('обновить транзакцию локально и добавить событие синхронизации', () async {
        // Arrange
        const transactionId = 1;
        when(() => mockLocalDataSource.updateTransaction(any(), any()))
            .thenAnswer((_) async => testTransactionResponse);
        when(() => mockSyncEventService.addEvent(any(), any(), any()))
            .thenAnswer((_) async => {});

        // Act
        final result = await repository.updateTransaction(transactionId, testTransactionRequest);

        // Assert
        expect(result, equals(testTransactionResponse));
        verify(() => mockLocalDataSource.updateTransaction(transactionId, testTransactionRequest)).called(1);
        verify(() => mockSyncEventService.addEvent(
          EntityType.transaction,
          testTransactionResponse.id,
          Operation.update,
        )).called(1);
      });

      test('пробросить исключение при ошибке обновления в локальном источнике', () async {
        // Arrange
        const transactionId = 1;
        final exception = Exception('Local update failed');
        when(() => mockLocalDataSource.updateTransaction(any(), any()))
            .thenThrow(exception);

        // Act & Assert
        expect(
          () => repository.updateTransaction(transactionId, testTransactionRequest),
          throwsA(equals(exception)),
        );
        verifyNever(() => mockSyncEventService.addEvent(any(), any(), any()));
      });
    });

    group('удалять транзакции', () {
      test('удалить транзакцию локально и добавить событие синхронизации', () async {
        // Arrange
        const transactionId = 1;
        when(() => mockLocalDataSource.getTransaction(any()))
            .thenAnswer((_) async => testTransactionResponse);
        when(() => mockLocalDataSource.deleteTransaction(any()))
            .thenAnswer((_) async => {});
        when(() => mockSyncEventService.addEvent(any(), any(), any()))
            .thenAnswer((_) async => {});

        // Act
        await repository.deleteTransaction(transactionId);

        // Assert
        verify(() => mockLocalDataSource.getTransaction(transactionId)).called(1);
        verify(() => mockLocalDataSource.deleteTransaction(transactionId)).called(1);
        verify(() => mockSyncEventService.addEvent(
          EntityType.transaction,
          testTransactionResponse.id,
          Operation.delete,
        )).called(1);
      });

      test('пробросить исключение при ошибке получения транзакции для удаления', () async {
        // Arrange
        const transactionId = 1;
        final exception = Exception('Transaction not found');
        when(() => mockLocalDataSource.getTransaction(any()))
            .thenThrow(exception);

        // Act & Assert
        expect(
          () => repository.deleteTransaction(transactionId),
          throwsA(equals(exception)),
        );
        verifyNever(() => mockLocalDataSource.deleteTransaction(any()));
        verifyNever(() => mockSyncEventService.addEvent(any(), any(), any()));
      });
    });

    group('получать транзакции по периоду', () {
      final testTransactionsList = [testTransactionResponse];
      final startDate = DateTime(2024, 1, 1);
      final endDate = DateTime(2024, 1, 31);
      const accountId = 1;

      test('получить транзакции с синхронизацией из удаленного источника', () async {
        // Arrange
        when(() => mockSyncEventService.getEvents())
            .thenAnswer((_) async => []);
        when(() => mockRemoteDataSource.getTransactionsByPeriod(
          any(),
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
        )).thenAnswer((_) async => testTransactionsList);
        when(() => mockLocalDataSource.saveTransactions(any()))
            .thenAnswer((_) async => {});
        when(() => mockLocalDataSource.getTransactionsByPeriod(
          any(),
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
        )).thenAnswer((_) async => testTransactionsList);

        // Act
        final result = await repository.getTransactionsByPeriod(
          accountId,
          startDate: startDate,
          endDate: endDate,
        );

        // Assert
        expect(result, equals(testTransactionsList));
        verify(() => mockRemoteDataSource.getTransactionsByPeriod(
          accountId,
          startDate: startDate,
          endDate: endDate,
        )).called(1);
        verify(() => mockLocalDataSource.saveTransactions(testTransactionsList)).called(1);
        verify(() => mockLocalDataSource.getTransactionsByPeriod(
          accountId,
          startDate: startDate,
          endDate: endDate,
        )).called(1);
      });

      test('использовать даты по умолчанию когда они не указаны', () async {
        // Arrange
        when(() => mockSyncEventService.getEvents())
            .thenAnswer((_) async => []);
        when(() => mockRemoteDataSource.getTransactionsByPeriod(
          any(),
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
        )).thenAnswer((_) async => testTransactionsList);
        when(() => mockLocalDataSource.saveTransactions(any()))
            .thenAnswer((_) async => {});
        when(() => mockLocalDataSource.getTransactionsByPeriod(
          any(),
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
        )).thenAnswer((_) async => testTransactionsList);

        // Act
        final result = await repository.getTransactionsByPeriod(accountId);

        // Assert
        expect(result, equals(testTransactionsList));
        verify(() => mockRemoteDataSource.getTransactionsByPeriod(
          accountId,
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
        )).called(1);
      });

      test('получить транзакции из локального источника при ошибке синхронизации', () async {
        // Arrange
        final exception = Exception('Remote sync failed');
        when(() => mockSyncEventService.getEvents())
            .thenAnswer((_) async => []);
        when(() => mockRemoteDataSource.getTransactionsByPeriod(
          any(),
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
        )).thenThrow(exception);
        when(() => mockLocalDataSource.getTransactionsByPeriod(
          any(),
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
        )).thenAnswer((_) async => testTransactionsList);
        when(() => mockTalker.handle(any(), any(), any()))
            .thenReturn(null);

        // Act
        final result = await repository.getTransactionsByPeriod(
          accountId,
          startDate: startDate,
          endDate: endDate,
        );

        // Assert
        expect(result, equals(testTransactionsList));
        verify(() => mockTalker.handle(exception, any(), 'Failed to sync getTransactionsByPeriod')).called(1);
        verify(() => mockLocalDataSource.getTransactionsByPeriod(
          accountId,
          startDate: startDate,
          endDate: endDate,
        )).called(1);
        verifyNever(() => mockLocalDataSource.saveTransactions(any()));
      });
    });

    group('обрабатывать события синхронизации', () {
      test('обработать событие создания транзакции', () async {
        // Arrange
        final createEvent = SyncEvent(
          id: 1,
          entityType: EntityType.transaction,
          entityId: 1,
          operation: Operation.create,
          createdAt: DateTime.now(),
        );
        when(() => mockSyncEventService.getEvents())
            .thenAnswer((_) async => [createEvent]);
        when(() => mockLocalDataSource.getTransaction(createEvent.entityId))
            .thenAnswer((_) async => testTransactionResponse);
        when(() => mockRemoteDataSource.createTransaction(any()))
            .thenAnswer((_) async => testTransactionResponse);
        when(() => mockLocalDataSource.saveTransactions(any()))
            .thenAnswer((_) async => {});
        when(() => mockSyncEventService.deleteEvent(any()))
            .thenAnswer((_) async => {});
        when(() => mockLocalDataSource.getTransaction(1))
            .thenAnswer((_) async => testTransactionResponse);

        // Act
        await repository.getTransaction(1);

        // Assert
        verify(() => mockRemoteDataSource.createTransaction(any())).called(1);
        verify(() => mockLocalDataSource.saveTransactions([testTransactionResponse])).called(1);
        verify(() => mockSyncEventService.deleteEvent(createEvent.id)).called(1);
      });

      test('обработать событие обновления транзакции', () async {
        // Arrange
        final updateEvent = SyncEvent(
          id: 2,
          entityType: EntityType.transaction,
          entityId: 1,
          operation: Operation.update,
          createdAt: DateTime.now(),
        );
        when(() => mockSyncEventService.getEvents())
            .thenAnswer((_) async => [updateEvent]);
        when(() => mockLocalDataSource.getTransaction(updateEvent.entityId))
            .thenAnswer((_) async => testTransactionResponse);
        when(() => mockRemoteDataSource.updateTransaction(any(), any()))
            .thenAnswer((_) async => testTransactionResponse);
        when(() => mockSyncEventService.deleteEvent(any()))
            .thenAnswer((_) async => {});
        when(() => mockRemoteDataSource.getTransaction(any()))
            .thenAnswer((_) async => testTransactionResponse);
        when(() => mockLocalDataSource.saveTransactions(any()))
            .thenAnswer((_) async => {});
        when(() => mockLocalDataSource.getTransaction(1))
            .thenAnswer((_) async => testTransactionResponse);

        // Act
        await repository.getTransaction(1);

        // Assert
        verify(() => mockRemoteDataSource.updateTransaction(testTransactionResponse.id, any())).called(1);
        verify(() => mockSyncEventService.deleteEvent(updateEvent.id)).called(1);
      });

      test('обработать событие удаления транзакции', () async {
        // Arrange
        final deleteEvent = SyncEvent(
          id: 3,
          entityType: EntityType.transaction,
          entityId: 1,
          operation: Operation.delete,
          createdAt: DateTime.now(),
        );
        when(() => mockSyncEventService.getEvents())
            .thenAnswer((_) async => [deleteEvent]);
        when(() => mockLocalDataSource.getTransaction(deleteEvent.entityId))
            .thenAnswer((_) async => testTransactionResponse);
        when(() => mockRemoteDataSource.deleteTransaction(any()))
            .thenAnswer((_) async => {});
        when(() => mockSyncEventService.deleteEvent(any()))
            .thenAnswer((_) async => {});
        when(() => mockRemoteDataSource.getTransaction(any()))
            .thenAnswer((_) async => testTransactionResponse);
        when(() => mockLocalDataSource.saveTransactions(any()))
            .thenAnswer((_) async => {});
        when(() => mockLocalDataSource.getTransaction(1))
            .thenAnswer((_) async => testTransactionResponse);

        // Act
        await repository.getTransaction(1);

        // Assert
        verify(() => mockRemoteDataSource.deleteTransaction(testTransactionResponse.id)).called(1);
        verify(() => mockSyncEventService.deleteEvent(deleteEvent.id)).called(1);
      });

      test('пропустить события не связанные с транзакциями', () async {
        // Arrange
        final accountEvent = SyncEvent(
          id: 4,
          entityType: EntityType.account,
          entityId: 1,
          operation: Operation.create,
          createdAt: DateTime.now(),
        );
        when(() => mockSyncEventService.getEvents())
            .thenAnswer((_) async => [accountEvent]);
        when(() => mockSyncEventService.deleteEvent(any()))
            .thenAnswer((_) async => {});
        when(() => mockRemoteDataSource.getTransaction(any()))
            .thenAnswer((_) async => testTransactionResponse);
        when(() => mockLocalDataSource.saveTransactions(any()))
            .thenAnswer((_) async => {});
        when(() => mockLocalDataSource.getTransaction(1))
            .thenAnswer((_) async => testTransactionResponse);

        // Act
        await repository.getTransaction(1);

        // Assert
        // Событие account должно быть удалено, но не обработано как транзакция
        verify(() => mockSyncEventService.deleteEvent(accountEvent.id)).called(1);
        // Основная операция getTransaction(1) должна выполниться
        verify(() => mockRemoteDataSource.getTransaction(1)).called(1);
        verify(() => mockLocalDataSource.saveTransactions([testTransactionResponse])).called(1);
        verify(() => mockLocalDataSource.getTransaction(1)).called(1);
        // Проверяем, что методы для обработки транзакций не вызывались для account события
        verifyNever(() => mockLocalDataSource.getTransaction(accountEvent.entityId));
        verifyNever(() => mockRemoteDataSource.createTransaction(any()));
      });

      test('обработать ошибку при синхронизации события и продолжить', () async {
        // Arrange
        final createEvent = SyncEvent(
          id: 5,
          entityType: EntityType.transaction,
          entityId: 1,
          operation: Operation.create,
          createdAt: DateTime.now(),
        );
        final exception = Exception('Sync event processing failed');
        when(() => mockSyncEventService.getEvents())
            .thenAnswer((_) async => [createEvent]);
        when(() => mockLocalDataSource.getTransaction(createEvent.entityId))
            .thenThrow(exception);
        when(() => mockRemoteDataSource.getTransaction(any()))
            .thenAnswer((_) async => testTransactionResponse);
        when(() => mockLocalDataSource.saveTransactions(any()))
            .thenAnswer((_) async => {});
        when(() => mockLocalDataSource.getTransaction(1))
            .thenAnswer((_) async => testTransactionResponse);
        when(() => mockTalker.handle(any(), any(), any()))
            .thenReturn(null);

        // Act
        await repository.getTransaction(1);

        // Assert
        verify(() => mockTalker.handle(any(), any(), any())).called(1);
        verifyNever(() => mockSyncEventService.deleteEvent(createEvent.id));
        // Основная операция должна продолжиться
        verify(() => mockLocalDataSource.getTransaction(1)).called(2); // Один раз в sync, один раз в основной операции
      });
    });
  });
}