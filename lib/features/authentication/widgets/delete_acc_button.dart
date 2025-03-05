import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matiz/features/authentication/bloc/authentication_bloc.dart';
import 'package:matiz/features/authentication/bloc/authentication_event.dart';
import 'package:matiz/features/authentication/widgets/delete_acc_dialog.dart';

class DeleteAccButton extends StatelessWidget {
  const DeleteAccButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40.0),
      child: ElevatedButton(
        onPressed: () => showDeleteConfirmationDialog(
          context: context,
          onConfirm: () {
            context.read<AuthenticationBloc>().add(DeleteAccountRequested());
          },
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red, // Red button to indicate danger
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        ),
        child: const Text(
          "BORRA CUENTA",
          style: TextStyle(fontSize: 16.0, color: Colors.white),
        ),
      ),
    );
  }
}
