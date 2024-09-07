import 'package:chat/features/auth/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String? message;
  UserModel? from;
  UserModel? to;
  String? timestamp;

  MessageModel({
    this.message,
    this.from,
    this.to,
    this.timestamp,
  });

  factory MessageModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return MessageModel(
      message: data['message'] ?? '',
      from: data['from'] ?? '',
      to: data['to'] ?? '',
      timestamp: data['timestamp'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'from': from?.toMap(),
      'to': to?.toMap(),
      'timestamp': timestamp,
    };
  }

  factory MessageModel.fromMap(Map<dynamic, dynamic> map) {
    return MessageModel(
      message: map['message'] as String,
      from: map['from'] == null
          ? null
          : UserModel.fromMap(Map<dynamic, dynamic>.from(map['from'])),
      to: map['to'] == null
          ? null
          : UserModel.fromMap(Map<dynamic, dynamic>.from(map['to'])),
      timestamp: map['timestamp'] as String,
    );
  }
}
