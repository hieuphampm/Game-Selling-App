import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'screens/register.dart';
import 'screens/forgot_password.dart';

void main() {
  runApp(InterviewApplication());
}

class InterviewApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Interview-Application',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: LoginScreen.routeName,
      routes: {
        LoginScreen.routeName: (_) => LoginScreen(),
        RegisterScreen.routeName: (_) => RegisterScreen(),
        ForgotPasswordScreen.routeName: (_) => ForgotPasswordScreen(),
      },
    );
  }
}
