import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shrm_homework_app/config/theme/app_colors.dart';
import 'package:shrm_homework_app/core/di/di.dart';
import 'package:shrm_homework_app/core/services/currency_service.dart';
import 'package:shrm_homework_app/core/widgets/currency_display.dart';
import 'package:shrm_homework_app/core/widgets/error_widget.dart';
import 'package:shrm_homework_app/features/account/data/models/account_update_request/account_update_request.dart';
import 'package:shrm_homework_app/features/account/presentation/bloc/account_bloc.dart';
import 'package:shrm_homework_app/features/account/presentation/bloc/account_event.dart';
import 'package:shrm_homework_app/features/account/presentation/bloc/account_state.dart';
import 'package:shrm_homework_app/features/account/presentation/screens/edit_account_screen.dart';
import 'package:shrm_homework_app/generated/l10n.dart';

@RoutePage()
class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const accountId = 100;

    return BlocProvider(
      create:
          (context) => getIt<AccountBloc>()..add(const LoadAccount(accountId)),
      child: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          final accountName =
              state is AccountLoaded ? state.account.name : S.of(context).accountName;
          return Scaffold(
            appBar: AppBar(
              title: Text(accountName),

              actions: [
                if (state is AccountLoaded)
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (_) => BlocProvider.value(
                                value: BlocProvider.of<AccountBloc>(context),
                                child: EditAccountScreen(
                                  accountId: accountId,
                                  initialName: state.account.name,
                                ),
                              ),
                        ),
                      );
                    },
                  ),
              ],
            ),
            body: const AccountView(accountId: accountId),
          );
        },
      ),
    );
  }
}

class AccountView extends StatelessWidget {
  final int accountId;
  const AccountView({super.key, required this.accountId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        if (state is AccountInitial || state is AccountLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is AccountLoaded) {
          final account = state.account;

          return Column(
            children: [
              ListTile(
                leading: const CircleAvatar(
                  child: Text('💸', style: TextStyle(fontSize: 24)),
                ),
                title: Text(S.of(context).balance),
                tileColor: Theme.of(context).colorScheme.primaryContainer,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CurrencyDisplay(
                      amount: account.balance,
                      accountCurrency: account.currency,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ],
                ),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (builderContext) {
                      return SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: Text(state.account.name),
                              onTap: () {
                                Navigator.of(builderContext).pop();
                              },
                            ),
                            const Divider(height: 1),
                            ListTile(
                              tileColor: Colors.redAccent,

                              title: Center(
                                child: Text(
                                  S.of(context).cancel,
                                  style: TextStyle(color: AppColors.white),
                                ),
                              ),
                              onTap: () {
                                Navigator.of(builderContext).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              const Divider(height: 1),
              ListTile(
                tileColor: Theme.of(context).colorScheme.primaryContainer,
                title: Text(S.of(context).currency),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      account.currency,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ],
                ),
                onTap: () => _showCurrencyPicker(context, state),
              ),
            ],
          );
        }

        if (state is AccountError) {
          return AppErrorWidget(
            message: state.message,
            onRetry:
                () => context.read<AccountBloc>().add(LoadAccount(accountId)),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  void _showCurrencyPicker(BuildContext context, AccountLoaded currentState) {
    final currencies = {
      'RUB': S.of(context).russianRuble,
      'USD': S.of(context).usDollar,
      'EUR': S.of(context).euro,
    };

    showModalBottomSheet(
      context: context,
      builder: (builderContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...currencies.entries.map((entry) {
                return ListTile(
                  title: Text(entry.value),
                  trailing: Text(entry.key),
                  onTap: () async {
                    // Обновляем валюту аккаунта
                    final request = AccountUpdateRequest(
                      name: currentState.account.name,
                      balance: currentState.account.balance,
                      currency: entry.key,
                    );

                    context.read<AccountBloc>().add(
                      UpdateAccount(currentState.account.id, request),
                    );

                    // Обновляем валюту приложения
                    final currencyService = getIt<CurrencyService>();
                    await currencyService.setCurrency(entry.key);

                    Navigator.of(builderContext).pop();
                  },
                );
              }),
              const Divider(height: 1),
              ListTile(
                title: const Center(
                  child: Text(
                    'Отмена',
                    style: TextStyle(color: AppColors.white),
                  ),
                ),
                onTap: () => Navigator.of(builderContext).pop(),
                tileColor: AppColors.lightRedBackground,
              ),
            ],
          ),
        );
      },
    );
  }
}
