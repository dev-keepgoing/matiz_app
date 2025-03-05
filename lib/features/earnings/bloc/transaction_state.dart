import 'package:equatable/equatable.dart';
import 'package:matiz/features/earnings/data/models/transaction.dart';

abstract class TransactionState extends Equatable {
  @override
  List<Object> get props => [];
}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionLoaded extends TransactionState {
  final List<Transaction> transactions;

  TransactionLoaded({required this.transactions});

  @override
  List<Object> get props => [transactions];
}

class TransactionError extends TransactionState {
  final String error;

  TransactionError({required this.error});

  @override
  List<Object> get props => [error];
}
