import 'package:equatable/equatable.dart';

abstract class FactEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchFacts extends FactEvent {}
