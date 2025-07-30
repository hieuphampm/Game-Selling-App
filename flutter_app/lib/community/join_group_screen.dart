import 'package:flutter/material.dart';

class JoinGroupScreen extends StatelessWidget {
  static const routeName = '/join-group';
  const JoinGroupScreen({super.key});

  final List<String> groups = const [
    'Flutter Knights',
    'Kotlin Lovers',
    'Swift Play',
    'Firebase Buddies',
    'COCOAPODS Fans',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        title: const Text(
          'Join Group',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Search Groups',
                labelStyle: TextStyle(color: Colors.white54),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: groups.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => Card(
                  color: const Color(0xFF1A1A1A),
                  child: ListTile(
                    title: Text(
                      groups[i],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
