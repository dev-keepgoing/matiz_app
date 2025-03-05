import 'package:equatable/equatable.dart';
import 'package:matiz/features/mycollection/data/models/achievement_model.dart';

abstract class AchievementState extends Equatable {
  @override
  List<Object> get props => [];
}

class AchievementInitial extends AchievementState {}

class AchievementLoading extends AchievementState {}

class AchievementLoaded extends AchievementState {
  final AchievementResponse achievementData;

  AchievementLoaded({required this.achievementData});

  @override
  List<Object> get props => [achievementData];
}

class AchievementError extends AchievementState {
  final String message;

  AchievementError({required this.message});

  @override
  List<Object> get props => [message];
}
