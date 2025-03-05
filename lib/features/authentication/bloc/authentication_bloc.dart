import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matiz/features/authentication/bloc/authentication_event.dart';
import 'package:matiz/features/authentication/bloc/authentication_state.dart';
import 'package:matiz/features/authentication/data/respositories/authentication_repository.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository authenticationRepository;

  AuthenticationBloc({required this.authenticationRepository})
      : super(AuthenticationInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LogoutRequested>(_onLogoutRequested);
    on<LoginRequested>(_onLoginRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
    on<DeleteAccountRequested>(_onDeleteAccountRequested);
    on<AppleSignInRequested>(_onAppleSignInRequested);
  }

  Future<void> _onLogoutRequested(
      LogoutRequested event, Emitter<AuthenticationState> emit) async {
    //emit(AuthenticationLoading());
    try {
      await authenticationRepository.signOut();
      emit(AuthenticationUnauthenticated());
    } catch (e) {
      emit(AuthenticationFailure(error: e.toString()));
    }
  }

  Future<void> _onAppStarted(
      AppStarted event, Emitter<AuthenticationState> emit) async {
    //emit(AuthenticationLoading());
    try {
      final response =
          await authenticationRepository.getCurrentUserWithUserData();
      if (response.success) {
        emit(AuthenticationAuthenticated(userData: response.data));
      } else {
        emit(AuthenticationUnauthenticated());
      }
    } catch (e) {
      print("we are getting error, ${e.toString()}");
      //final errorMessage = e.toString().replaceFirst('Exception: ', '');
      //emit(AuthenticationFailure(error: errorMessage));
    }
  }

  // Handle LoginRequested event
  Future<void> _onLoginRequested(
      LoginRequested event, Emitter<AuthenticationState> emit) async {
    try {
      // 🔍 **Validate Credentials Before Loading**
      final bool isValid = await authenticationRepository
          .validateEmailAndPassword(event.email, event.password);

      if (!isValid) {
        emit(AuthenticationInvalidCredentials(
            errorMessage:
                "EL CORREO ELECTRÓNICO O LA CONTRASEÑA SON INCORRECTOS."));
        return;
      }

      // ✅ Credentials are valid → Show loading before fetching user data
      emit(AuthenticationLoading());

      await Future.delayed(Duration(seconds: 3));

      // 🔥 Fetch user data
      final response =
          await authenticationRepository.getCurrentUserWithUserData();

      if (response.success) {
        emit(AuthenticationAuthenticated(userData: response.data));
      } else {
        emit(AuthenticationUnauthenticated());
      }
    } catch (e) {
      emit(AuthenticationFailure(error: e.toString()));
    }
  }

  // Handle GoogleSignInRequested event
  Future<void> _onGoogleSignInRequested(
      GoogleSignInRequested event, Emitter<AuthenticationState> emit) async {
    try {
      // 🔥 Sign in with Google and capture UserCredential
      final userCredential = await authenticationRepository.signInWithGoogle();

      emit(AuthenticationLoading());

      // 🔍 Check if the user is newly created
      final bool isNewUser =
          userCredential?.additionalUserInfo?.isNewUser ?? false;

      // ⏳ If new user, wait 1 second before fetching user data
      if (isNewUser) {
        await Future.delayed(Duration(seconds: 3));
      }

      final response =
          await authenticationRepository.getCurrentUserWithUserData();

      if (response.success) {
        emit(AuthenticationAuthenticated(userData: response.data));
      } else {
        emit(AuthenticationUnauthenticated());
      }
    } catch (e) {
      emit(AuthenticationFailure(error: e.toString()));
    }
  }

  Future<void> _onAppleSignInRequested(
      AppleSignInRequested event, Emitter<AuthenticationState> emit) async {
    try {
      // Start Loading
      emit(AuthenticationLoading());

      // 🔥 Sign in with Apple
      final userCredential = await authenticationRepository.signInWithApple();

      // 🔍 Check if the user is newly created
      final bool isNewUser =
          userCredential?.additionalUserInfo?.isNewUser ?? false;

      // ⏳ If new user, wait 1 second before fetching user data
      if (isNewUser) {
        await Future.delayed(Duration(seconds: 3));
      }

      // Fetch user data after sign-in
      final response =
          await authenticationRepository.getCurrentUserWithUserData();

      if (response.success) {
        emit(AuthenticationAuthenticated(userData: response.data));
      } else {
        emit(AuthenticationUnauthenticated());
      }
    } catch (e) {
      emit(AuthenticationFailure(error: e.toString()));
    }
  }

  Future<void> _onDeleteAccountRequested(
      DeleteAccountRequested event, Emitter<AuthenticationState> emit) async {
    try {
      await authenticationRepository.deleteAccount();
      emit(AuthenticationUnauthenticated()); // Reset authentication state
    } catch (e) {
      emit(AuthenticationFailure(error: e.toString()));
    }
  }

  Future<void> _onSignUpRequested(
      SignUpRequested event, Emitter<AuthenticationState> emit) async {
    try {
      // Call the repository method to create a new user
      await authenticationRepository.signUpWithEmailAndPassword(
        event.email,
        event.password,
      );
      emit(AuthenticationLoading());

      await Future.delayed(Duration(seconds: 3));

      // Retrieve user data after sign-up
      final response =
          await authenticationRepository.getCurrentUserWithUserData();

      if (response.success) {
        emit(AuthenticationAuthenticated(userData: response.data));
      } else {
        emit(AuthenticationUnauthenticated());
      }
    } catch (e) {
      emit(AuthenticationFailure(error: e.toString()));
    }
  }
}
