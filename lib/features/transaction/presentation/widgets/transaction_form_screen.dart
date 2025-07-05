import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shrm_homework_app/config/theme/app_colors.dart';
import 'package:shrm_homework_app/core/di/di.dart';
import 'package:shrm_homework_app/features/account/data/models/account_brief/account_brief.dart';
import 'package:shrm_homework_app/features/account/domain/repository/account_repository.dart';
import 'package:shrm_homework_app/features/category/domain/models/category/category.dart';
import 'package:shrm_homework_app/features/category/domain/repository/category_repository.dart';
import 'package:shrm_homework_app/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:shrm_homework_app/features/transaction/presentation/bloc/transaction_event.dart';
import 'package:shrm_homework_app/features/transaction/data/models/transaction_request/transaction_request.dart';
import 'package:shrm_homework_app/features/transaction/data/models/transaction_response/transaction_response.dart';
import 'package:shrm_homework_app/features/transaction/presentation/bloc/transaction_state.dart';

class TransactionFormScreen extends StatefulWidget {
  final bool isIncome;
  final TransactionResponse? transaction;

  const TransactionFormScreen({
    super.key,
    required this.isIncome,
    this.transaction,
  });

  @override
  _TransactionFormScreenState createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends State<TransactionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  late TextEditingController _commentController;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  Category? _selectedCategory;
  AccountBrief? _selectedAccount;
  List<AccountBrief> _accounts = [];
  List<Category> _categories = [];
  bool _isLoading = false;


