import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shrm_homework_app/config/theme/app_colors.dart';
import 'package:shrm_homework_app/features/account/data/models/account_update_request/account_update_request.dart';
import 'package:shrm_homework_app/features/account/presentation/bloc/account_bloc.dart';
import 'package:shrm_homework_app/features/account/presentation/bloc/account_event.dart';
import 'package:shrm_homework_app/features/account/presentation/bloc/account_state.dart';

@RoutePage()
class EditAccountScreen extends StatefulWidget {
  final int accountId;
  final String initialName;

  const EditAccountScreen({
    super.key,
    required this.accountId,
    required this.initialName,
  });

  @override
  State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        title: const Text('Редактировать'),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => context.router.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.white),
            onPressed: () {
              final currentState = context.read<AccountBloc>().state;
              if (currentState is AccountLoaded) {
                final request = AccountUpdateRequest(
                  name: _controller.text,
                  balance:
                      currentState.account.balance, // Передаем текущий баланс
                  currency: currentState.account.currency, // и валюту
                );
                context.read<AccountBloc>().add(
                  UpdateAccount(widget.accountId, request),
                );
              }
              context.router.pop();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Название счета',
                prefixIcon: Icon(Icons.account_balance),
                border: UnderlineInputBorder(),
              ),
              autofocus: true,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.delete_outline),
                label: const Text('Удалить счет'),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Функция удаления счета в разработке'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lightRedBackground,
                  foregroundColor: Colors.red,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
