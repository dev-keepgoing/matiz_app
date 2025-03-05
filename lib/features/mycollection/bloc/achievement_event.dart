import 'package:equatable/equatable.dart';

abstract class AchievementEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchAchievements extends AchievementEvent {
  final String userId;
  final String userType;
  final int season;

  FetchAchievements({
    required this.userId,
    required this.userType,
    required this.season,
  });

  @override
  List<Object> get props => [userId, userType, season];
}
