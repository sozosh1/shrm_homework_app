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

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.singleton<_i847.CategoryRepository>(
      () => _i1064.MockCategoryRepository(),
    );
    gh.singleton<_i104.AccountRepository>(() => _i938.MockAccountRepository());
    gh.singleton<_i472.TransactionRepository>(
      () => _i624.MockTransitionRepository(),
    );
    return this;
  }
}
