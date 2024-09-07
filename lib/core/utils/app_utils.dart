import 'package:chat/core/resources/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class AppUtils {
  static void showSnackBar({
    required BuildContext context,
    required String message,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: AppColors.white,
            fontSize: 15.sp,
          ),
        ),
        backgroundColor: AppColors.red,
        duration: const Duration(milliseconds: 4000),
      ),
    );
  }

  static String getTimeFromTimestamp(DateTime timestamp) {
    DateTime dateTime = convertToCairoTime(timestamp);

    // Format the time in "HH:mm" format (24-hour time)
    String formattedTime =
        "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";

    return formattedTime;
  }

  static DateTime convertToCairoTime(DateTime timestamp) {
    const cairoTimeZoneOffset = Duration(hours: 3);
    final cairoTime = timestamp.toUtc().add(cairoTimeZoneOffset);
    final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return DateTime.parse(formatter.format(cairoTime));
  }

  static String timeDifferenceFromNow(DateTime timestamp) {
    final now = DateTime.now().toUtc();
    final duration = now.difference(convertToCairoTime(timestamp.toUtc()));
    if (duration.inDays > 0) {
      return '${duration.inDays} days ago';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} hours ago';
    } else {
      return '${duration.inMinutes} minutes ago';
    }
  }
}
