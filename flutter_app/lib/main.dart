import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'screens/register.dart';
import 'screens/forgot_password.dart';

void main() {
  runApp(InterviewApplication());
}

class InterviewApplication extends StatelessWidget {
  const InterviewApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Interview-Application',
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
