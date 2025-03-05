import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matiz/features/validation/bloc/merch_validation_bloc.dart';
import 'package:matiz/features/validation/bloc/merch_validation_event.dart';
import 'package:matiz/features/validation/bloc/merch_validation_state.dart';

class ValidationModal extends StatefulWidget {
  final File imageFile;
  final String merchId;
  final String artistId;

  const ValidationModal(
      {super.key,
      required this.imageFile,
      required this.merchId,
      required this.artistId});

  @override
  _ValidationModalState createState() => _ValidationModalState();
}

class _ValidationModalState extends State<ValidationModal> {
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  /// 📤 **Trigger Validation via Bloc**
  void _submitValidation() {
    if (_codeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("⚠️ Debes ingresar un código de validación."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // ✅ Dispatch event to validate poster
    context.read<MerchValidationBloc>().add(ValidatePoster(
          imageFile: widget.imageFile,
          merchId: widget.merchId,
          artistId: widget.artistId,
          validationCode: _codeController.text,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets, // Adjust for keyboard
      child: BlocConsumer<MerchValidationBloc, MerchValidationState>(
        listener: (context, state) {
          if (state is MerchValidationSuccess) {
            Navigator.of(context).pop(); // ✅ Close modal on success
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                    "EL POSTER HA SIDO SOMETIDO PARA VALIDACIÓN. REGRESE PRONTO PARA VER RESULTADO."),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 5),
              ),
            );
          } else if (state is MerchValidationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("❌ ${state.error}"),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          bool isLoading = state is MerchValidationLoading;

          return Container(
            padding:
                const EdgeInsets.symmetric(vertical: 45.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Wrap(
              children: [
                // 📌 **Header Bar**
                Center(
                  child: Container(
                    height: 5,
                    width: 50,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                // 📌 **Content Row (Image + Form)**
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🖼 **Poster Image**
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        widget.imageFile,
                        width: 200,
                        height: 320, // Prevents it from taking too much space
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),

                    // 📌 **Validation Form**
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "INTRODUCE EL CÓDIGO QUE TE ENVIAMOS AL COMPRAR EL PÓSTER EN NUESTRA TIENDA.",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 12),

                          // 📝 **Code Input**
                          TextField(
                            controller: _codeController,
                            decoration: InputDecoration(
                              labelText: "CÓDIGO DE VALIDACIÓN",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // 📤 **Submit Button**
                          ElevatedButton(
                            onPressed: isLoading ? null : _submitValidation,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  isLoading ? Colors.grey : Colors.black,
                              foregroundColor: Colors.white,
                            ),
                            child: isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : const Text("VALIDAR PÓSTER"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
