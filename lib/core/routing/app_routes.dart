import 'package:chat/core/routing/arguments/chat_arguments.dart';
import 'package:chat/core/routing/routes.dart';
import 'package:chat/core/utils/extensions.dart';
import 'package:chat/core/utils/shared_methods.dart';
import 'package:chat/features/auth/ui/screens/all_users_screen.dart';
import 'package:chat/features/auth/ui/screens/login_screen.dart';
import 'package:chat/features/auth/ui/screens/register_screen.dart';
import 'package:chat/features/chat/ui/screens/chat_list_screen.dart';
import 'package:chat/features/chat/ui/screens/chat_screen.dart';
import 'package:chat/features/splash/ui/screens/splash_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  Route? onGenerateRoute(RouteSettings settings) {
    Routes? navigatedRoute =
        Routes.values.firstWhereOrNull((route) => route.path == settings.name);
    printSuccess("Route => $navigatedRoute");
    if (settings.name == '/') {
      navigatedRoute = Routes.splash;
    }
    switch (navigatedRoute) {
      case Routes.splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
      case Routes.login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );
      case Routes.register:
        return MaterialPageRoute(
          builder: (_) => const RegisterScreen(),
        );
      case Routes.allUsers:
        return MaterialPageRoute(
          builder: (_) => const AllUsersScreen(),
        );
      case Routes.chatList:
        return MaterialPageRoute(
          builder: (_) => const ChatListScreen(),
        );
      case Routes.chat:
        final ChatArguments arguments = settings.arguments as ChatArguments;
        return MaterialPageRoute(
          builder: (_) => ChatScreen(
            arguments: arguments,
          ),
        );
      default:
        return null;
    }
  }
}
