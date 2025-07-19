import 'dart:async';
import 'package:flutter/material.dart';


class CategorySearchBar extends StatefulWidget {
  final String value;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const CategorySearchBar({
    super.key,
    required this.value,
    required this.onChanged,
    required this.onClear,
  });

  @override
  State<CategorySearchBar> createState() => _CategorySearchBarState();
}

class _CategorySearchBarState extends State<CategorySearchBar> {
  late TextEditingController _controller;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(CategorySearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && widget.value != _controller.text) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounceTimer?.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      widget.onChanged(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: _onSearchChanged,
      decoration: InputDecoration(
        filled: true,

        hintText: 'Найти статью',

        suffixIcon:
            _controller.text.isNotEmpty
                ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey[500]),
                  onPressed: () {
                    _controller.clear();
                    widget.onClear();
                  },
                )
                : Icon(Icons.search),
      ),
    );
  }
}
