import 'package:bloc/bloc.dart';
import 'package:chat/core/caching/database_helper.dart';
import 'package:chat/core/caching/database_keys.dart';
import 'package:chat/core/shared/globals.dart';
import 'package:chat/core/utils/shared_methods.dart';
import 'package:chat/features/auth/data/models/user_model.dart';
import 'package:chat/features/auth/data/repo/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      printSuccess(userCredential);
      Globals.userData =
          (await AuthRepo.getUser(userId: userCredential.user!.uid))!;

      AuthRepo.updateUserPresence(Globals.userData.uid!,"");
      await storeUserInLocalStorage(
        userCredential.user!.uid,
      );
      emit(LoginSuccess());
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      String? errorMessage;
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        errorMessage = 'Invalid email or password.';
        printError('Invalid email or password.');
      } else {
        errorMessage = 'Credential Not Found';
        printError('An error occurred: ${e.message}');
      }
      emit(LoginFailure(message: errorMessage));
    } catch (e) {
      printError('Error: $e');
      emit(LoginFailure());
    }
    return null;
  }

  Future<User?> registerWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(RegisterLoading());
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await storeUserInLocalStorage(
        userCredential.user!.uid,
      );
      AuthRepo.updateUserPresence(userCredential.user!.uid,"");
      await AuthRepo.addUser(
        userModel: UserModel(
          uid: userCredential.user!.uid,
          displayName: name,
          email: email,
        ),
      );
      emit(RegisterSuccess());
      return userCredential.user;
    } catch (e) {
      emit(RegisterFailure());
      printError('Error: $e');
      return null;
    }
  }

  Future getAllUsers()async{
    emit(GetAllUserLoading());
    List<UserModel> users = await AuthRepo.getAllUsers();
    emit(GetAllUserSuccess(users: users));
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<void> signOut({
    required VoidCallback afterSuccess,
  }) async {
    Globals.userData = UserModel();
    await DatabaseHelper.clearDatabase();
    await _auth.signOut();
    afterSuccess();
  }

  static Future<void> storeUserInLocalStorage(String uid) async {
    DatabaseHelper.putItem(
      boxName: DatabaseBox.appBox,
      key: DatabaseKey.uid,
      item: uid,
    );
  }
}
