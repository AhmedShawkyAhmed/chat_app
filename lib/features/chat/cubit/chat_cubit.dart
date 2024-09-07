import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat/core/routing/arguments/chat_arguments.dart';
import 'package:chat/core/shared/globals.dart';
import 'package:chat/core/utils/enums.dart';
import 'package:chat/core/utils/shared_methods.dart';
import 'package:chat/features/auth/data/models/user_model.dart';
import 'package:chat/features/chat/data/models/chat_model.dart';
import 'package:chat/features/chat/data/models/room_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  final DatabaseReference _chatRoomsDatabase =
      FirebaseDatabase.instance.ref().child('chatRooms');

  List<MessageModel> messagesList = [];
  String chatRoomId = "";
  String userStatus = "";

  Future<List<MessageModel>> getMessagesInRoom({
    required String roomId,
  }) async {
    emit(GetMessageLoading());
    try {
      List<MessageModel> messages = [];
      DatabaseReference messagesRef = FirebaseDatabase.instance
          .ref()
          .child('chatRooms')
          .child(roomId)
          .child('messages');

      messagesRef.onValue.listen((DatabaseEvent event) {
        DataSnapshot snapshot = event.snapshot;

        if (snapshot.exists) {
          Map<dynamic, dynamic> messagesMap = snapshot.value as Map;

          messages = messagesMap.entries.map((entry) {
            return MessageModel.fromMap(entry.value);
          }).toList();
          messages.sort((a, b) => a.timestamp!.compareTo(b.timestamp!));

          printLog(messages);
          chatRoomId = roomId;
          messagesList = messages.reversed.toList();
        } else {
          printError('No messages found in room $roomId');
        }
      });
      return [];
    } catch (e) {
      printError('Error listening to messages: $e');
      return [];
    }
  }

  void fetchRoomMessages(String roomId) async {
    emit(GetMessageLoading());
    List<MessageModel> messages = await getMessagesInRoom(roomId: roomId);
    chatRoomId = roomId;
    messagesList = messages;
    emit(GetMessageSuccess());
    if (messages.isNotEmpty) {
      printResponse('Fetched ${messages.length} messages from room $roomId.');
    } else {
      printResponse('No messages found in room $roomId');
    }
  }

  initChat(ChatArguments arguments) {
    printResponse(arguments.roomId);
    if (arguments.roomId != null) {
      fetchRoomMessages(arguments.roomId!);
    } else if (arguments.toUser.displayName != null) {
      createNewChatRoom(arguments.toUser);
    }
  }

  Timer? _debounceTimer;

  void fetchChatRooms() {
    emit(GetRoomsLoading());
    _chatRoomsDatabase.onValue.listen((event) {
      if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

      _debounceTimer = Timer(const Duration(milliseconds: 100), () {
        if (event.snapshot.value != null) {
          final roomsData =
              Map<String, dynamic>.from(event.snapshot.value as Map);
          final List<RoomModel> chatRooms = roomsData.entries.map((entry) {
            return RoomModel.fromMap(
              entry.key,
              Map<String, dynamic>.from(entry.value),
            );
          }).toList();

          printSuccess("Data received");
          emit(GetRoomsSuccess(rooms: chatRooms));
        }
      });
    });
  }

  Future<void> createNewChatRoom(UserModel toUser) async {
    emit(GetMessageLoading());
    final newChatRoomRef = _chatRoomsDatabase.push();
    final roomId = newChatRoomRef.key;

    final newChatRoom = RoomModel(
      id: roomId!,
      toUser: toUser,
    );
    await newChatRoomRef.set(newChatRoom.toMap());
    chatRoomId = roomId;
    emit(GetMessageSuccess(roomId: roomId));
  }

  void sendMessage(String chatRoomId, String message, UserModel toUser) {
    emit(SendMessageLoading());
    final newMessage = MessageModel(
      message: message,
      from: UserModel(
        uid: Globals.userData.uid,
        email: Globals.userData.email,
        displayName: Globals.userData.displayName,
      ),
      to: toUser,
      timestamp: DateTime.now().toString(),
    );

    final chatRoomDatabase =
        FirebaseDatabase.instance.ref().child('chatRooms').child(chatRoomId);

    chatRoomDatabase.child('messages').push().set(newMessage.toMap());
    chatRoomDatabase.child('lastMessage').set(newMessage.toMap());
    emit(SendMessageSuccess());
  }

  StreamSubscription? _statusSubscription;

  getUserStatus(String userId) {
    emit(GetStatusInitial());
    DatabaseReference userStatusRef = FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(userId)
        .child('status');

    _statusSubscription = userStatusRef.onValue.listen((event) {
      emit(GetStatusLoading());
      String? status = event.snapshot.value as String?;
      if (status == UserStatues.typing.name) {
        userStatus = UserStatues.typing.name;
        printError('User is typing');
      } else if (status == UserStatues.online.name) {
        userStatus = UserStatues.online.name;
        printError('User is online');
      } else {
        userStatus = UserStatues.offline.name;
        printError('User is offline');
      }
      emit(GetStatusSuccess());
    });
  }

  void cancelUserStatusListener() {
    if (_statusSubscription != null) {
      _statusSubscription!.cancel();
      _statusSubscription = null;
      printSuccess('Listener canceled');
    }
  }
}
