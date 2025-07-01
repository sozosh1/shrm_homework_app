import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shrm_homework_app/config/theme/app_colors.dart';
import 'package:shrm_homework_app/core/di/di.dart';
import 'package:shrm_homework_app/features/category/domain/models/category/category.dart';
import 'package:shrm_homework_app/features/category/presentation/bloc/category_bloc.dart';
import 'package:shrm_homework_app/features/category/presentation/bloc/category_event.dart';
import 'package:shrm_homework_app/features/category/presentation/bloc/category_state.dart';
import 'package:shrm_homework_app/features/transaction/data/models/transaction_request/transaction_request.dart';
import 'package:shrm_homework_app/features/transaction/data/models/transaction_response/transaction_response.dart';
import 'package:shrm_homework_app/features/transaction/domain/repository/transaction_repository.dart';

@RoutePage()
class EditTransactionScreen extends StatefulWidget {
  final TransactionResponse transaction;

  const EditTransactionScreen({
    super.key,
    required this.transaction,
  });

  @override
  State<EditTransactionScreen> createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  late final TextEditingController _amountController;
  late final TextEditingController _commentController;
  late DateTime _selectedDate;
  late Category _selectedCategory;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: widget.transaction.amount.toString());
    _commentController = TextEditingController(text: widget.transaction.comment ?? '');
    _selectedDate = widget.transaction.transactionDate;
    _selectedCategory = widget.transaction.category;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _saveTransaction() async {
    if (_amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите сумму')),
      );
      return;
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите корректную сумму')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final request = TransactionRequest(
        accountId: widget.transaction.account.id,
        categoryId: _selectedCategory.id,
        amount: amount,
        transactionDate: _selectedDate,
        comment: _commentController.text.trim().isEmpty ? null : _commentController.text.trim(),
      );

      await getIt<TransactionRepository>().updateTransaction(
        widget.transaction.id,
        request,
      );

      if (mounted) {
        context.router.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Транзакция обновлена')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка сохранения: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectCategory() async {
    await showModalBottomSheet<Category>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => BlocProvider(
        create: (context) => getIt<CategoryBloc>()..add(const LoadCategories()),
        child: DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          expand: false,
          builder: (context, scrollController) => _CategorySelector(
            scrollController: scrollController,
            initialCategory: _selectedCategory,
            onCategorySelected: (category) {
              setState(() {
                _selectedCategory = category;
              });
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        title: const Text('Редактировать операцию'),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => context.router.pop(),
        ),
        actions: [
          IconButton(
            icon: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.check, color: Colors.white),
            onPressed: _isLoading ? null : _saveTransaction,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Amount field
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
              ],
              decoration: InputDecoration(
                labelText: 'Сумма',
                prefixIcon: const Icon(Icons.payments),
                suffixText: widget.transaction.account.currency,
                border: const UnderlineInputBorder(),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),

            // Comment field
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                labelText: _commentController.text.isEmpty ? 'Комментарий' : null,
                hintText: _commentController.text.isEmpty ? 'Комментарий' : null,
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.comment),
                border: const UnderlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),

            // Date field
            InkWell(
              onTap: _selectDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Дата',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: UnderlineInputBorder(),
                ),
                child: Text(
                  '${_selectedDate.day.toString().padLeft(2, '0')}.${_selectedDate.month.toString().padLeft(2, '0')}.${_selectedDate.year}',
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Category field
            InkWell(
              onTap: _selectCategory,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Категория',
                  prefixIcon: Icon(Icons.category),
                  border: UnderlineInputBorder(),
                ),
                child: Row(
                  children: [
                    Text(
                      _selectedCategory.emodji,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 8),
                    Text(_selectedCategory.name),
                    const Spacer(),
                    const Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategorySelector extends StatelessWidget {
  final ScrollController scrollController;
  final Category initialCategory;
  final ValueChanged<Category> onCategorySelected;

  const _CategorySelector({
    required this.scrollController,
    required this.initialCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 4,
          margin: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Выберите категорию',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, state) {
              if (state is CategoryLoading || state is CategoryInitial) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is CategoryLoaded) {
                // Filter categories by income type matching the transaction's category
                final filteredCategories = state.allCategories
                    .where((cat) => cat.isIncome == initialCategory.isIncome)
                    .toList();

                return ListView.builder(
                  controller: scrollController,
                  itemCount: filteredCategories.length,
                  itemBuilder: (context, index) {
                    final category = filteredCategories[index];
                    final isSelected = category.id == initialCategory.id;

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isSelected
                            ? AppColors.primaryGreen
                            : AppColors.lightGreenBackground,
                        radius: 16,
                        child: Text(
                          category.emodji,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      title: Text(category.name),
                      trailing: isSelected
                          ? const Icon(Icons.check, color: AppColors.primaryGreen)
                          : null,
                      onTap: () => onCategorySelected(category),
                    );
                  },
                );
              } else if (state is CategoryError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Ошибка: ${state.message}'),
                      ElevatedButton(
                        onPressed: () {
                          context.read<CategoryBloc>().add(const LoadCategories());
                        },
                        child: const Text('Повторить'),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }
}