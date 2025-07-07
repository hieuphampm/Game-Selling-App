import 'package:flutter/material.dart';
import 'auth/login.dart';
import 'auth/register.dart';
import 'auth/forgot_password.dart';

void main() {
  runApp(InterviewApplication());
}

class InterviewApplication extends StatelessWidget {
  const InterviewApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game Selling App',
      theme: ThemeData(primarySwatch: Colors.grey),
      initialRoute: LoginScreen.routeName,
      routes: {
        LoginScreen.routeName: (_) => LoginScreen(),
        RegisterScreen.routeName: (_) => RegisterScreen(),
        ForgotPasswordScreen.routeName: (_) => ForgotPasswordScreen(),
      },
    );
  }
}
