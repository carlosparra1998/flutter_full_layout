part of 'auth_cubit.dart';

abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthUpdated extends AuthState {
  const AuthUpdated();
}

class AuthError extends AuthState {
  final String codeMessage;
  const AuthError(this.codeMessage);
}

class AuthLoading extends AuthState {
  final bool loading;
  const AuthLoading(this.loading);
}

class AuthSuccess extends AuthState {
  const AuthSuccess();
}