  String get _decimalSeparator {
    final format = NumberFormat.decimalPattern();
    return format.symbols.DECIMAL_SEP;
  }

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.transaction?.amount.toStringAsFixed(2) ?? '',
    );
    _commentController = TextEditingController(
      text: widget.transaction?.comment ?? '',
    );
    _selectedDate = widget.transaction?.transactionDate ?? DateTime.now();
    _selectedTime =
        widget.transaction?.transactionDate != null
            ? TimeOfDay.fromDateTime(widget.transaction!.transactionDate)
            : TimeOfDay.now();
    _selectedCategory = widget.transaction?.category;
    _selectedAccount = widget.transaction?.account;
    _loadAccountsAndCategories();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _loadAccountsAndCategories() async {
    setState(() {
      _isLoading = true;
    });

    try {
      
      final accountRepository = getIt<AccountRepository>();
      final categoryRepository = getIt<CategoryRepository>();

      // Загружаем единственный счет (ID = 1 согласно ТЗ)
      final accountResponse = await accountRepository.getAccount(1);
      _accounts = [
        AccountBrief(
          id: accountResponse.id,
          name: accountResponse.name,
          balance: accountResponse.balance,
          currency: accountResponse.currency,
        ),
      ];

      
      _categories = await categoryRepository.getCategoriesByType(
        widget.isIncome,
      );

    
      if (_selectedAccount == null && _accounts.isNotEmpty) {
        _selectedAccount = _accounts.first;
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog('Ошибка загрузки данных: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _selectAccount() async {
    if (_accounts.isEmpty) return;

    final selected = await showDialog<AccountBrief>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Выберите счет'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children:
                _accounts.map((account) {
                  return ListTile(
                    title: Text(account.name),
                    subtitle: Text(
                      '${account.balance.toStringAsFixed(2)} ${account.currency}',
                    ),
                    onTap: () {
                      Navigator.of(context).pop(account);
                    },
                  );
                }).toList(),
          ),
        );
      },
    );

    if (selected != null) {
      setState(() {
        _selectedAccount = selected;
      });
    }
  }

  Future<void> _selectCategory() async {
    if (_categories.isEmpty) return;

    final selected = await showDialog<Category>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Выберите категорию'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return ListTile(
                  leading: Text(
                    category.emodji,
                    style: TextStyle(fontSize: 24),
                  ),
                  title: Text(category.name),
                  onTap: () {
                    Navigator.of(context).pop(category);
                  },
                );
              },
            ),
          ),
        );
      },
    );

    if (selected != null) {
      setState(() {
        _selectedCategory = selected;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Ошибка'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('ОК'),
              ),
            ],
          ),
    );
  }

  void _showValidationDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Заполните все поля'),
            content: Text(
              'Пожалуйста, заполните все обязательные поля: счет, категория и сумма.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('ОК'),
              ),
            ],
          ),
    );
  }

  bool _validateFields() {
    if (_selectedAccount == null) return false;
    if (_selectedCategory == null) return false;
    if (_amountController.text.isEmpty) return false;

    final amount = double.tryParse(
      _amountController.text.replaceAll(_decimalSeparator, '.'),
    );
    if (amount == null || amount <= 0) return false;

    return true;
  }

  void _validateAndSave() {
    if (!_validateFields()) {
      _showValidationDialog();
      return;
    }

    final dateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final amount = double.parse(
      _amountController.text.replaceAll(_decimalSeparator, '.'),
    );

    final request = TransactionRequest(
      accountId: _selectedAccount!.id,
      categoryId: _selectedCategory!.id,
      amount: amount,
      comment: _commentController.text.isEmpty ? null : _commentController.text,
      transactionDate: dateTime,
    );

    final bloc = context.read<TransactionBloc>();
    if (widget.transaction == null) {
      bloc.add(
        TransactionEvent.createTransaction(
          request: request,
          isIncome: widget.isIncome,
        ),
      );
    } else {
      bloc.add(
        TransactionEvent.updateTransaction(
          id: widget.transaction!.id,
          request: request,
          isIncome: widget.isIncome,
        ),
      );
    }
  }

  void _deleteTransaction() {
    final bloc = context.read<TransactionBloc>();
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(widget.isIncome ? 'Удалить доход' : 'Удалить расход'),
            content: Text('Вы уверены, что хотите удалить эту операцию?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Отмена'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  if (widget.transaction != null) {
                    bloc.add(
                      TransactionEvent.deleteTransaction(
                        id: widget.transaction!.id,
                        isIncome: widget.isIncome,
                      ),
                    );
                  }
                },
                child: Text('Удалить', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransactionBloc, TransactionState>(
      listener: (context, state) {
        if (state is TransactionSaved || state is TransactionDeleted) {
          Navigator.of(context).pop(true);
        } else if (state is TransactionError) {
          _showErrorDialog(state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryGreen,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.check, color: Colors.white),
              onPressed: _validateAndSave,
            ),
          ],
          title: Text(
            widget.transaction == null
                ? (widget.isIncome ? 'Новый доход' : 'Новый расход')
                : (widget.isIncome
                    ? 'Редактировать доход'
                    : 'Редактировать расход'),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        body:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : BlocBuilder<TransactionBloc, TransactionState>(
                  builder: (context, state) {
                    if (state is TransactionSaving) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return _buildForm();
                  },
                ),
      ),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildAccountRow(),
                  _buildCategoryRow(),
                  _buildAmountRow(),
                  _buildDateRow(),
                  _buildTimeRow(),
                  _buildCommentRow(),
                ],
              ),
            ),
            if (widget.transaction != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ElevatedButton(
                  onPressed: _deleteTransaction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightRedBackground,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text(
                    widget.isIncome ? 'Удалить доход' : 'Удалить расход',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountRow() {
    return _buildRow(
      label: 'Счет',
      child: InkWell(
        onTap: _selectAccount,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  _selectedAccount?.name ?? 'Выберите счет',
                  style: TextStyle(
                    fontSize: 16,
                    color:
                        _selectedAccount == null ? Colors.grey : Colors.black,
                  ),
                ),
              ),
              const Icon(Icons.arrow_drop_down, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryRow() {
    return _buildRow(
      label: 'Категория',
      child: InkWell(
        onTap: _selectCategory,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child:
                    _selectedCategory != null
                        ? Row(
                          children: [
                            Text(
                              _selectedCategory!.emodji,
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _selectedCategory!.name,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        )
                        : Text(
                          'Выберите категорию',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
              ),
              const Icon(Icons.arrow_drop_down, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAmountRow() {
    return _buildRow(
      label: 'Сумма',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Введите сумму',
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'^\d*[' + _decimalSeparator + r']?\d{0,2}$'),
                ),
              ],
              textAlign: TextAlign.end,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            _selectedAccount?.currency ?? 'RUB',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRow() {
    return _buildRow(
      label: 'Дата',
      child: InkWell(
        onTap: () => _selectDate(context),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Text(
            DateFormat.yMMMd().format(_selectedDate),
            textAlign: TextAlign.end,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeRow() {
    return _buildRow(
      label: 'Время',
      child: InkWell(
        onTap: () => _selectTime(context),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Text(
            _selectedTime.format(context),
            textAlign: TextAlign.end,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildCommentRow() {
    return _buildRow(
      label: 'Комментарий',
      child: TextFormField(
        controller: _commentController,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Комментарий',
          hintStyle: TextStyle(color: Colors.grey[400]),
        ),
        maxLines: 1,
        textAlign: TextAlign.end,
      ),
    );
  }

  Widget _buildRow({required String label, required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
