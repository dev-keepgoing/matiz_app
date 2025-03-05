import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:matiz/features/authentication/bloc/authentication_bloc.dart';
import 'package:matiz/features/authentication/bloc/authentication_event.dart';
import 'package:matiz/features/authentication/bloc/authentication_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController confirmEmailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isEmailLoginVisible = false;
  bool _isCreatingAccount = false; // Toggle between login & sign-up

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is AuthenticationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
                duration:
                    Duration(seconds: 10), // 🔥 Keep the message for 10 seconds
              ),
            );
          } else if (state is AuthenticationInvalidCredentials) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.black,
                duration:
                    Duration(seconds: 10), // 🔥 Keep the message for 10 seconds
              ),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              SafeArea(
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag, // Hide keyboard
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 60),
                        // Welcome Text
                        Text("BIENVENIDxS",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineMedium),
                        const SizedBox(height: 8.0),
                        Text(
                          "ENTRA A TU CUENTA PARA EMPEZAR A COLECCIONAR POSTERS.",
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: Colors.grey),
                        ),
                        const SizedBox(height: 30.0),

                        // **Google Sign-In Button**
                        _buildGoogleLoginButton(context),

                        const SizedBox(height: 40.0),

                        if (Platform.isIOS)
                          // **Apple Sign-In Button** (Added below Google Sign-In)
                          _buildAppleLoginButton(context),
                        if (Platform.isIOS) const SizedBox(height: 20.0),

                        // **Show Email Login Form Only If Toggled**
                        if (_isEmailLoginVisible) _buildEmailLoginForm(context),

                        if (!_isEmailLoginVisible)
                          // **Toggle Between Google & Email Login**
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isEmailLoginVisible = !_isEmailLoginVisible;
                              });
                            },
                            child: Text(
                              "USAR EMAIL Y CONTRASEÑA",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                            ),
                          ),

                        const SizedBox(height: 30.0),
                      ],
                    ),
                  ),
                ),
              ),

              // **Loading Overlay**
              if (state is AuthenticationLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  /// **Google Sign-In Button**
  Widget _buildGoogleLoginButton(BuildContext context) {
    return SizedBox(
        height: 40.0, // Adjust the height as needed
        child: SignInButton(
          Buttons.Google,
          onPressed: () {
            context.read<AuthenticationBloc>().add(GoogleSignInRequested());
          },
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(10.0), // Rounded corners for consistency
          ),
        ));
  }

  /// **Apple Sign-In Button**
  Widget _buildAppleLoginButton(BuildContext context) {
    return SizedBox(
      height: 40.0, // Adjust the height as needed
      child: SignInButton(
        Buttons.Apple,
        onPressed: () {
          context.read<AuthenticationBloc>().add(AppleSignInRequested());
        },
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(10.0), // Rounded corners for consistency
        ),
      ),
    );
  }

  /// **Email & Password Login Form**
  Widget _buildEmailLoginForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: "EMAIL",
              hintText: "INGRESA TU EMAIL",
              border: OutlineInputBorder(),
            ),
            validator: (value) =>
                value!.isEmpty ? "EL EMAIL ES OBLIGATORIO" : null,
          ),
          const SizedBox(height: 16.0),

          // **Confirm Email (Only for Sign-Up)**
          if (_isCreatingAccount)
            TextFormField(
              controller: confirmEmailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "CONFIRMA EMAIL",
                hintText: "VUELVE A INGRESAR TU EMAIL",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return "CONFIRMAR EMAIL ES OBLIGATORIO";
                } else if (value != emailController.text) {
                  return "LOS EMAILS NO COINCIDEN";
                }
                return null;
              },
            ),
          if (_isCreatingAccount) const SizedBox(height: 16.0),

          TextFormField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: "CONTRASEÑA",
              hintText: "INGRESA TU CONTRASEÑA",
              border: OutlineInputBorder(),
            ),
            validator: (value) =>
                value!.isEmpty ? "LA CONTRASEÑA ES OBLIGATORIA" : null,
          ),
          const SizedBox(height: 16.0),

          // **Confirm Password (Only for Sign-Up)**
          if (_isCreatingAccount)
            TextFormField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "CONFIRMA CONTRASEÑA",
                hintText: "VUELVE A INGRESAR TU CONTRASEÑA",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return "CONFIRMAR CONTRASEÑA ES OBLIGATORIO";
                } else if (value != passwordController.text) {
                  return "LAS CONTRASEÑAS NO COINCIDEN";
                }
                return null;
              },
            ),
          if (_isCreatingAccount) const SizedBox(height: 16.0),

          // **Login or Sign-Up Button**
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                if (_isCreatingAccount) {
                  context.read<AuthenticationBloc>().add(
                        SignUpRequested(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        ),
                      );
                } else {
                  context.read<AuthenticationBloc>().add(
                        LoginRequested(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        ),
                      );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
            ),
            child: Text(_isCreatingAccount ? "CREAR CUENTA" : "INICIAR SESIÓN"),
          ),

          const SizedBox(height: 16.0),

          // **Toggle Between Login & Sign-Up**
          TextButton(
            onPressed: () {
              setState(() {
                _isCreatingAccount = !_isCreatingAccount;
              });
            },
            child: Text(
              _isCreatingAccount
                  ? "¿YA TIENES UNA CUENTA? INICIA SESIÓN"
                  : "¿NO TIENES UNA CUENTA? CREAR UNA",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
