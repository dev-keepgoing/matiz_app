import 'package:equatable/equatable.dart';
import 'package:matiz/features/earnings/data/models/fact.dart';

abstract class FactState extends Equatable {
  @override
  List<Object> get props => [];
}

class FactInitial extends FactState {}

class FactLoading extends FactState {}

class FactLoaded extends FactState {
  final List<Fact> facts;

  FactLoaded({required this.facts});

  @override
  List<Object> get props => [facts];
}

class FactError extends FactState {
  final String message;

  FactError({required this.message});

  @override
  List<Object> get props => [message];
}
