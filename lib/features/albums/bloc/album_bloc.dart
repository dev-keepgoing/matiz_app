import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matiz/core/exceptions/not_found.dart';
import 'package:matiz/features/albums/data/repositories/album_repository.dart';
import 'album_event.dart';
import 'album_state.dart';

class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  final AlbumRepository albumRepository;

  AlbumBloc({required this.albumRepository}) : super(AlbumInitial()) {
    on<FetchAlbums>(_onFetchAlbums);
  }

  Future<void> _onFetchAlbums(
      FetchAlbums event, Emitter<AlbumState> emit) async {
    emit(AlbumLoading());

    try {
      final response =
          await albumRepository.fetchAlbums(event.type, event.subtype);

      if (response.data.isEmpty) {
        emit(
            AlbumNotFound()); // If no albums are found, emit AlbumNotFound state
      } else {
        emit(AlbumLoaded(albums: response.data));
      }
    } on NotFoundException {
      print("notf ound exceptions");
      emit(AlbumNotFound()); // Emit Not Found state for 404 errors
    } catch (e) {
      emit(AlbumError(error: e.toString())); // Emit error for other exceptions
    }
  }
}
