import 'package:chat/core/resources/app_assets.dart';
import 'package:chat/core/resources/app_colors.dart';
import 'package:chat/core/shared/globals.dart';
import 'package:chat/core/utils/app_utils.dart';
import 'package:chat/features/chat/data/models/room_model.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ChatListItem extends StatelessWidget {
  final RoomModel roomModel;

  const ChatListItem({required this.roomModel, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10.h,
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 3.w,
        vertical: 1.h,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.grey,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            margin: EdgeInsetsDirectional.only(end: 1.5.w),
            decoration: BoxDecoration(
              color: AppColors.lightGrey,
              borderRadius: BorderRadius.circular(
                100.sp,
              ),
            ),
            child: Image.asset(
              AppAssets.avatar,
              width: 10.w,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Globals.userData.uid == roomModel.lastMessage?.from?.uid
                    ? roomModel.lastMessage?.to?.displayName ?? ""
                    : roomModel.lastMessage?.from?.displayName ?? "",
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 15.sp,
                ),
              ),
              SizedBox(
                width: 50.w,
                child: Text(
                  roomModel.lastMessage?.message ?? "",
                  maxLines: 1,
                  style: TextStyle(
                    color: AppColors.midGrey,
                    fontSize: 13.sp,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            roomModel.lastMessage?.timestamp == null
                ? ""
                : AppUtils.timeDifferenceFromNow(
                    DateTime.parse(roomModel.lastMessage?.timestamp ?? "")),
            style: TextStyle(
              color: AppColors.midGrey,
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }
}
