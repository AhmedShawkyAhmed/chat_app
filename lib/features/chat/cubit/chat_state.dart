part of 'chat_cubit.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

final class GetMessageLoading extends ChatState {}

final class GetMessageSuccess extends ChatState {
  // final List<MessageModel> messages;
  final String? roomId;

  GetMessageSuccess({
    // required this.messages,
    this.roomId,
  });
}

final class GetMessageFailure extends ChatState {}

final class GetRoomsLoading extends ChatState {}

final class GetRoomsSuccess extends ChatState {
  final List<RoomModel> rooms;

  GetRoomsSuccess({required this.rooms});
}

final class GetRoomsFailure extends ChatState {}

final class SendMessageLoading extends ChatState {}

final class SendMessageSuccess extends ChatState {}

final class SendMessageFailure extends ChatState {}

final class GetStatusInitial  extends ChatState {}
final class GetStatusLoading extends ChatState {}

final class GetStatusSuccess extends ChatState {
}
