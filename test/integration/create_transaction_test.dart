import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:shrm_homework_app/app.dart';
import 'package:shrm_homework_app/core/di/di.dart';

void main() {
  patrolTest(
    'создание новой транзакции расхода',
    ($) async {
      // Инициализация DI
      await configureDependencies();
      
      // Запуск приложения
      await $.pumpWidgetAndSettle(const MyApp());
      
      // Ждем загрузки главного экрана
      await $.waitUntilVisible(find.text('Главная'));
      
      // Переходим на экран транзакций (расходы)
      await $.tap(find.byIcon(Icons.remove_circle_outline));
      await $.pumpAndSettle();
      
      // Нажимаем кнопку добавления новой транзакции
      await $.tap(find.byIcon(Icons.add));
      await $.pumpAndSettle();
      
      // Проверяем, что открылась форма создания транзакции
      expect(find.text('Мои расходы'), findsOneWidget);
      
      // Выбираем аккаунт (если не выбран по умолчанию)
      await $.tap(find.text('Счет'));
      await $.pumpAndSettle();
      
      // Выбираем первый доступный аккаунт
      final accountTiles = find.byType(ListTile);
      if (accountTiles.evaluate().isNotEmpty) {
        await $.tap(accountTiles.first);
        await $.pumpAndSettle();
      }
      
      // Выбираем категорию
      await $.tap(find.text('Категория'));
      await $.pumpAndSettle();
      
      // Выбираем первую доступную категорию
      final categoryTiles = find.byType(ListTile);
      if (categoryTiles.evaluate().isNotEmpty) {
        await $.tap(categoryTiles.first);
        await $.pumpAndSettle();
      }
      
      // Вводим сумму
      await $.tap(find.text('Сумма'));
      await $.pumpAndSettle();
      
      // Находим поле ввода суммы и вводим значение
      final amountField = find.byType(TextFormField);
      await $.enterText(amountField, '150.50');
      
      // Подтверждаем ввод суммы
      await $.tap(find.text('ОК'));
      await $.pumpAndSettle();
      
      // Добавляем комментарий (опционально)
      await $.tap(find.text('Нет'));
      await $.pumpAndSettle();
      
      // Вводим комментарий
      final commentField = find.byType(TextFormField);
      await $.enterText(commentField, 'Тестовая транзакция');
      
      // Подтверждаем ввод комментария
      await $.tap(find.text('ОК'));
      await $.pumpAndSettle();
      
      // Сохраняем транзакцию
      await $.tap(find.byIcon(Icons.check));
      await $.pumpAndSettle();
      
      // Проверяем, что вернулись на экран списка транзакций
      // и новая транзакция появилась в списке
      expect(find.text('150.50'), findsAtLeastNWidgets(1));
      expect(find.text('Тестовая транзакция'), findsOneWidget);
    },
  );
  
  patrolTest(
    'создание новой транзакции дохода',
    ($) async {
      // Инициализация DI
      await configureDependencies();
      
      // Запуск приложения
      await $.pumpWidgetAndSettle(const MyApp());
      
      // Ждем загрузки главного экрана
      await $.waitUntilVisible(find.text('Главная'));
      
      // Переходим на экран транзакций (доходы)
      await $.tap(find.byIcon(Icons.add_circle_outline));
      await $.pumpAndSettle();
      
      // Нажимаем кнопку добавления новой транзакции
      await $.tap(find.byIcon(Icons.add));
      await $.pumpAndSettle();
      
      // Проверяем, что открылась форма создания транзакции
      expect(find.text('Мои доходы'), findsOneWidget);
      
      // Выбираем аккаунт (если не выбран по умолчанию)
      await $.tap(find.text('Счет'));
      await $.pumpAndSettle();
      
      // Выбираем первый доступный аккаунт
      final accountTiles = find.byType(ListTile);
      if (accountTiles.evaluate().isNotEmpty) {
        await $.tap(accountTiles.first);
        await $.pumpAndSettle();
      }
      
      // Выбираем категорию
      await $.tap(find.text('Категория'));
      await $.pumpAndSettle();
      
      // Выбираем первую доступную категорию
      final categoryTiles = find.byType(ListTile);
      if (categoryTiles.evaluate().isNotEmpty) {
        await $.tap(categoryTiles.first);
        await $.pumpAndSettle();
      }
      
      // Вводим сумму
      await $.tap(find.text('Сумма'));
      await $.pumpAndSettle();
      
      // Находим поле ввода суммы и вводим значение
      final amountField = find.byType(TextFormField);
      await $.enterText(amountField, '2500.00');
      
      // Подтверждаем ввод суммы
      await $.tap(find.text('ОК'));
      await $.pumpAndSettle();
      
      // Добавляем комментарий
      await $.tap(find.text('Нет'));
      await $.pumpAndSettle();
      
      // Вводим комментарий
      final commentField = find.byType(TextFormField);
      await $.enterText(commentField, 'Зарплата');
      
      // Подтверждаем ввод комментария
      await $.tap(find.text('ОК'));
      await $.pumpAndSettle();
      
      // Сохраняем транзакцию
      await $.tap(find.byIcon(Icons.check));
      await $.pumpAndSettle();
      
      // Проверяем, что вернулись на экран списка транзакций
      // и новая транзакция появилась в списке
      expect(find.text('2500.00'), findsAtLeastNWidgets(1));
      expect(find.text('Зарплата'), findsOneWidget);
    },
  );
  
  patrolTest(
    'валидация обязательных полей при создании транзакции',
    ($) async {
      // Инициализация DI
      await configureDependencies();
      
      // Запуск приложения
      await $.pumpWidgetAndSettle(const MyApp());
      
      // Ждем загрузки главного экрана
      await $.waitUntilVisible(find.text('Главная'));
      
      // Переходим на экран транзакций (расходы)
      await $.tap(find.byIcon(Icons.remove_circle_outline));
      await $.pumpAndSettle();
      
      // Нажимаем кнопку добавления новой транзакции
      await $.tap(find.byIcon(Icons.add));
      await $.pumpAndSettle();
      
      // Пытаемся сохранить транзакцию без заполнения обязательных полей
      await $.tap(find.byIcon(Icons.check));
      await $.pumpAndSettle();
      
      // Проверяем, что появилось сообщение об ошибке
      expect(find.text('Ошибка'), findsOneWidget);
      expect(find.text('Заполните все поля'), findsOneWidget);
      
      // Закрываем диалог ошибки
      await $.tap(find.text('ОК'));
      await $.pumpAndSettle();
      
      // Проверяем, что остались на форме создания транзакции
      expect(find.text('Мои расходы'), findsOneWidget);
    },
  );
}