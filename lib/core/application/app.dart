import 'package:chat/core/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'app_builder.dart';

class MyApp extends StatefulWidget {
  const MyApp._internal();

  static const MyApp _instance = MyApp._internal();

  factory MyApp() => _instance;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppRoutes routes = AppRoutes();
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          builder: defaultAppBuilder,
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          onGenerateRoute: routes.onGenerateRoute,
          initialRoute: '/',
          theme: ThemeData(
            colorSchemeSeed: Colors.black38,
            useMaterial3: true,
          ),
          title: 'Chat',
        );
      },
    );
  }
}
