import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matiz/features/validation/data/merch_validation_repository.dart';
import 'merch_validation_event.dart';
import 'merch_validation_state.dart';

class MerchValidationBloc
    extends Bloc<MerchValidationEvent, MerchValidationState> {
  final MerchValidationRepository repository;

  MerchValidationBloc({required this.repository})
      : super(MerchValidationInitial()) {
    on<ValidatePoster>(_onValidatePoster);
  }

  Future<void> _onValidatePoster(
      ValidatePoster event, Emitter<MerchValidationState> emit) async {
    emit(MerchValidationLoading());

    try {
      print("trying validation");
      final response = await repository.validatePoster(
        artistId: event.artistId,
        imageFile: event.imageFile,
        merchId: event.merchId,
        validationCode: event.validationCode,
      );

      print("is validation working ${response.success}");

      if (response.success) {
        final validationId =
            response.data['validationId'] ?? "UNKNOWN_ID"; // Default value
        final imageUrl =
            response.data['imageUrl'] ?? "UNKNOWN_IMAGE_URL"; // Default value

        emit(MerchValidationSuccess(
            validationId: validationId, imageUrl: imageUrl));
      } else {
        emit(MerchValidationFailure(
            response.message ?? "Unknown error occurred"));
      }
    } catch (e) {
      emit(MerchValidationFailure("🔥 Error: $e"));
    }
  }
}
