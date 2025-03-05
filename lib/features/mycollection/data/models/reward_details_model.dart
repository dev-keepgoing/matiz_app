class RewardDetails {
  final String description;
  final String title;
  final int completionRate;

  RewardDetails({
    required this.title,
    required this.description,
    required this.completionRate,
  });

  factory RewardDetails.fromJson(Map<String, dynamic> json) {
    return RewardDetails(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      completionRate: json['completionRate'] ?? 0,
    );
  }
}
