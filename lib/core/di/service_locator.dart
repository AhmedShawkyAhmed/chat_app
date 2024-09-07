import 'package:chat/features/auth/cubit/auth_cubit.dart';
import 'package:chat/features/auth/data/repo/auth_repo.dart';
import 'package:chat/features/splash/cubit/splash_cubit.dart';
import 'package:get_it/get_it.dart';

final instance = GetIt.instance;

Future<void> initAppModule() async {
  // --------------------- Cubit
  instance.registerFactory<SplashCubit>(() => SplashCubit());
  instance.registerFactory<AuthCubit>(() => AuthCubit());

  // --------------------- Repo
  instance.registerLazySingleton<AuthRepo>(() => AuthRepo());
}
