part of 'splash_cubit.dart';

@immutable
sealed class SplashState {}

final class SplashInitial extends SplashState {}

class GetUserLoading extends SplashState {}
class GetUserSuccess extends SplashState {}
class GetUserFailure extends SplashState {}
