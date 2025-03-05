import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matiz/features/authentication/bloc/authentication_bloc.dart';
import 'package:matiz/features/authentication/bloc/authentication_event.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () {
          // Dispatch the LogoutRequested event to the AuthenticationBloc
          context.read<AuthenticationBloc>().add(LogoutRequested());
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        ),
        child: const Text(
          "CIERRA SESÍON",
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}
