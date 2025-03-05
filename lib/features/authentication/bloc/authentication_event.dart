import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AppStarted extends AuthenticationEvent {}

class LoggedIn extends AuthenticationEvent {}

class LoggedOut extends AuthenticationEvent {}

/// Event for Email and Password Login
class LoginRequested extends AuthenticationEvent {
  final String email;
  final String password;

  LoginRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

/// Event for Email and Password Sign-Up (New Account Creation)
class SignUpRequested extends AuthenticationEvent {
  final String email;
  final String password;

  SignUpRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class LogoutRequested extends AuthenticationEvent {}

/// Event for Google Sign-In
class GoogleSignInRequested extends AuthenticationEvent {
  @override
  List<Object> get props => [];
}

/// Event for Account Deletion
class DeleteAccountRequested extends AuthenticationEvent {}

class AppleSignInRequested extends AuthenticationEvent {}
