import 'package:chat/core/resources/app_colors.dart';
import 'package:chat/core/shared/globals.dart';
import 'package:chat/core/utils/app_utils.dart';
import 'package:chat/features/chat/data/models/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ChatBubbleWidget extends StatelessWidget {
  final MessageModel message;

  const ChatBubbleWidget({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    bool isSentByMe = Globals.userData.uid == message.from!.uid;
    return Align(
      alignment: !isSentByMe
          ? Alignment.centerLeft
          : Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: EdgeInsets.only(
          top: 0.2.h,
          bottom: 0.2.h,
          right: isSentByMe ? 3.w : 20.w,
          left: !isSentByMe ? 3.w : 20.w,
        ),
        decoration: BoxDecoration(
          color: !isSentByMe
              ? AppColors.darkPurple
              : AppColors.purple,
          borderRadius: BorderRadius.circular(16.sp),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message.message ?? "",
              style: TextStyle(
                color: AppColors.white,
                fontSize: 16.sp,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppUtils.getTimeFromTimestamp(
                      DateTime.parse(message.timestamp ?? "")),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                  ),
                ),
                if (isSentByMe) ...[
                  const SizedBox(width: 5),
                  Icon(
                    Icons.done_all,
                    color: AppColors.white,
                    size: 12.sp,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
