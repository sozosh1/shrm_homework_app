import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shrm_homework_app/features/account/data/models/account_responce/account_response.dart';
import 'package:shrm_homework_app/features/category/data/models/category/category.dart';
import 'package:shrm_homework_app/features/transaction/data/models/transaction_request/transaction_request.dart';
import 'package:shrm_homework_app/features/transaction/data/models/transaction_response/transaction_response.dart';
import 'package:shrm_homework_app/features/transaction/presentation/bloc/transaction_bloc.dart';
import 'package:shrm_homework_app/features/transaction/presentation/bloc/transaction_event.dart';
import 'package:shrm_homework_app/features/transaction/presentation/bloc/transaction_state.dart';
import 'package:shrm_homework_app/generated/l10n.dart';
import 'package:flutter/services.dart';

class TransactionFormScreen extends StatefulWidget {
  final bool isIncome;
  final TransactionResponse? transaction;

  const TransactionFormScreen({
    super.key,
    required this.isIncome,
    this.transaction,
  });

  @override
  State<TransactionFormScreen> createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends State<TransactionFormScreen> {
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  Category? _selectedCategory;
  AccountResponse? _selectedAccount;
  String? _initialAccountId;
  final _amountController = TextEditingController();
  final _commentController = TextEditingController();
  List<Category> _categories = [];
  List<AccountResponse> _accounts = [];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    if (widget.transaction != null) {
      _selectedDate = widget.transaction!.transactionDate;
      _selectedTime = TimeOfDay.fromDateTime(
        widget.transaction!.transactionDate,
      );
      _selectedCategory = widget.transaction!.category;
      _initialAccountId = widget.transaction!.account.id.toString();
      _amountController.text = widget.transaction!.amount.toStringAsFixed(2);
      _commentController.text = widget.transaction!.comment ?? '';
    } else {
      _selectedDate = now;
      _selectedTime = TimeOfDay.fromDateTime(now);
      _amountController.text = '';
      _commentController.text = '';
    }
    context.read<TransactionBloc>().add(
      LoadCategories(isIncome: widget.isIncome),
    );
    context.read<TransactionBloc>().add(const LoadAccounts());
  }

