import 'package:flutter/material.dart';

import 'package:shrm_homework_app/features/category/domain/models/category/category.dart';

class CategoryListItem extends StatelessWidget {
  final Category category;
  final String? searchQuery;

  const CategoryListItem({super.key, required this.category, this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(height: 0.5, thickness: 0.5),
        ListTile(
          leading: CircleAvatar(
            child: Text(category.emodji, style: TextStyle(fontSize: 24)),
          ),
          title: Text(category.name),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Категория: ${category.name}'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
        ),
        Divider(height: 0.5, thickness: 0.5),
      ],
    );
  }
}
