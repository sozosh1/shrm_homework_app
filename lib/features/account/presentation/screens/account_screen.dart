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

@RoutePage()
class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const accountId = 1;

    return BlocProvider(
      create:
          (context) => getIt<AccountBloc>()..add(const LoadAccount(accountId)),
      child: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          final accountName =
              state is AccountLoaded ? state.account.name : 'Счет';
          return Scaffold(
            appBar: AppBar(
              title: Text(accountName),
              backgroundColor: AppColors.primaryGreen,
              actions: [
                if (state is AccountLoaded)
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: () {
                      // ИЗМЕНЕНИЕ: Оборачиваем навигацию в BlocProvider.value
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

// ... остальная часть файла остается без изменений
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
              Container(
                color: AppColors.lightGreenBackground,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.account_balance_wallet_outlined,
                      ),
                      title: const Text('Баланс'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          state.isBalanceVisible
                              ? CurrencyDisplay(
                                  amount: account.balance,
                                  accountCurrency: account.currency,
                                  style: const TextStyle(fontSize: 16),
                                )
                              : const Text(
                                  '••••••',
                                  style: TextStyle(fontSize: 16),
                                ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      onTap:
                          () => context.read<AccountBloc>().add(
                            const ToggleBalanceVisibility(),
                          ),
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    ListTile(
                      title: const Text('Валюта'),
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
                ),
              ),
              Expanded(
                child: Center(
                  child:
                      state.isLoading
                          ? const CircularProgressIndicator()
                          : const Text('График будет реализован позже'),
                ),
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

        return const SizedBox.shrink(); // Fallback for any other state
      },
    );
  }

  void _showCurrencyPicker(BuildContext context, AccountLoaded currentState) {
    final currencies = {
      'RUB': 'Российский рубль',
      'USD': 'Американский доллар',
      'EUR': 'Евро',
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
                    
                    // Обновляем глобальную валюту приложения
                    final currencyService = getIt<CurrencyService>();
                    await currencyService.setCurrency(entry.key);
                    
                    Navigator.of(builderContext).pop();
                  },
                );
              }),
              const Divider(height: 1),
              ListTile(
                title: const Center(
                  child: Text('Отмена', style: TextStyle(color: Colors.red)),
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
