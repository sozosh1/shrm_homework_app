import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
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
          final chartData =
              state.currentPeriod == 'daily'
                  ? state.dailyData
                  : state.monthlyData;

          return Column(
            children: [
              Container(
                color: AppColors.lightGreenBackground,
                child: Column(
                  children: [
                    ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: AppColors.white,
                        child: Text('💸', style: TextStyle(fontSize: 24)),
                      ),

                      title: const Text('Баланс'),
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
                                    title: const Center(
                                      child: Text(
                                        'Отмена',
                                        style: TextStyle(
                                          color: AppColors.white,
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.of(builderContext).pop();
                                    },
                                    tileColor: AppColors.lightRedBackground,
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

             
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SegmentedButton(
                          style: ButtonStyle(
                            visualDensity: VisualDensity.compact,
                          ),
                          segments: const [
                            ButtonSegment(value: 'daily', label: Text('Дни')),
                            ButtonSegment(
                              value: 'monthly',
                              label: Text('Месяцы'),
                            ),
                          ],
                          selected: {state.currentPeriod},
                          onSelectionChanged: (newSelection) {
                            context.read<AccountBloc>().add(
                              SwitchPeriod(newSelection.first),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 200,
                      child:
                          chartData.isNotEmpty
                              ? BarChart(
                                BarChartData(
                                  alignment: BarChartAlignment.spaceEvenly,
                                  barGroups: _buildBarGroups(
                                    state.dailyData,
                                    state.monthlyData,
                                    state.currentPeriod,
                                    account.currency,
                                  ),
                                  titlesData: FlTitlesData(
                                    leftTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        interval: 6,
                                        reservedSize: 30,
                                        getTitlesWidget: (value, meta) {
                                          final index = value.toInt();

                                         
                                          final groupedData =
                                              <
                                                DateTime,
                                                List<Map<String, dynamic>>
                                              >{};
                                          for (final item in chartData) {
                                            final date =
                                                item['date'] as DateTime;
                                            if (!groupedData.containsKey(
                                              date,
                                            )) {
                                              groupedData[date] = [];
                                            }
                                            groupedData[date]!.add(item);
                                          }

                                          final sortedDates =
                                              groupedData.keys.toList()..sort();

                                          if (index >= 0 &&
                                              index < sortedDates.length) {
                                           
                                            final interval =
                                                state.currentPeriod == 'daily'
                                                    ? 10
                                                    : 3;

                                            
                                            if (index == 0 ||
                                                index ==
                                                    sortedDates.length - 1 ||
                                                index % interval == 0) {
                                              final date = sortedDates[index];
                                              return Text(
                                                state.currentPeriod == 'daily'
                                                    ? DateFormat(
                                                      'dd.MM',
                                                    ).format(date)
                                                    : DateFormat(
                                                      'MMM',
                                                    ).format(date),
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                ),
                                              );
                                            }
                                          }
                                          return const SizedBox.shrink();
                                        },
                                      ),
                                    ),
                                    topTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    rightTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                  ),
                                  barTouchData: BarTouchData(
                                    enabled: true,
                                    touchTooltipData: BarTouchTooltipData(
                                      getTooltipColor:
                                          (touchedSpot) =>
                                              AppColors.lightGreenBackground,
                                      tooltipBorder: BorderSide(
                                        color: AppColors.primaryGreen,
                                      ),
                                      getTooltipItem: (
                                        group,
                                        groupIndex,
                                        rod,
                                        rodIndex,
                                      ) {
                                        
                                        final groupedData =
                                            <
                                              DateTime,
                                              List<Map<String, dynamic>>
                                            >{};
                                        for (final item in chartData) {
                                          final date = item['date'] as DateTime;
                                          if (!groupedData.containsKey(date)) {
                                            groupedData[date] = [];
                                          }
                                          groupedData[date]!.add(item);
                                        }

                                        final sortedDates =
                                            groupedData.keys.toList()..sort();
                                        if (group.x.toInt() >=
                                            sortedDates.length) {
                                          return null;
                                        }

                                        final date =
                                            sortedDates[group.x.toInt()];
                                        final items = groupedData[date]!;

                                        if (rodIndex >= items.length) {
                                          return null;
                                        }

                                        final item = items[rodIndex];
                                        final amount = item['amount'] as double;
                                        final isIncome =
                                            item['isIncome'] as bool? ??
                                            (amount >= 0);

                                       
                                        final prefix =
                                            isIncome ? 'Доход: +' : 'Расход: -';

                                        return BarTooltipItem(
                                          '$prefix${amount.abs().toStringAsFixed(2)} ${account.currency}',
                                          const TextStyle(
                                            color: AppColors.textDark,
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                                  gridData: const FlGridData(show: false),
                                  borderData: FlBorderData(show: false),
                                ),
                              )
                              : const Center(
                                child: Text(
                                  'Нет данных для отображения графика',
                                ),
                              ),
                    ),
                  ],
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

        return const SizedBox.shrink();
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

                    
                    final currencyService = getIt<CurrencyService>();
                    await currencyService.setCurrency(entry.key);
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

  List<BarChartGroupData> _buildBarGroups(
    List<Map<String, dynamic>> dailyData,
    List<Map<String, dynamic>> monthlyData,
    String currentPeriod,
    String currency,
  ) {
    final data = currentPeriod == 'daily' ? dailyData : monthlyData;

   
    final groupedData = <DateTime, List<Map<String, dynamic>>>{};
    for (final item in data) {
      final date = item['date'] as DateTime;
      if (!groupedData.containsKey(date)) {
        groupedData[date] = [];
      }
      groupedData[date]!.add(item);
    }

    
    final sortedDates = groupedData.keys.toList()..sort();

    return sortedDates.asMap().entries.map((entry) {
      final index = entry.key;
      final date = entry.value;
      final items = groupedData[date]!;

      
      final rods = <BarChartRodData>[];

      for (final item in items) {
        final amount = item['amount'] as double;
        final isIncome = item['isIncome'] as bool? ?? (amount >= 0);

        if (amount > 0) {
          rods.add(
            BarChartRodData(
              toY: amount,
              color:
                  isIncome
                      ? AppColors.primaryGreen
                      : AppColors.lightRedBackground,
              width: 6,
            ),
          );
        }
      }

      return BarChartGroupData(x: index, barRods: rods);
    }).toList();
  }
}
