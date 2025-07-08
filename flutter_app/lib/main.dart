import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth/login.dart';
import 'screens/home_screen.dart';
import 'auth/register.dart';
import 'auth/forgot_password.dart';
import './components/navbar.dart';
import 'screens/home_screen.dart';
// import 'screens/library_screen.dart';
import 'screens/community_screen.dart';
import 'screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
void main() {
  runApp(const GameSellingApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Login App',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      title: 'Game Selling App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
      ),
      initialRoute: LoginScreen.routeName,
      routes: {
        LoginScreen.routeName: (context) => const LoginScreen(),
        HomeScreen.routeName: (context) => const HomeScreen(),
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
