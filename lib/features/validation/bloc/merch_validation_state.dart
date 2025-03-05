import 'package:equatable/equatable.dart';

abstract class MerchValidationState extends Equatable {
  @override
  List<Object> get props => [];
}

class MerchValidationInitial extends MerchValidationState {}

class MerchValidationLoading extends MerchValidationState {}

class MerchValidationSuccess extends MerchValidationState {
  final String validationId;
  final String imageUrl;

  MerchValidationSuccess({required this.validationId, required this.imageUrl});

  @override
  List<Object> get props => [validationId, imageUrl];
}

class MerchValidationFailure extends MerchValidationState {
  final String error;

  MerchValidationFailure(this.error);

  @override
  List<Object> get props => [error];
}
