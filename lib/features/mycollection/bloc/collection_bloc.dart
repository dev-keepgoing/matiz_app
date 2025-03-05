import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matiz/features/mycollection/data/repositories/collection_repository.dart';
import 'collection_event.dart';
import 'collection_state.dart';

class CollectionBloc extends Bloc<CollectionEvent, CollectionState> {
  final CollectionRepository collectionRepository;

  CollectionBloc({required this.collectionRepository})
      : super(CollectionInitial()) {
    on<FetchCollection>(_onFetchCollection);
  }

  Future<void> _onFetchCollection(
      FetchCollection event, Emitter<CollectionState> emit) async {
    emit(CollectionLoading());

    try {
      final response = await collectionRepository.fetchUserCollection();
      emit(CollectionLoaded(collection: response.data));
    } catch (e) {
      emit(CollectionError(error: e.toString()));
    }
  }
}
