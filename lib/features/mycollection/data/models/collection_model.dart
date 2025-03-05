class CollectionItem {
  final String merchId;
  final String artistUid;
  final String image;
  final int itemNumber;
  final String purchaseDate;
  final String subtype;
  final String title;
  final String subtitle;
  final String type;

  CollectionItem({
    required this.merchId,
    required this.artistUid,
    required this.image,
    required this.itemNumber,
    required this.purchaseDate,
    required this.subtype,
    required this.title,
    required this.subtitle,
    required this.type,
  });

  // Factory method to create an instance from JSON
  factory CollectionItem.fromJson(String merchId, Map<String, dynamic> json) {
    return CollectionItem(
      merchId: merchId,
      artistUid: json['artistUid'] ?? '',
      image: json['image'] ?? '',
      itemNumber: json['itemNumber'] ?? 0,
      purchaseDate: json['purchaseDate'] ?? '',
      subtype: json['subtype'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      type: json['type'] ?? '',
    );
  }

  // Method to convert the object to JSON
  Map<String, dynamic> toJson() {
    return {
      'merchId': merchId,
      'artistUid': artistUid,
      'image': image,
      'itemNumber': itemNumber,
      'purchaseDate': purchaseDate,
      'subtype': subtype,
      'title': title,
      'subtitle': subtitle,
      'type': type,
    };
  }
}
