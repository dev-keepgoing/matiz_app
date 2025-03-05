import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matiz/features/earnings/bloc/fact_event.dart';
import 'package:matiz/features/earnings/bloc/fact_state.dart';
import 'package:matiz/features/earnings/data/repositories/fact_respository.dart';

class FactBloc extends Bloc<FactEvent, FactState> {
  final FactRepository factRepository;

  FactBloc({required this.factRepository}) : super(FactInitial()) {
    on<FetchFacts>((event, emit) async {
      emit(FactLoading());
      try {
        final facts = await factRepository.fetchFacts();
        emit(FactLoaded(facts: facts.data));
      } catch (e) {
        emit(FactError(message: e.toString()));
      }
    });
  }
}
