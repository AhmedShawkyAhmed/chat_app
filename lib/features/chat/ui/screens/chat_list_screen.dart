import 'package:chat/core/resources/app_colors.dart';
import 'package:chat/core/routing/arguments/chat_arguments.dart';
import 'package:chat/core/routing/routes.dart';
import 'package:chat/core/shared/globals.dart';
import 'package:chat/features/auth/cubit/auth_cubit.dart';
import 'package:chat/features/chat/cubit/chat_cubit.dart';
import 'package:chat/features/chat/ui/widgets/chat_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  ChatCubit chatCubit = ChatCubit();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => chatCubit..fetchChatRooms(),
      child: Scaffold(
        backgroundColor: AppColors.mainColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(6.h),
          child: AppBar(
            backgroundColor: AppColors.mainColor,
            leading: Padding(
              padding: EdgeInsetsDirectional.only(top: 0.8.h, start: 4.w),
              child: Text(
                "Hello, ${Globals.userData.displayName ?? ""}",
                style: const TextStyle(
                  color: AppColors.white,
                ),
              ),
            ),
            leadingWidth: 50.w,
            actions: [
              GestureDetector(
                onTap: () {
                  AuthCubit().signOut(
                    afterSuccess: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        Routes.login.path,
                        (route) => false,
                      );
                    },
                  );
                },
                child: Padding(
                  padding: EdgeInsetsDirectional.only(end: 4.w),
                  child: Icon(
                    Icons.logout,
                    color: AppColors.red,
                    size: 20.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: BlocBuilder<ChatCubit, ChatState>(
          builder: (context, state) {
            if (state is GetRoomsSuccess) {
              return ListView.builder(
                itemCount: state.rooms.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        Routes.chat.path,
                        arguments: ChatArguments(
                          roomId: state.rooms[index].id,
                          toUser: Globals.userData.uid == state.rooms[index].lastMessage!.from!.uid
                              ? state.rooms[index].lastMessage!.to!
                              : state.rooms[index].lastMessage!.from!,
                        ),
                      );
                    },
                    child: ChatListItem(
                      roomModel: state.rooms[index],
                    ),
                  );
                },
              );
            } else {
              return const SizedBox();
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.white,
          child: Icon(
            Icons.add,
            size: 20.sp,
          ),
          onPressed: () {
            Navigator.pushNamed(
              context,
              Routes.allUsers.path,
            );
          },
        ),
      ),
    );
  }
}
