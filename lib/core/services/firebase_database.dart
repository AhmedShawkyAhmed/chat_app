import 'package:chat/core/resources/firebase_options.dart';
import 'package:chat/core/utils/shared_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseDatabaseService {
  static final FirebaseDatabaseService _firebaseDatabase =
      FirebaseDatabaseService._internal();

  factory FirebaseDatabaseService() {
    return _firebaseDatabase;
  }

  FirebaseDatabaseService._internal();

  static late FirebaseFirestore firestore;

  static Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    firestore = FirebaseFirestore.instance;
    printSuccess("Firebase Database Created");
  }
}
