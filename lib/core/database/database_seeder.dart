import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:shrm_homework_app/core/database/app_database.dart';

@injectable
class DatabaseSeeder {
  final AppDatabase _database;

  DatabaseSeeder(this._database);

  /// Очистка и загрузка тестовых данных
  Future<void> seedDatabase() async {
    await _clearAllData();
    await _seedCategories();
    await _seedAccount();
    await _seedTransactions();
  }

  /// Добавление дополнительных тестовых данных без очистки
  Future<void> addMoreTestData() async {
    await _addRandomTransactions(20); // Добавляем 20 случайных транзакций
  }

  Future<void> _clearAllData() async {
    await _database.delete(_database.transactionsTable).go();
    await _database.delete(_database.accountsTable).go();
    await _database.delete(_database.categoriesTable).go();
    await _database.delete(_database.backUpOperationsTable).go();
  }

  Future<void> _seedCategories() async {
    final categories = [
      // Доходы
      {'id': 1, 'name': 'Зарплата', 'emoji': '💰', 'isIncome': true},
      {'id': 2, 'name': 'Фриланс', 'emoji': '💼', 'isIncome': true},
      {'id': 3, 'name': 'Бонус', 'emoji': '🎁', 'isIncome': true},
      {'id': 4, 'name': 'Инвестиции', 'emoji': '📈', 'isIncome': true},
      {'id': 5, 'name': 'Подарки', 'emoji': '🎉', 'isIncome': true},
      
      // Расходы
      {'id': 6, 'name': 'Продукты', 'emoji': '🛒', 'isIncome': false},
      {'id': 7, 'name': 'Транспорт', 'emoji': '🚗', 'isIncome': false},
      {'id': 8, 'name': 'Развлечения', 'emoji': '🎬', 'isIncome': false},
      {'id': 9, 'name': 'Кафе и рестораны', 'emoji': '☕', 'isIncome': false},
      {'id': 10, 'name': 'Коммунальные', 'emoji': '💡', 'isIncome': false},
      {'id': 11, 'name': 'Покупки', 'emoji': '🛍️', 'isIncome': false},
      {'id': 12, 'name': 'Здоровье', 'emoji': '💊', 'isIncome': false},
      {'id': 13, 'name': 'Образование', 'emoji': '📚', 'isIncome': false},
      {'id': 14, 'name': 'Спорт', 'emoji': '⚽', 'isIncome': false},
    ];

    await _database.batch((batch) {
      for (final category in categories) {
        batch.insert(
          _database.categoriesTable,
          CategoriesTableCompanion.insert(
            id: Value(category['id'] as int),
            name: category['name'] as String,
            emodji: category['emoji'] as String,
            isIncome: category['isIncome'] as bool,
          ),
        );
      }
    });
  }

  Future<void> _seedAccount() async {
    final now = DateTime.now();
    await _database.into(_database.accountsTable).insert(
      AccountsTableCompanion.insert(
        id: const Value(1),
        name: 'Мой счет',
        balance: 150000.0,
        currency: const Value('RUB'),
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  Future<void> _seedTransactions() async {
    await _addRandomTransactions(50);
  }

  Future<void> _addRandomTransactions(int count) async {
    final now = DateTime.now();
    final transactions = <TransactionsTableCompanion>[];

    // Данные для генерации случайных транзакций
    final incomeCategories = [1, 2, 3, 4, 5];
    final expenseCategories = [6, 7, 8, 9, 10, 11, 12, 13, 14];
    
    final incomeComments = [
      'Зарплата за месяц',
      'Премия',
      'Фриланс проект',
      'Дивиденды',
      'Подарок от родственников',
      'Возврат долга',
      'Продажа вещей',
    ];
    
    final expenseComments = [
      'Покупки в супермаркете',
      'Обед в кафе',
      'Проездной билет',
      'Коммунальные платежи',
      'Покупка одежды',
      'Лекарства',
      'Абонемент в спортзал',
      'Книги',
      'Кино',
      'Такси',
      'Подписка на сервис',
      'Ремонт техники',
    ];

    for (int i = 0; i < count; i++) {
      final daysAgo = _random.nextInt(60); // Последние 60 дней
      final transactionDate = now.subtract(Duration(days: daysAgo));
      
      final isIncome = _random.nextBool() && _random.nextDouble() < 0.3; // 30% доходы
      
      double amount;
      int categoryId;
      String comment;
      
      if (isIncome) {
        categoryId = incomeCategories[_random.nextInt(incomeCategories.length)];
        amount = (_random.nextDouble() * 80000 + 5000); // 5k - 85k
        comment = incomeComments[_random.nextInt(incomeComments.length)];
      } else {
        categoryId = expenseCategories[_random.nextInt(expenseCategories.length)];
        amount = -(_random.nextDouble() * 15000 + 100); // -100 - -15k
        comment = expenseComments[_random.nextInt(expenseComments.length)];
      }
      
      transactions.add(
        TransactionsTableCompanion.insert(
          accountId: 1,
          categoryId: categoryId,
          amount: amount,
          comment: comment,
          transactionDate: transactionDate,
          createdAt: transactionDate,
          updatedAt: transactionDate,
        ),
      );
    }

    await _database.batch((batch) {
      batch.insertAll(_database.transactionsTable, transactions);
    });
  }

  // Генератор случайных чисел
  static final _random = DateTime.now().millisecondsSinceEpoch.hashCode;
}

// Простейший генератор случайных чисел
extension _RandomInt on int {
  int nextInt(int max) => (this * 1103515245 + 12345) % max;
  double nextDouble() => (nextInt(1000000) / 1000000.0);
  bool nextBool() => nextInt(2) == 1;
}