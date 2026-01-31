part of 'auth_cubit.dart';

sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthDone extends AuthState {
  const AuthDone();
}

final class AuthError extends AuthState {
  final String errorMessage;

  AuthError({required this.errorMessage});
}

final class AuthLoggedOut extends AuthState {
  const AuthLoggedOut();
}

final class AuthLoggingOut extends AuthState {
  const AuthLoggingOut();
}

final class AuthLoggingError extends AuthState {
  final String message;
  const AuthLoggingError(this.message);
}

final class GoogleAuthenticating extends AuthState {
  const GoogleAuthenticating();
}

final class GoogleAuthError extends AuthState {
  final String errorMessage;
  const GoogleAuthError(this.errorMessage);
}

final class GoogleAuthDone extends AuthState {
  const GoogleAuthDone();
}
