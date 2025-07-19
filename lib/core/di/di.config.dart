// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:ui' as _i264;

import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:talker_flutter/talker_flutter.dart' as _i207;

import '../../features/account/data/datasources/local_account_data_source.dart'
    as _i761;
import '../../features/account/data/datasources/remote_account_datasource.dart'
    as _i422;
import '../../features/account/data/repository/account_repository_impl.dart'
    as _i852;
import '../../features/account/domain/repository/account_repository.dart'
    as _i104;
import '../../features/account/presentation/bloc/account_bloc.dart' as _i708;
import '../../features/category/data/datasources/local_category_data_source.dart'
    as _i212;
import '../../features/category/data/datasources/remote_category_datasource.dart'
    as _i660;
import '../../features/category/data/repository/category_repository_impl.dart'
    as _i1004;
import '../../features/category/domain/repository/category_repository.dart'
    as _i847;
import '../../features/category/domain/usecases/fuzzy_search_usecase.dart'
    as _i578;
import '../../features/category/presentation/bloc/category_bloc.dart' as _i292;
import '../../features/settings/presentation/cubit/settings_cubit.dart'
    as _i792;
import '../../features/transaction/data/datasources/local_transaction_data_source.dart'
    as _i785;
import '../../features/transaction/data/datasources/remote_transaction_datasource.dart'
    as _i607;
import '../../features/transaction/data/repository/transaction_repository_impl.dart'
    as _i857;
import '../../features/transaction/domain/repository/transaction_repository.dart'
    as _i472;
import '../../features/transaction/presentation/bloc/transaction_bloc.dart'
    as _i356;
import '../../features/transaction/presentation/bloc/transaction_history/transaction_history_bloc.dart'
    as _i1051;
import '../database/app_database.dart' as _i982;
import '../events/theme_cubit.dart' as _i615;
import '../network/connectivity_service.dart' as _i491;
import '../network/dio_client.dart' as _i667;
import '../services/currency_service.dart' as _i31;
import '../services/settings_service.dart' as _i114;
import '../services/sync_event_service.dart' as _i851;
import '../services/sync_worker.dart' as _i493;
import '../services/theme_service.dart' as _i982;
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
    gh.factory<_i114.SettingsService>(() => _i114.SettingsService());
    gh.factory<_i578.FuzzySearchUseCase>(() => _i578.FuzzySearchUseCase());
    gh.singleton<_i207.Talker>(() => talkerModule.talker);
    gh.singletonAsync<_i636.PreferencesService>(() {
      final i = _i636.PreferencesService();
      return i.init().then((_) => i);
    });
    gh.factory<_i792.SettingsCubit>(
      () => _i792.SettingsCubit(gh<_i114.SettingsService>()),
    );
    gh.factory<_i615.ThemeState>(
      () => _i615.ThemeState(gh<_i264.Color>(), gh<bool>()),
    );
    gh.singletonAsync<_i31.CurrencyService>(() async {
      final i = _i31.CurrencyService(
        await getAsync<_i636.PreferencesService>(),
      );
      return i.init().then((_) => i);
    });
    gh.singletonAsync<_i982.ThemeService>(
      () async =>
          _i982.ThemeService(await getAsync<_i636.PreferencesService>()),
    );
    gh.singleton<_i982.AppDatabase>(
      () => _i982.AppDatabase(gh<_i207.Talker>()),
    );
    gh.singleton<_i491.ConnectivityService>(
      () => _i491.ConnectivityService(gh<_i207.Talker>()),
    );
    gh.factory<_i851.SyncEventService>(
      () => _i851.SyncEventServiceImpl(
        gh<_i982.AppDatabase>(),
        gh<_i207.Talker>(),
      ),
    );
    gh.lazySingleton<_i761.LocalAccountDataSource>(
      () => _i761.LocalAccountDataSourceImpl(
        gh<_i982.AppDatabase>(),
        gh<_i207.Talker>(),
      ),
    );
    gh.factoryAsync<_i615.ThemeCubit>(
      () async => _i615.ThemeCubit(await getAsync<_i982.ThemeService>()),
    );
    gh.singleton<_i667.DioClient>(
      () => _i667.DioClient(
        gh<_i207.Talker>(),
        gh<String>(instanceName: 'bearerToken'),
        gh<_i491.ConnectivityService>(),
      ),
    );
    gh.lazySingleton<_i212.LocalCategoryDataSource>(
      () => _i212.LocalCategoryDataSourceImpl(
        gh<_i982.AppDatabase>(),
        gh<_i207.Talker>(),
      ),
    );
    gh.lazySingleton<_i607.RemoteTransactionDataSource>(
      () => _i607.RemoteTransactionDataSourceImpl(
        gh<_i667.DioClient>(),
        gh<_i207.Talker>(),
      ),
    );
    gh.lazySingleton<_i660.RemoteCategoryDataSource>(
      () => _i660.RemoteCategoryDataSourceImpl(
        gh<_i667.DioClient>(),
        gh<_i207.Talker>(),
      ),
    );
    gh.lazySingleton<_i422.RemoteAccountDataSource>(
      () => _i422.RemoteAccountDataSourceImpl(
        gh<_i667.DioClient>(),
        gh<_i207.Talker>(),
      ),
    );
    gh.factory<_i104.AccountRepository>(
      () => _i852.AccountRepositoryImpl(
        gh<_i761.LocalAccountDataSource>(),
        gh<_i422.RemoteAccountDataSource>(),
        gh<_i851.SyncEventService>(),
        gh<_i207.Talker>(),
      ),
    );
    gh.factory<_i847.CategoryRepository>(
      () => _i1004.CategoryRepositoryImpl(
        gh<_i212.LocalCategoryDataSource>(),
        gh<_i660.RemoteCategoryDataSource>(),
        gh<_i851.SyncEventService>(),
      ),
    );
    gh.lazySingleton<_i785.LocalTransactionDataSource>(
      () => _i785.LocalTransactionDataSourceImpl(
        gh<_i982.AppDatabase>(),
        gh<_i207.Talker>(),
        gh<_i761.LocalAccountDataSource>(),
        gh<_i212.LocalCategoryDataSource>(),
      ),
    );
    gh.factory<_i708.AccountBloc>(
      () => _i708.AccountBloc(gh<_i104.AccountRepository>()),
    );
    gh.factory<_i472.TransactionRepository>(
      () => _i857.TransactionRepositoryImpl(
        gh<_i785.LocalTransactionDataSource>(),
        gh<_i607.RemoteTransactionDataSource>(),
        gh<_i851.SyncEventService>(),
        gh<_i207.Talker>(),
      ),
    );
    gh.factory<_i292.CategoryBloc>(
      () => _i292.CategoryBloc(
        gh<_i578.FuzzySearchUseCase>(),
        gh<_i847.CategoryRepository>(),
      ),
    );
    gh.factory<_i493.SyncWorker>(
      () => _i493.SyncWorker(
        gh<_i472.TransactionRepository>(),
        gh<_i104.AccountRepository>(),
      ),
    );
    gh.factory<_i356.TransactionBloc>(
      () => _i356.TransactionBloc(
        gh<_i472.TransactionRepository>(),
        gh<_i847.CategoryRepository>(),
        gh<_i104.AccountRepository>(),
        gh<_i207.Talker>(),
      ),
    );
    gh.factory<_i1051.TransactionHistoryBloc>(
      () => _i1051.TransactionHistoryBloc(
        gh<_i472.TransactionRepository>(),
        gh<_i761.LocalAccountDataSource>(),
      ),
    );
    return this;
  }
}

class _$TalkerModule extends _i956.TalkerModule {}
