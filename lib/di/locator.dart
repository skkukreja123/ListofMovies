import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:state_managment/core/error/network_info.dart';
import 'package:state_managment/data/service/auth_service.dart';
import 'package:state_managment/data/service/movie_service.dart';
import 'package:state_managment/resporitory/auth_resporitory.dart';
import 'package:state_managment/resporitory/movie_resporitory.dart';
import 'package:state_managment/viewmodel/auth_view_model.dart';
import 'package:state_managment/viewmodel/movie_view.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton(() => Connectivity());
  getIt.registerLazySingleton(() => FirebaseAuth.instance);
  getIt.registerLazySingleton(() => FirebaseFirestore.instance);

  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));

  getIt.registerLazySingleton<MovieService>(
      () => MovieServiceImpl(networkInfo: getIt()));

  getIt.registerLazySingleton<AuthService>(
      () => AuthServiceImpl(networkInfo: getIt()));

  getIt.registerFactory(() => MovieViewModel(getIt()));

  getIt.registerFactory(() => AuthViewModel(getIt()));

  getIt.registerLazySingleton<MovieRepository>(
      () => MovieRepositoryImpl(service: getIt(), networkInfo: getIt()));

  getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(authService: getIt()));
}
