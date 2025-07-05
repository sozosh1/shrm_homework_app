import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shrm_homework_app/core/database/app_database.dart';
import 'package:shrm_homework_app/features/account/domain/repository/account_repository.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'account_event.dart';
import 'account_state.dart';

@injectable
class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final AccountRepository _repository;
  final AppDatabase _appDatabase;
  late final StreamSubscription<List<Map<String, dynamic>>>
  _historySubscription;
  final Talker _talker = Talker();

  AccountBloc(this._repository, this._appDatabase)
    : super(const AccountState.initial()) {
    on<LoadAccount>(_onLoadAccount);
    on<UpdateAccount>(_onUpdateAccount);
    on<ToggleBalanceVisibility>(_onToggleBalanceVisibility);
    on<RefreshAccount>(_onRefreshAccount);
    on<SwitchPeriod>(_onSwitchPeriod);

    
    try {
      _historySubscription = _appDatabase.getTransactionHistoryStream().listen(
        (historyData) {
          _talker.info('Received history data from AppDatabase: $historyData');
          if (state is AccountLoaded) {
            final currentState = state as AccountLoaded;
            emit(
              currentState.copyWith(
                dailyData:
                    historyData.firstWhere((d) => d['type'] == 'daily')['data'],
                monthlyData:
                    historyData.firstWhere(
                      (d) => d['type'] == 'monthly',
                    )['data'],
              ),
            );
          }
        },
        onError: (error, stackTrace) {
          _talker.error(
            'Error in history stream from AppDatabase: $error',
            stackTrace,
          );
          if (state is AccountLoaded) {
            emit((state as AccountLoaded).copyWith(isLoading: false));
          }
          addError(error, stackTrace);
        },
      );
    } catch (e, stackTrace) {
      _talker.error('Failed to initialize history stream: $e', stackTrace);
      addError(e, stackTrace);
      emit(const AccountState.error('Ошибка инициализации потока данных'));
    }
  }

  Future<void> _onLoadAccount(
    LoadAccount event,
    Emitter<AccountState> emit,
  ) async {
    emit(const AccountState.loading());

    try {
      final account = await _repository.getAccount(event.accountId);
      
      final historyData =
          await _appDatabase.getTransactionHistoryStream().first;
      _talker.info('Initial history data loaded: $historyData');
      emit(
        AccountState.loaded(
          account: account,
          isBalanceVisible: true,
          dailyData:
              historyData.firstWhere((d) => d['type'] == 'daily')['data'],
          monthlyData:
              historyData.firstWhere((d) => d['type'] == 'monthly')['data'],
          currentPeriod: 'daily',
        ),
      );
    } catch (e) {
      emit(AccountState.error(e.toString()));
    }
  }

  Future<void> _onUpdateAccount(
    UpdateAccount event,
    Emitter<AccountState> emit,
  ) async {
    final currentState = state;
    if (currentState is AccountLoaded) {
      emit(currentState.copyWith(isLoading: true));

      try {
        await _repository.updateAccount(event.accountId, event.request);
        final updatedAccount = await _repository.getAccount(event.accountId);
        final historyData =
            await _appDatabase.getTransactionHistoryStream().first;
        emit(
          currentState.copyWith(
            account: updatedAccount,
            isLoading: false,
            dailyData:
                historyData.firstWhere((d) => d['type'] == 'daily')['data'],
            monthlyData:
                historyData.firstWhere((d) => d['type'] == 'monthly')['data'],
          ),
        );
      } catch (e) {
        emit(currentState.copyWith(isLoading: false));
        emit(AccountState.error(e.toString()));
      }
    }
  }

  Future<void> _onToggleBalanceVisibility(
    ToggleBalanceVisibility event,
    Emitter<AccountState> emit,
  ) async {
    final currentState = state;
    if (currentState is AccountLoaded) {
      emit(
        currentState.copyWith(isBalanceVisible: !currentState.isBalanceVisible),
      );
    }
  }

  Future<void> _onRefreshAccount(
    RefreshAccount event,
    Emitter<AccountState> emit,
  ) async {
    final currentState = state;

    if (currentState is AccountLoaded) {
      try {
        final account = await _repository.getAccount(event.accountId);
        final historyData =
            await _appDatabase.getTransactionHistoryStream().first;
        emit(
          currentState.copyWith(
            account: account,
            dailyData:
                historyData.firstWhere((d) => d['type'] == 'daily')['data'],
            monthlyData:
                historyData.firstWhere((d) => d['type'] == 'monthly')['data'],
          ),
        );
      } catch (e) {
        emit(AccountState.error(e.toString()));
      }
    }
  }

  void _onSwitchPeriod(SwitchPeriod event, Emitter<AccountState> emit) {
    final currentState = state;
    if (currentState is AccountLoaded) {
      emit(currentState.copyWith(currentPeriod: event.period));
    }
  }

  @override
  Future<void> close() {
    try {
      _historySubscription.cancel();
    } catch (e, stackTrace) {
      _talker.error('Failed to cancel history subscription: $e', stackTrace);
      addError(e, stackTrace);
    }
    return super.close();
  }
}
