import 'package:chat/core/services/firebase_database.dart';
import 'package:chat/core/shared/globals.dart';
import 'package:chat/core/utils/enums.dart';
import 'package:chat/core/utils/shared_methods.dart';
import 'package:chat/features/auth/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthRepo {
  static const _userCollection = "users";
  static final _firestore = FirebaseDatabaseService.firestore;

  static Future<List<UserModel>> getAllUsers() async {
    try {
      String currentUserId = Globals.userData.uid!;

      QuerySnapshot querySnapshot = await _firestore
          .collection(_userCollection)
          .where(FieldPath.documentId, isNotEqualTo: currentUserId)
          .get();

      List<UserModel> users = querySnapshot.docs.map((doc) {
        return UserModel.fromFirestore(doc);
      }).toList();

      return users;
    } catch (e) {
      printError('Error fetching users: $e');
      return [];
    }
  }

  static Future<UserModel?> getUser({required String userId}) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection(_userCollection)
        .where('uid', isEqualTo: userId)
        .limit(1)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot doc = querySnapshot.docs.first;
      UserModel userModel = UserModel.fromFirestore(doc);
      return userModel;
    } else {
      printError('User with userId $userId not found');
      return null;
    }
  }

  static Future<void> addUser({required UserModel userModel}) async {
    _firestore.collection(_userCollection).add(userModel.toFirestore()).then(
          (documentSnapshot) =>
              printSuccess("Added Data with ID: ${documentSnapshot.id}"),
          onError: (e) => printError("Error Deleting Account $e"),
        );
  }

  static void updateUserPresence(String userId,String text) {
    DatabaseReference userStatusRef = FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(userId)
        .child('status');

    DatabaseReference connectedRef =
        FirebaseDatabase.instance.ref(".info/connected");
    connectedRef.onValue.listen((event) {
      final bool isConnected = event.snapshot.value as bool? ?? false;

      if(text != ""){
        userStatusRef.set(UserStatues.typing.name);
        userStatusRef.onDisconnect().set(UserStatues.offline.name);
      } else if (isConnected) {
        userStatusRef.set(UserStatues.online.name);
        userStatusRef.onDisconnect().set(UserStatues.offline.name);
      } else {
        userStatusRef.set(UserStatues.offline.name);
      }
    });
  }
}
