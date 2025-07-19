import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:shrm_homework_app/features/account/data/repository/account_repository_impl.dart';
import 'package:shrm_homework_app/features/account/domain/repository/account_repository.dart';
import 'package:shrm_homework_app/features/transaction/data/repository/transaction_repository_impl.dart';
import 'package:shrm_homework_app/features/transaction/domain/repository/transaction_repository.dart';

@injectable
class SyncWorker {
  final TransactionRepository _transactionRepository;
  final AccountRepository _accountRepository;
  Timer? _timer;

  SyncWorker(this._transactionRepository, this._accountRepository);

  void start() {
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      await _processEvents();
    });
  }

  void stop() {
    _timer?.cancel();
  }

  Future<void> _processEvents() async {
    await (_transactionRepository as TransactionRepositoryImpl)
        .processSyncEvents();
    await (_accountRepository as AccountRepositoryImpl).processSyncEvents();
  }
}