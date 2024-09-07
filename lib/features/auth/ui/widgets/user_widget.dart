import 'package:chat/core/resources/app_assets.dart';
import 'package:chat/core/resources/app_colors.dart';
import 'package:chat/features/auth/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class UserWidget extends StatelessWidget {
  final UserModel userModel;
  const UserWidget({required this.userModel,super.key});

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
        crossAxisAlignment: CrossAxisAlignment.center,
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
          Text(
            userModel.displayName ?? "-",
            style: TextStyle(
              color: AppColors.white,
              fontSize: 15.sp,
            ),
          ),
        ],
      ),
    );
  }
}
