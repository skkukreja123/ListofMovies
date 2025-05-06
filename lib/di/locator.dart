import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupLocator() {
  // Register your services and view models here
  // Example: getIt.registerLazySingleton<SomeService>(() => SomeServiceImpl());
  // getIt.registerFactory<SomeViewModel>(() => SomeViewModel(getIt<SomeService>()));
}
