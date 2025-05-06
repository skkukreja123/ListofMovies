import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:state_managment/core/error/network_info.dart';
import 'package:state_managment/data/service/movie_service.dart';
import 'package:state_managment/viewmodel/movie_view.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton(() => Connectivity());

  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));

  getIt.registerLazySingleton<MovieService>(
      () => MovieServiceImpl(networkInfo: getIt()));

  getIt.registerFactory(() => MovieViewModel(getIt()));
}