  @override
  void dispose() {
    _amountController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  String getDecimalSeparator() {
    return NumberFormat(
      '',
      Localizations.localeOf(context).toString(),
    ).symbols.DECIMAL_SEP;
  }

  void _saveTransaction() {
    if (_selectedCategory == null ||
        _selectedAccount == null ||
        _amountController.text.isEmpty) {
      showDialog(
        context: context,
        builder:
            (ctx) => AlertDialog(
              title: Text(S.of(context).error),
              content: Text(S.of(context).fillAllFields),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(S.of(context).ok),
                ),
              ],
            ),
      );
      return;
    }
    final amount = double.parse(
      _amountController.text.replaceAll(getDecimalSeparator(), '.'),
    );
    final transactionDate = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );
    final request = TransactionRequest(
      accountId: _selectedAccount!.id,
      categoryId: _selectedCategory!.id,
      amount: amount,
      transactionDate: transactionDate,
      comment:
          _commentController.text.isNotEmpty ? _commentController.text : null,
    );
    if (widget.transaction != null) {
      context.read<TransactionBloc>().add(
        UpdateTransaction(
          id: widget.transaction!.id,
          request: request,
          isIncome: widget.isIncome,
        ),
      );
    } else {
      context.read<TransactionBloc>().add(
        CreateTransaction(request: request, isIncome: widget.isIncome),
      );
    }
    Navigator.pop(context, true);
  }

  void _deleteTransaction() {
    if (widget.transaction != null) {
      showDialog(
        context: context,
        builder:
            (ctx) => AlertDialog(
              title: Text(S.of(context).deleteExpense),
              content: Text(S.of(context).areYouSure),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(S.of(context).cancel),
                ),
                TextButton(
                  onPressed: () {
                    context.read<TransactionBloc>().add(
                      DeleteTransaction(
                        id: widget.transaction!.id,
                        isIncome: widget.isIncome,
                      ),
                    );
                    Navigator.pop(context, true);
                    Navigator.pop(context, true);
                  },
                  child: Text(
                    S.of(context).delete,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
      );
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  Future<void> _pickAccount() async {
    final selected = await showModalBottomSheet<AccountResponse>(
      context: context,
      builder:
          (context) => ListView.builder(
            itemCount: _accounts.length,
            itemBuilder:
                (context, index) => ListTile(
                  title: Text(_accounts[index].name),
                  onTap: () => Navigator.pop(context, _accounts[index]),
                ),
          ),
    );
    if (selected != null) {
      setState(() => _selectedAccount = selected);
    }
  }

  Future<void> _pickCategory() async {
    final selected = await showModalBottomSheet<Category>(
      context: context,
      builder:
          (context) => ListView.builder(
            itemCount: _categories.length,
            itemBuilder:
                (context, index) => ListTile(
                  title: Text(_categories[index].name),
                  onTap: () => Navigator.pop(context, _categories[index]),
                ),
          ),
    );
    if (selected != null) {
      setState(() => _selectedCategory = selected);
    }
  }

  Future<void> _editAmount() async {
    final amountController = TextEditingController(
      text: _amountController.text,
    );
    final newAmount = await showDialog<String>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(S.of(context).amount),
            content: TextFormField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp('[0-9${getDecimalSeparator()}]'),
                ),
                TextInputFormatter.withFunction((oldValue, newValue) {
                  final sep = getDecimalSeparator();
                  final text = newValue.text;
                  if (text.split(sep).length > 2) return oldValue;
                  return newValue;
                }),
              ],
              autofocus: true,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(S.of(context).cancel),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, amountController.text),
                child: Text(S.of(context).ok),
              ),
            ],
          ),
    );
    if (newAmount != null && newAmount.isNotEmpty) {
      setState(() {
        _amountController.text = newAmount;
      });
    }
  }

  Future<void> _editComment() async {
    final commentController = TextEditingController(
      text: _commentController.text,
    );
    final newComment = await showDialog<String>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(S.of(context).edit),
            content: TextFormField(
              controller: commentController,
              autofocus: true,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(S.of(context).cancel),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, commentController.text),
                child: Text(S.of(context).ok),
              ),
            ],
          ),
    );
    if (newComment != null) {
      setState(() {
        _commentController.text = newComment;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final title =
        widget.isIncome ? S.of(context).myIncomes : S.of(context).myExpenses;
    return BlocConsumer<TransactionBloc, TransactionState>(
      listener: (context, state) {
        if (state is CategoriesLoaded && state.isIncome == widget.isIncome) {
          setState(() => _categories = state.categories);
          if (widget.transaction == null && _categories.isNotEmpty) {
            _selectedCategory = _categories.first;
          }
        } else if (state is AccountsLoaded) {
          setState(() => _accounts = state.accounts);
          if (_initialAccountId != null) {
            _selectedAccount = _accounts.firstWhere(
              (acc) => acc.id == _initialAccountId,
            );
          } else if (_accounts.isNotEmpty) {
            _selectedAccount = _accounts.first;
          }
        } else if (state is TransactionError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(title),
            actions: [
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: _saveTransaction,
              ),
            ],
          ),
          body: ListView(
            children: [
              ListTile(
                title: Text(S.of(context).account),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_selectedAccount?.name ?? S.of(context).select),
                    const Icon(Icons.chevron_right),
                  ],
                ),
                onTap: _pickAccount,
              ),
              const Divider(height: 1),
              ListTile(
                title: Text(S.of(context).category),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_selectedCategory?.name ?? S.of(context).select),
                    const Icon(Icons.chevron_right),
                  ],
                ),
                onTap: _pickCategory,
              ),
              const Divider(height: 1),
              ListTile(
                title: Text(S.of(context).amount),
                trailing: Text(
                  '${_amountController.text} ${_selectedAccount?.currency ?? ''}',
                ),
                onTap: _editAmount,
              ),
              const Divider(height: 1),
              ListTile(
                title: Text(S.of(context).date),
                trailing: Text(DateFormat('dd.MM.yyyy').format(_selectedDate)),
                onTap: _pickDate,
              ),
              const Divider(height: 1),
              ListTile(
                title: Text(S.of(context).time),
                trailing: Text(_selectedTime.format(context)),
                onTap: _pickTime,
              ),
              const Divider(height: 1),
              ListTile(
                title: Text(
                  _commentController.text.isEmpty
                      ? S.of(context).none
                      : _commentController.text,
                ),
                onTap: _editComment,
              ),
              if (widget.transaction != null)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 24.0,
                  ),
                  child: TextButton(
                    onPressed: _deleteTransaction,
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red.withOpacity(0.1),
                      foregroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(S.of(context).deleteExpense),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
