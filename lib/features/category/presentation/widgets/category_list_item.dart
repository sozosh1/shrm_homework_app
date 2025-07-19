import 'package:flutter/material.dart';

import 'package:shrm_homework_app/features/category/data/models/category/category.dart';

class CategoryListItem extends StatelessWidget {
  final Category category;
  final String? searchQuery;

  const CategoryListItem({super.key, required this.category, this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            radius: 16,
            child: Text(category.emoji, style: TextStyle(fontSize: 20)),
          ),
          title: Text(category.name),
        ),
      ],
    );
  }
}
