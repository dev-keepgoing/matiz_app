import 'package:matiz/features/mycollection/data/models/reward_details_model.dart';

class Achievement {
  final String id;
  final String title;
  final String description;
  final String criteria;
  final bool completed;
  final int createdAt;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.criteria,
    required this.completed,
    required this.createdAt,
  });

  factory Achievement.fromJson(Map<String, dynamic> json, String id) {
    return Achievement(
      id: id,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      criteria: json['criteria'] ?? '',
      completed: json['completed'] ?? false,
      createdAt: json['createdAt'] ?? 0,
    );
  }
}

class AchievementResponse {
  final List<Achievement> achievements;
  final int completedCount;
  final int totalAchievements;
  final String message;
  final RewardDetails? reward;

  AchievementResponse({
    required this.achievements,
    required this.completedCount,
    required this.totalAchievements,
    required this.message,
    this.reward,
  });

  factory AchievementResponse.fromJson(Map<String, dynamic> json) {
    return AchievementResponse(
      achievements: (json['achievements'] as List)
          .map((achievement) =>
              Achievement.fromJson(achievement, achievement['achievementId']))
          .toList(),
      completedCount: json['completedCount'] ?? 0,
      totalAchievements: json['totalAchievements'] ?? 0,
      message: json['message'] ?? '',
      reward: json.containsKey('reward') && json['reward'] != null
          ? RewardDetails.fromJson(json['reward'])
          : null, // Properly parse reward field
    );
  }
}
