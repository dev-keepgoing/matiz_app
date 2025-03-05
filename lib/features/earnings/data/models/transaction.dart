class Transaction {
  final String id;
  final String artistId;
  final String collection;
  final DateTime createdAt;
  final String date;
  final String image;
  final String merchId;
  final String note;
  final String orderId;
  final int quantity;
  final String subtype;
  final String type;
  final List<int> number; // ✅ Added new field

  Transaction({
    required this.id,
    required this.artistId,
    required this.collection,
    required this.createdAt,
    required this.date,
    required this.image,
    required this.merchId,
    required this.note,
    required this.orderId,
    required this.quantity,
    required this.subtype,
    required this.type,
    required this.number, // ✅ Initialize new field
  });

  factory Transaction.fromJson(String id, Map<String, dynamic> json) {
    return Transaction(
      id: id,
      artistId: json['artistId'] ?? '',
      collection: json['collection'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      date: json['date'] ?? '',
      image: json['image'] ?? '',
      merchId: json['merchId'] ?? '',
      note: json['note'] ?? '',
      orderId: json['orderId'] ?? '',
      quantity: json['quantity'] ?? 0,
      subtype: json['subtype'] ?? '',
      type: json['type'] ?? '',
      number:
          (json['number'] as List<dynamic>?)?.map((e) => e as int).toList() ??
              [], // ✅ Handles null & ensures conversion
    );
  }
}
