import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matiz/features/mycollection/bloc/achievement_event.dart';
import 'package:matiz/features/mycollection/bloc/achievement_state.dart';
import 'package:matiz/features/mycollection/data/repositories/achievement_repository.dart';

class AchievementBloc extends Bloc<AchievementEvent, AchievementState> {
  final AchievementRepository achievementRepository;

  AchievementBloc({required this.achievementRepository})
      : super(AchievementInitial()) {
    on<FetchAchievements>((event, emit) async {
      emit(AchievementLoading());
      try {
        final response = await achievementRepository.fetchAchievements(
            event.userId, event.userType, event.season);
        emit(AchievementLoaded(achievementData: response.data));
      } catch (e) {
        emit(AchievementError(message: e.toString()));
      }
    });
  }
}
