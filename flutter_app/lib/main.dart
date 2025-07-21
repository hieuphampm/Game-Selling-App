import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'auth/login.dart';
import 'auth/register.dart';
import 'auth/forgot_password.dart';
import 'screens/home_screen.dart';
import 'components/navbar.dart';
import 'screens/library_screen.dart';
import 'screens/community_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/wishlist_screen.dart';
import 'screens/settings/achievement_screen.dart';
import 'firebase_options.dart';

// import 'utils/firebase_seed.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load env (nếu dùng dotenv cho Gemini API)
  await dotenv.load(fileName: '.env');

  // Init Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Chạy seed 1 lần duy nhất (rồi có thể comment lại)
  // await seedGamesToFirestore();

  runApp(const GameSellingApp());
}

class GameSellingApp extends StatelessWidget {
  const GameSellingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game Selling App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        useMaterial3: true,
      ),
      initialRoute: LoginScreen.routeName,
      routes: {
        LoginScreen.routeName: (_) => const LoginScreen(),
        RegisterScreen.routeName: (_) => const RegisterScreen(),
        ForgotPasswordScreen.routeName: (_) => const ForgotPasswordScreen(),
        HomeScreen.routeName: (_) => const HomeScreen(),
        NavBar.routeName: (_) => const NavBar(),
        LibraryScreen.routeName: (_) => const LibraryScreen(),
        CommunityScreen.routeName: (_) => const CommunityScreen(),
        SettingsScreen.routeName: (_) => const SettingsScreen(),
        WishlistScreen.routeName: (_) => const WishlistScreen(),
        AchievementScreen.routeName: (_) => AchievementScreen(),
        ...CommunityScreen.routes,
      },
    );
  }
}
