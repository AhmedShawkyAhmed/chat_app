import 'package:chat/features/auth/data/models/user_model.dart';
import 'package:chat/features/chat/data/models/chat_model.dart';

class RoomModel {
  final String? id;
  final UserModel? toUser;
  final MessageModel? lastMessage;

  RoomModel({
    this.id,
    this.toUser,
    this.lastMessage,
  });

  Map<String, dynamic> toMap() {
    return {
      'toUser': toUser?.toMap(),
      'lastMessage': lastMessage?.toMap(),
    };
  }

  factory RoomModel.fromMap(String id, Map<String, dynamic> map) {
    return RoomModel(
      id: id,
      toUser: map['toUser'] == null
          ? null
          : UserModel.fromMap(Map<String, dynamic>.from(map['toUser'])),
      lastMessage: map['lastMessage'] == null
          ? null
          : MessageModel.fromMap(Map<String, dynamic>.from(map['lastMessage'])),
    );
  }
}
