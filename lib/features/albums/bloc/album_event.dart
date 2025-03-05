import 'package:equatable/equatable.dart';

abstract class AlbumEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// Event to fetch albums
class FetchAlbums extends AlbumEvent {
  final String type;
  final String? subtype;

  FetchAlbums({required this.type, this.subtype});

  @override
  List<Object> get props => [type, subtype ?? ''];
}
