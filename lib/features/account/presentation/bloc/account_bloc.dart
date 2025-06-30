import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shrm_homework_app/features/account/domain/repository/account_repository.dart';
import 'account_event.dart';
import 'account_state.dart';

@injectable
class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final AccountRepository _repository;

  AccountBloc(this._repository) : super(const AccountState.initial()) {
    on<LoadAccount>(_onLoadAccount);
    on<UpdateAccount>(_onUpdateAccount);
    on<ToggleBalanceVisibility>(_onToggleBalanceVisibility);
    on<RefreshAccount>(_onRefreshAccount);
  }

  Future<void> _onLoadAccount(
    LoadAccount event,
    Emitter<AccountState> emit,
  ) async {
    emit(const AccountState.loading());

    try {
      final account = await _repository.getAccount(event.accountId);
      
      emit(AccountState.loaded(account: account, isBalanceVisible: true));
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

        emit(currentState.copyWith(account: updatedAccount, isLoading: false));
      } catch (e) {
        emit(currentState.copyWith(isLoading: false));
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
        emit(currentState.copyWith(account: account));
      } catch (e) {
        emit(AccountState.error(e.toString()));
      }
    }
  }
}
