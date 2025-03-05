class Fact {
  final String id;
  final String title;
  final String description;
  final int createdAt;
  final bool live;

  Fact({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.live,
  });

  factory Fact.fromJson(String id, Map<String, dynamic> json) {
    return Fact(
      id: id,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      createdAt: json['createdAt'] ?? 0,
      live: json['live'] ?? false,
    );
  }
}
