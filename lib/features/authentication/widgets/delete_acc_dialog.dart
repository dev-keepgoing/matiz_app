import 'package:flutter/material.dart';

void showDeleteConfirmationDialog({
  required BuildContext context,
  required VoidCallback onConfirm,
}) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text("BORRA TU CUENTA"),
        content: const Text(
          "ESTAS SEGURO QUE QUIERES BORRAR LA CUENTA DE matiz? PERDERAS TU COLECCIÓN DIGITAL SI PROSIGUES EN BORRAR LA CUENTA.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(); // Close the dialog
            },
            child: Text(
              "NO",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(); // Close the dialog
              onConfirm(); // Execute the deletion callback
            },
            child: Text(
              "SÍ",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.red),
            ),
          ),
        ],
      );
    },
  );
}
