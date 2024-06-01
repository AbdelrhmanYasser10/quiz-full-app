part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}
class RegisterLoading extends AuthState{}
class RegisterSuccessfully extends AuthState{}
class RegisterError extends AuthState{
final String message;
RegisterError({required this.message});
}

class LogOutLoading extends AuthState{}
class LogOutSuccessfully extends AuthState{}
class LogOutError extends AuthState{
  final String message;
  LogOutError({required this.message});
}