import 'package:chat/core/resources/app_assets.dart';
import 'package:chat/core/resources/app_colors.dart';
import 'package:chat/core/routing/routes.dart';
import 'package:chat/features/splash/cubit/splash_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashCubit cubit = SplashCubit();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit..init(),
      child: BlocConsumer<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state is GetUserSuccess) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              Routes.chatList.path,
              (route) => false,
            );
          } else if (state is GetUserFailure) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              Routes.login.path,
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.mainColor,
            body: Center(
              child: Image.asset(
                AppAssets.flutterLogo,
                width: 70.w,
              ),
            ),
          );
        },
      ),
    );
  }
}
