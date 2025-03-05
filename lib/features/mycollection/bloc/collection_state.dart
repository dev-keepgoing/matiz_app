import 'package:equatable/equatable.dart';
import 'package:matiz/features/mycollection/data/models/collection_model.dart';

abstract class CollectionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CollectionInitial extends CollectionState {}

class CollectionLoading extends CollectionState {}

class CollectionLoaded extends CollectionState {
  final List<CollectionItem> collection;

  CollectionLoaded({required this.collection});

  @override
  List<Object?> get props => [collection];
}

class CollectionError extends CollectionState {
  final String error;

  CollectionError({required this.error});

  @override
  List<Object?> get props => [error];
}
