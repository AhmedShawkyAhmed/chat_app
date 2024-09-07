import 'package:chat/core/application/app.dart';
import 'package:chat/core/caching/database_helper.dart';
import 'package:chat/core/di/service_locator.dart';
import 'package:chat/core/services/bloc_observer.dart';
import 'package:chat/core/services/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.init();
  await FirebaseDatabaseService.init();
  await Firebase.initializeApp();
  // await NotificationService.init();
  Bloc.observer = MyBlocObserver();
  await initAppModule();
  runApp(MyApp());
}
