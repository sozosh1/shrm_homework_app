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

import '../../features/account/data/repository/mock_account_repository.dart'
    as _i938;
import '../../features/account/domain/repository/account_repository.dart'
    as _i104;
import '../../features/category/data/repository/mock_category_repository.dart'
    as _i1064;
import '../../features/category/domain/repository/category_repository.dart'
    as _i847;
import '../../features/transaction/data/repository/mock_transaction_repository.dart'
    as _i624;
import '../../features/transaction/domain/repository/transaction_repository.dart'
    as _i472;
import '../../features/transaction/presentation/bloc/transaction_bloc.dart'
    as _i356;
import '../../features/transaction/presentation/bloc/transaction_history/transaction_history_bloc.dart'
    as _i1051;
import '../database/app_database.dart' as _i982;
import '../storage/preferences_service.dart' as _i636;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.singleton<_i982.AppDatabase>(() => _i982.AppDatabase());
    gh.singleton<_i636.PreferencesService>(() => _i636.PreferencesService());
    gh.factory<_i847.CategoryRepository>(() => _i1064.MockCategoryRepository());
    gh.factory<_i104.AccountRepository>(() => _i938.MockAccountRepository());
    gh.factory<_i472.TransactionRepository>(
      () => _i624.MockTransitionRepository(),
    );
    gh.factory<_i356.TransactionBloc>(
      () => _i356.TransactionBloc(gh<_i472.TransactionRepository>()),
    );
    gh.factory<_i1051.TransactionHistoryBloc>(
      () => _i1051.TransactionHistoryBloc(gh<_i472.TransactionRepository>()),
    );
    return this;
  }
}
