class Album {
  final String id;
  final String title;
  final double price;
  final String image;
  final String subtitle;
  final String? shopifyUrl;
  final String? artistUid;
  final String? type;
  final String? subtype;
  final String? validation;

  Album(
      {required this.id,
      required this.title,
      required this.price,
      required this.image,
      required this.subtitle,
      this.shopifyUrl,
      this.artistUid,
      this.type,
      this.subtype,
      this.validation});

  factory Album.fromJson(Map<String, dynamic> json, id) {
    return Album(
        id: id,
        title: json['title'],
        subtitle: json['subtitle'],
        price: json['price'].toDouble(),
        image: json['image'],
        shopifyUrl: json['shopifyUrl'],
        artistUid: json['artistUid'],
        type: json['type'],
        subtype: json['subtype'],
        validation: json['validation']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'price': price,
      'image': image,
      if (shopifyUrl != null) 'shopifyUrl': artistUid,
      if (artistUid != null) 'artistUid': artistUid,
      if (type != null) 'type': type,
      if (subtype != null) 'subtype': subtype,
      if (validation != null) 'validation': validation,
    };
  }
}
