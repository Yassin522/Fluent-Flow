import 'package:fluent_flow/core/cache/cache_helper.dart';
import 'package:fluent_flow/cubits/fluent_flow/fluent_flow_cubit.dart';

import 'package:fluent_flow/features/login/data/data_sources/login_remote_data_source.dart';
import 'package:fluent_flow/features/login/data/repositories/login_repository_impl.dart';
import 'package:fluent_flow/features/login/domain/repositories/login_repo.dart';
import 'package:fluent_flow/features/login/presentation/bloc/login_bloc.dart';
import 'package:fluent_flow/features/onboarding/data/data_sources/onboard_local_data_source.dart';
import 'package:fluent_flow/features/onboarding/data/repositories/onboard_repository_impl.dart';
import 'package:fluent_flow/features/onboarding/domain/repositories/onboard_repo.dart';
import 'package:fluent_flow/features/onboarding/domain/usecases/get_onboard_info.dart';
import 'package:fluent_flow/features/onboarding/domain/usecases/save_onboard_first_time.dart';
import 'package:fluent_flow/features/onboarding/presentation/bloc/onboard_bloc.dart';
import 'package:fluent_flow/features/register/data/data_sources/register_remote_source.dart';
import 'package:fluent_flow/features/register/data/repositories/register_repo_impl.dart';
import 'package:fluent_flow/features/register/domain/repositories/register_repo.dart';
import 'package:fluent_flow/features/register/domain/usecases/register.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'core/remote/remote_helper.dart';
import 'features/login/domain/usecases/login.dart';
import 'features/register/presentation/blocs/register_bloc.dart';

final getIt = GetIt.instance;

Future<void> init() async {

  //---------------------------------------- blocs
  getIt.registerFactory(() => FluentCubit());
  getIt.registerFactory(() => RegisterBloc(register: getIt()));
  getIt.registerFactory(() => LoginBloc(login: getIt()));
  getIt.registerFactory(() => OnBoardBloc(getOnBoardInfo: getIt(), saveOnBoardFirstTime: getIt()));

  //---------------------------------------- usecase
  getIt.registerLazySingleton(() => Register(repository: getIt()));
  getIt.registerLazySingleton(() => Login(repository: getIt()));
  getIt.registerLazySingleton(() => GetOnBoardInfo(repository: getIt()));
  getIt.registerLazySingleton(() => SaveOnBoardFirstTime(repository: getIt()));

  //---------------------------------------- repositories
  getIt.registerLazySingleton<RegisterRepository>( ()=> RegisterRepositoryImpl(remoteDataSource: getIt()));
  getIt.registerLazySingleton<LogInRepository>( ()=> LogInRepositoryImpl(remoteDataSource: getIt(), cacheHelper: getIt()));
  getIt.registerLazySingleton<OnBoardRepository>( ()=> OnBoardRepositoryImpl(localDataSource: getIt()));

  //---------------------------------------- data sources
  getIt.registerLazySingleton<RegisterRemoteDataSource>( ()=> RegisterRemoteDataSource(httpClient: getIt()));
  getIt.registerLazySingleton<LogInRemoteDataSource>( ()=> LogInRemoteDataSource(httpClient: getIt()));
  getIt.registerLazySingleton<OnBoardLocalDataSource>( ()=> OnBoardLocalDataSourceImpl(cacheHelper: getIt()));

  // --------------------------------------- core
  getIt.registerLazySingleton<http.Client>( ()=> http.Client());
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>( ()=> sharedPreferences);

  getIt.registerLazySingleton<CacheHelper>( ()=> CacheHelper(sharedPreferences: getIt()));
  getIt.registerLazySingleton<RemoteHelper>( ()=> RemoteHelper(cacheHelper: getIt(), httpClient: getIt()));

}