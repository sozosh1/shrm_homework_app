import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:shrm_homework_app/features/category/data/models/category/category.dart';
import 'package:shrm_homework_app/features/category/presentation/widgets/category_list_item.dart';

void main() {
  goldenTest(
    'CategoryListItem golden test',
    fileName: 'category_list_item',
    tags: ['golden'],
    builder: () => GoldenTestGroup(
      columns: 1,
      children: [
        GoldenTestScenario(
          name: 'expense category',
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CategoryListItem(
              category: const Category(
                id: 1,
                name: 'Продукты',
                emoji: '🛒',
                isIncome: false,
              ),
            ),
          ),
        ),
        GoldenTestScenario(
          name: 'income category',
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CategoryListItem(
              category: const Category(
                id: 2,
                name: 'Зарплата',
                emoji: '💰',
                isIncome: true,
              ),
            ),
          ),
        ),
        GoldenTestScenario(
          name: 'category with long name',
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CategoryListItem(
              category: const Category(
                id: 3,
                name: 'Очень длинное название категории для тестирования',
                emoji: '📱',
                isIncome: false,
              ),
            ),
          ),
        ),
        GoldenTestScenario(
          name: 'category with search query',
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CategoryListItem(
              category: const Category(
                id: 4,
                name: 'Транспорт',
                emoji: '🚗',
                isIncome: false,
              ),
              searchQuery: 'транс',
            ),
          ),
        ),
        GoldenTestScenario(
          name: 'category with different emoji',
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CategoryListItem(
              category: const Category(
                id: 5,
                name: 'Развлечения',
                emoji: '🎮',
                isIncome: false,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}