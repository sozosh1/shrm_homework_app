// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:talker_flutter/talker_flutter.dart' as _i207;

import '../../features/account/data/repository/local_account_repository.dart'
    as _i766;
import '../../features/account/domain/repository/account_repository.dart'
    as _i104;
import '../../features/account/presentation/bloc/account_bloc.dart' as _i708;
import '../../features/category/data/repository/local_category_repository.dart'
    as _i1026;
import '../../features/category/domain/repository/category_repository.dart'
    as _i847;
import '../../features/category/domain/usecases/fuzzy_search_usecase.dart'
    as _i578;
import '../../features/category/presentation/bloc/category_bloc.dart' as _i292;
import '../../features/transaction/data/repository/local_transaction_repository.dart'
    as _i100;
import '../../features/transaction/domain/repository/transaction_repository.dart'
    as _i472;
import '../../features/transaction/presentation/bloc/transaction_bloc.dart'
    as _i356;
import '../../features/transaction/presentation/bloc/transaction_history/transaction_history_bloc.dart'
    as _i1051;
import '../database/app_database.dart' as _i982;
import '../storage/preferences_service.dart' as _i636;
import 'talker_module.dart' as _i956;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final talkerModule = _$TalkerModule();
    gh.factory<_i578.FuzzySearchUseCase>(() => _i578.FuzzySearchUseCase());
    gh.singleton<_i207.Talker>(() => talkerModule.talker);
    gh.singletonAsync<_i636.PreferencesService>(() {
      final i = _i636.PreferencesService();
      return i.init().then((_) => i);
    });
    gh.singleton<_i982.AppDatabase>(
      () => _i982.AppDatabase(gh<_i207.Talker>()),
    );
    gh.factory<_i847.CategoryRepository>(
      () => _i1026.LocalCategoryRepository(gh<_i982.AppDatabase>()),
    );
    gh.factory<_i472.TransactionRepository>(
      () => _i100.LocalTransactionRepository(gh<_i982.AppDatabase>()),
    );
    gh.factory<_i104.AccountRepository>(
      () => _i766.LocalAccountRepository(gh<_i982.AppDatabase>()),
    );
    gh.factory<_i292.CategoryBloc>(
      () => _i292.CategoryBloc(
        gh<_i847.CategoryRepository>(),
        gh<_i578.FuzzySearchUseCase>(),
      ),
    );
    gh.factory<_i356.TransactionBloc>(
      () => _i356.TransactionBloc(gh<_i472.TransactionRepository>()),
    );
    gh.factory<_i1051.TransactionHistoryBloc>(
      () => _i1051.TransactionHistoryBloc(gh<_i472.TransactionRepository>()),
    );
    gh.factory<_i708.AccountBloc>(
      () => _i708.AccountBloc(gh<_i104.AccountRepository>()),
    );
    return this;
  }
}

class _$TalkerModule extends _i956.TalkerModule {}
