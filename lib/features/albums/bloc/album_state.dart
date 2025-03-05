import 'package:equatable/equatable.dart';
import 'package:matiz/features/albums/data/models/album_model.dart';

abstract class AlbumState extends Equatable {
  @override
  List<Object> get props => [];
}

class AlbumInitial extends AlbumState {}

class AlbumLoading extends AlbumState {}

class AlbumLoaded extends AlbumState {
  final List<Album> albums;

  AlbumLoaded({required this.albums});

  @override
  List<Object> get props => [albums];
}

class AlbumNotFound extends AlbumState {}

class AlbumError extends AlbumState {
  final String error;

  AlbumError({required this.error});

  @override
  List<Object> get props => [error];
}
