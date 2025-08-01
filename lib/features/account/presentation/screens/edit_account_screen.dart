import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shrm_homework_app/core/theme/app_colors.dart';
import 'package:shrm_homework_app/features/account/data/models/account_update_request/account_update_request.dart';
import 'package:shrm_homework_app/features/account/presentation/bloc/account_bloc.dart';
import 'package:shrm_homework_app/features/account/presentation/bloc/account_event.dart';
import 'package:shrm_homework_app/features/account/presentation/bloc/account_state.dart';
import 'package:shrm_homework_app/generated/l10n.dart';

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
        title: Text(S.of(context).editAccount),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.router.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              final currentState = context.read<AccountBloc>().state;
              if (currentState is AccountLoaded) {
                final request = AccountUpdateRequest(
                  name: _controller.text,
                  balance: currentState.account.balance,
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
              decoration:  InputDecoration(
                labelText: S.of(context).accountNameLabel,
                prefixIcon: Icon(Icons.account_balance),
                border: UnderlineInputBorder(),
              ),
              autofocus: true,
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                label: Text(S.of(context).deleteAccount),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(
                      content: Text(S.of(context).deleteAccountInDevelopment),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lightRedBackground,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
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
