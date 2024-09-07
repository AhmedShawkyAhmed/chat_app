part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class LoginLoading extends AuthState {}

final class LoginSuccess extends AuthState {}

final class LoginFailure extends AuthState {
  final String? message;

  LoginFailure({this.message});
}

final class RegisterLoading extends AuthState {}

final class RegisterSuccess extends AuthState {}

final class RegisterFailure extends AuthState {}

final class GetUserLoading extends AuthState {}

final class GetUserSuccess extends AuthState {}

final class GetUserFailure extends AuthState {}

final class GetAllUserLoading extends AuthState {}

final class GetAllUserSuccess extends AuthState {
  final List<UserModel> users;

  GetAllUserSuccess({required this.users});
}

final class GetAllUserFailure extends AuthState {}
