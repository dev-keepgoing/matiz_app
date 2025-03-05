import 'package:equatable/equatable.dart';
import 'package:matiz/features/authentication/data/models/user_data.dart';

abstract class AuthenticationState extends Equatable {
  @override
  List<Object> get props => [];
}

// Initial state when the app starts
class AuthenticationInitial extends AuthenticationState {}

// State when the user is authenticated
class AuthenticationAuthenticated extends AuthenticationState {
  final UserData userData;

  AuthenticationAuthenticated({required this.userData});

  @override
  List<Object> get props => [userData];
}

// State when the user is unauthenticated
class AuthenticationUnauthenticated extends AuthenticationState {}

// State when an authentication action is in progress (e.g., login)
class AuthenticationLoading extends AuthenticationState {}

// State when an authentication error occurs
class AuthenticationFailure extends AuthenticationState {
  final String error;

  AuthenticationFailure({required this.error});

  @override
  List<Object> get props => [error];
}

class AuthenticationInvalidCredentials extends AuthenticationState {
  final String errorMessage;

  AuthenticationInvalidCredentials({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
