import 'package:chat/core/resources/app_colors.dart';
import 'package:chat/core/shared/globals.dart';
import 'package:chat/core/shared/widgets/default_text_field.dart';
import 'package:chat/features/auth/data/models/user_model.dart';
import 'package:chat/features/auth/data/repo/auth_repo.dart';
import 'package:chat/features/chat/cubit/chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ChatTextField extends StatefulWidget {
  final ChatCubit chatCubit;
  final String roomId;
  final UserModel toUser;

  const ChatTextField({
    required this.chatCubit,
    required this.roomId,
    required this.toUser,
    super.key,
  });

  @override
  State<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  TextEditingController messageController = TextEditingController();
  bool canSend = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8.h,
      decoration: const BoxDecoration(
        color: AppColors.mainColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Transform.rotate(
            angle: 0.6,
            child: Icon(
              Icons.attach_file_outlined,
              color: AppColors.grey,
              size: 20.sp,
            ),
          ),
          DefaultTextField(
            width: 80.w,
            height: 4.h,
            radius: 100.sp,
            fillColor: AppColors.black,
            borderColor: AppColors.black,
            hintColor: AppColors.grey,
            textColor: AppColors.white,
            marginHorizontal: 0,
            controller: messageController,
            hintText: "Message",
            onChange: (value) {
              AuthRepo.updateUserPresence(Globals.userData.uid!,value);
              if (value.isEmpty) {
                setState(() {
                  canSend = false;
                });
              } else {
                setState(() {
                  canSend = true;
                });
              }
            },
          ),
          GestureDetector(
            onTap: () {
              if (canSend) {
                widget.chatCubit.sendMessage(
                  widget.roomId,
                  messageController.text,
                  widget.toUser,
                );
                messageController.clear();
                AuthRepo.updateUserPresence(Globals.userData.uid!,"");
              }
            },
            child: Icon(
              canSend ? Icons.send : Icons.mic_none_outlined,
              color: AppColors.grey,
              size: 20.sp,
            ),
          ),
        ],
      ),
    );
  }
}
