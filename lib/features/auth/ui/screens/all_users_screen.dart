import 'package:chat/core/resources/app_colors.dart';
import 'package:chat/core/routing/arguments/chat_arguments.dart';
import 'package:chat/core/routing/routes.dart';
import 'package:chat/features/auth/cubit/auth_cubit.dart';
import 'package:chat/features/auth/ui/widgets/user_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class AllUsersScreen extends StatefulWidget {
  const AllUsersScreen({super.key});

  @override
  State<AllUsersScreen> createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
  AuthCubit authCubit = AuthCubit();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => authCubit..getAllUsers(),
      child: Scaffold(
        backgroundColor: AppColors.mainColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(4.h),
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
          ),
        ),
        body: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is GetAllUserSuccess) {
              return state.users.isEmpty
                  ? const Center(
                      child: Text(
                        "No Users Found",
                        style: TextStyle(
                          color: AppColors.white,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: state.users.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                              context,
                              Routes.chat.path,
                              arguments: ChatArguments(
                                toUser: state.users[index],
                              ),
                            );
                          },
                          child: UserWidget(
                            userModel: state.users[index],
                          ),
                        );
                      },
                    );
            } else {
              return const Center(
                child: Text(
                  "No Users Found",
                  style: TextStyle(
                    color: AppColors.white,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
