import 'package:flutter/material.dart';

class SupportScreen extends StatelessWidget {
  static const routeName = '/support';

  const SupportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        title: const Text(
          'Support',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: const Center(
        child: Text(
          'How can we help you?',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
