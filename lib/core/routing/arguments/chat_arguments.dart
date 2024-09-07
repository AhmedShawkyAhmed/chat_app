import 'package:chat/features/auth/data/models/user_model.dart';

class ChatArguments {
  final UserModel toUser;
  final String? roomId;

  ChatArguments({
    required this.toUser,
    this.roomId,
  });
}
