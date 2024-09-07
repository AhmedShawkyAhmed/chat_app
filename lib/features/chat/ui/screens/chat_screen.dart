import 'package:chat/core/resources/app_assets.dart';
import 'package:chat/core/resources/app_colors.dart';
import 'package:chat/core/routing/arguments/chat_arguments.dart';
import 'package:chat/core/shared/globals.dart';
import 'package:chat/features/chat/cubit/chat_cubit.dart';
import 'package:chat/features/chat/ui/widgets/chat_text_field.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class ChatScreen extends StatefulWidget {
  final ChatArguments arguments;

  const ChatScreen({required this.arguments, super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ChatCubit chatCubit = ChatCubit();

  @override
  void dispose() {
    chatCubit.cancelUserStatusListener();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => chatCubit
        ..initChat(widget.arguments)
        ..getUserStatus(widget.arguments.toUser.uid!),
      child: Scaffold(
        backgroundColor: AppColors.black,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(6.h),
          child: AppBar(
            backgroundColor: AppColors.mainColor,
            leading: Padding(
              padding: EdgeInsetsDirectional.only(top: 0.8.h),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.white,
                ),
              ),
            ),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.arguments.toUser.displayName ?? "",
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 15.sp,
                  ),
                ),
                BlocBuilder<ChatCubit, ChatState>(
                  builder: (context, state) {
                    return Text(
                      chatCubit.userStatus,
                      style: TextStyle(
                        color: AppColors.midGrey,
                        fontSize: 12.sp,
                      ),
                    );
                  },
                ),
              ],
            ),
            centerTitle: true,
            actions: [
              Container(
                padding: const EdgeInsets.all(4),
                margin: EdgeInsetsDirectional.only(end: 1.5.w),
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(
                    100.sp,
                  ),
                ),
                child: Image.asset(
                  AppAssets.avatar,
                  width: 7.w,
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: chatCubit.messagesList.length,
                    reverse: true,
                    itemBuilder: (context, index) {
                      return BubbleSpecialThree(
                        text: chatCubit.messagesList[index].message ?? "",
                        textStyle: TextStyle(
                          color: AppColors.white,
                          fontSize: 16.sp,
                        ),
                        delivered: Globals.userData.uid ==
                            chatCubit.messagesList[index].from!.uid,
                        color: Globals.userData.uid ==
                                chatCubit.messagesList[index].from!.uid
                            ? AppColors.purple
                            : AppColors.darkPurple,
                        isSender: Globals.userData.uid ==
                            chatCubit.messagesList[index].from!.uid,
                      );
                    },
                  ),
                );
              },
            ),
            ChatTextField(
              chatCubit: chatCubit,
              toUser: widget.arguments.toUser,
              roomId: widget.arguments.roomId ?? chatCubit.chatRoomId,
            ),
          ],
        ),
      ),
    );
  }
}
