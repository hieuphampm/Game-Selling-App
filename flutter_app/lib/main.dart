import 'package:flutter/material.dart';
import 'auth/login.dart';
import 'auth/register.dart';
import 'auth/forgot_password.dart';
import './components/navbar.dart';
import 'screens/home_screen.dart';
// import 'screens/library_screen.dart';
import 'screens/community_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(const GameSellingApp());
}

class GameSellingApp extends StatelessWidget {
  const GameSellingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game Selling App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
      ),
      initialRoute: LoginScreen.routeName,
      routes: {
        LoginScreen.routeName: (_) => const LoginScreen(),
        RegisterScreen.routeName: (_) => const RegisterScreen(),
        ForgotPasswordScreen.routeName: (_) => const ForgotPasswordScreen(),
        NavBar.routeName: (_) => const NavBar(),
        HomeScreen.routeName: (_) => const HomeScreen(),
        // LibraryScreen.routeName: (_) => const LibraryScreen(),
        CommunityScreen.routeName: (_) => const CommunityScreen(),
        SettingsScreen.routeName: (_) => const SettingsScreen(),
        ...CommunityScreen.routes,
      },
    );
  }
}
