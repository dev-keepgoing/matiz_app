import 'package:equatable/equatable.dart';
import 'package:matiz/features/earnings/data/models/payout_history.dart';

abstract class PayoutState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PayoutInitial extends PayoutState {}

class PayoutLoading extends PayoutState {}

class PayoutLoaded extends PayoutState {
  final PayoutHistory payoutHistory;

  PayoutLoaded({required this.payoutHistory});

  @override
  List<Object?> get props => [payoutHistory];
}

class PayoutError extends PayoutState {
  final String error;

  PayoutError({required this.error});

  @override
  List<Object?> get props => [error];
}
