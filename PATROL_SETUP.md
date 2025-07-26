
## Установка и настройка

### 1. Установка Patrol CLI

```bash
dart pub global activate patrol_cli
```

### 2. Проверка установки

```bash
patrol --version
```


## Структура тестов

```
test/integration/           # Интеграционные тесты
├── README.md              # Документация тестов
├── create_transaction_test.dart  # Тесты создания транзакций
└── ...

integration_test/          # Точка входа для Patrol
└── patrol_test.dart       # Главный файл для запуска
```

## Созданные тесты

### create_transaction_test.dart

Содержит 3 основных сценария:

1. **Создание транзакции расхода**
   - Навигация к экрану расходов
   - Заполнение формы транзакции
   - Проверка сохранения

2. **Создание транзакции дохода**
   - Навигация к экрану доходов
   - Заполнение формы транзакции
   - Проверка сохранения

3. **Валидация полей**
   - Проверка обязательных полей
   - Тестирование сообщений об ошибках

## Команды для запуска

### Базовый запуск
```bash
patrol test
```

### Запуск конкретного файла
```bash
patrol test --target integration_test/patrol_test.dart
```

### Запуск с записью видео
```bash
patrol test --record-video
```

### Запуск на конкретной платформе
```bash
patrol test --platform android
patrol test --platform ios
```

### Запуск с подробным выводом
```bash
patrol test --verbose
```

## Полезные функции Patrol

### Основные действия
```dart
// Тап по элементу
await $.tap(find.text('Кнопка'));

// Ввод текста
await $.enterText(find.byType(TextField), 'Текст');

// Ожидание появления элемента
await $.waitUntilVisible(find.text('Элемент'));

// Прокрутка
await $.scrollUntilVisible(
  finder: find.text('Элемент'),
  view: find.byType(ListView),
);
```

### Работа с нативными функциями
```dart
// Разрешения
await $.native.grantPermissionWhenInUse();

// Уведомления
await $.native.openNotifications();

// Настройки
await $.native.openAppSettings();
```

## Отладка тестов

### Добавление задержек
```dart
// Ожидание завершения анимаций
await $.pumpAndSettle();

// Фиксированная задержка
await Future.delayed(Duration(seconds: 1));
```

### Скриншоты для отладки
```dart
// Сделать скриншот
await $.takeScreenshot('debug_screenshot');
```

### Логирование
```dart
print('Текущее состояние: ${find.text('Элемент').evaluate()}');
```

## Интеграция с CI/CD

### GitHub Actions пример
```yaml
- name: Run integration tests
  run: patrol test --platform android
```

### Локальная разработка
```bash
# Быстрая проверка
patrol test --name "создание новой транзакции"

# Полный набор тестов
patrol test --record-video
```



## Поддержка

При возникновении проблем:
1. Проверьте логи тестов с флагом `--verbose`
2. Убедитесь, что устройство/эмулятор запущен
3. Проверьте актуальность зависимостей
4. Обратитесь к документации Patrol