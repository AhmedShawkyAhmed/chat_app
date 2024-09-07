import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? displayName;
  String? email;

  UserModel({
    this.uid,
    this.displayName,
    this.email,
  });

  factory UserModel.fromMap(Map<dynamic, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      displayName: map['displayName'] as String,
      email: map['email'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
    };
  }

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      displayName: data['displayName'] ?? '',
      email: data['email'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (uid != null) "uid": uid,
      if (displayName != null) "displayName": displayName,
      if (email != null) "email": email,
    };
  }
}
