import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class MerchValidationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ValidatePoster extends MerchValidationEvent {
  final File imageFile;
  final String artistId;
  final String merchId;
  final String validationCode;

  ValidatePoster({
    required this.imageFile,
    required this.artistId,
    required this.merchId,
    required this.validationCode,
  });

  @override
  List<Object> get props => [imageFile, artistId, merchId, validationCode];
}
