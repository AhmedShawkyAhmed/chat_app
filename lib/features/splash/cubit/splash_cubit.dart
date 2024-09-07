import 'package:bloc/bloc.dart';
import 'package:chat/core/caching/database_helper.dart';
import 'package:chat/core/caching/database_keys.dart';
import 'package:chat/core/shared/globals.dart';
import 'package:chat/features/auth/data/repo/auth_repo.dart';
import 'package:flutter/material.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  Future<void> init() async {
    emit(GetUserLoading());
    Globals.userData.uid = DatabaseHelper.getItem(
      boxName: DatabaseBox.appBox,
      key: DatabaseKey.uid,
    );
    await Future.delayed(const Duration(seconds: 2), () async {
      if (Globals.userData.uid == null) {
        emit(GetUserFailure());
      } else {
        Globals.userData =
            (await AuthRepo.getUser(userId: Globals.userData.uid!))!;
        AuthRepo.updateUserPresence(Globals.userData.uid!,"");
        emit(GetUserSuccess());
      }
    });
  }
}
