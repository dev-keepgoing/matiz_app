// lib/features/authentication/data/models/user_data.dart
import 'package:matiz/features/earnings/data/models/next_payout.dart';

class UserData {
  final String createdAt;
  final String? displayName;
  final String email;
  final String type;
  final String uid;
  final String message;
  final NextPayout? nextPayout;

  UserData({
    required this.createdAt,
    this.displayName,
    required this.email,
    required this.type,
    required this.uid,
    required this.message,
    this.nextPayout,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      createdAt: json['createdAt'],
      displayName: json['displayName'],
      email: json['email'],
      type: json['type'],
      uid: json['uid'],
      message: json['message'],
      nextPayout: json['nextPayout'] != null
          ? NextPayout.fromJson(json['nextPayout'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt,
      'displayName': displayName,
      'email': email,
      'type': type,
      'uid': uid,
      'message': message,
      'nextPayout': nextPayout?.toJson(),
    };
  }
}
