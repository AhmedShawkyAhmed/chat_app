import 'package:chat/core/resources/app_assets.dart';
import 'package:chat/core/resources/app_colors.dart';
import 'package:chat/core/routing/routes.dart';
import 'package:chat/core/shared/views/indicator_view.dart';
import 'package:chat/core/shared/widgets/default_app_button.dart';
import 'package:chat/core/shared/widgets/default_text_field.dart';
import 'package:chat/core/utils/app_utils.dart';
import 'package:chat/features/auth/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthCubit authCubit = AuthCubit();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => authCubit,
      child: Scaffold(
        backgroundColor: AppColors.mainColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 15.h),
              Image.asset(
                AppAssets.flutterLogo,
                width: 50.w,
              ),
              SizedBox(height: 5.h),
              DefaultTextField(
                controller: emailController,
                hintText: "Enter Email",
                keyboardType: TextInputType.emailAddress,
              ),
              DefaultTextField(
                controller: passwordController,
                hintText: "Enter Password",
                keyboardType: TextInputType.text,
                password: true,
              ),
              BlocListener<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is LoginLoading) {
                    IndicatorView.showIndicator(context);
                  } else if (state is LoginSuccess) {
                    Navigator.pop(context);
                    Navigator.of(context).pushNamed(
                      Routes.chatList.path,
                    );
                  } else if (state is LoginFailure) {
                    Navigator.pop(context);
                    AppUtils.showSnackBar(
                      context: context,
                      message: state.message ?? "",
                    );
                    Navigator.of(context).pushNamed(
                      Routes.register.path,
                    );
                  }
                },
                child: DefaultAppButton(
                  title: "Login",
                  onTap: () {
                    if (emailController.text.isEmpty) {
                      AppUtils.showSnackBar(
                        context: context,
                        message: "Please Enter Email",
                      );
                      return;
                    } else if (passwordController.text.isEmpty) {
                      AppUtils.showSnackBar(
                        context: context,
                        message: "Please Enter Password",
                      );
                      return;
                    }
                    authCubit.signInWithEmail(
                      email: emailController.text,
                      password: passwordController.text,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
