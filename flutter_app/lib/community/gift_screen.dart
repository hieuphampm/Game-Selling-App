import 'package:flutter/material.dart';

class GiftScreen extends StatelessWidget {
  static const routeName = '/gift';
  const GiftScreen({super.key});

  final List<String> redeemedGifts = const [
    'SUMMER2025',
    'WELCOME50',
    'FLUTTERLOVE',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        title: const Text(
          'Gift',
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
                labelText: 'Enter Gift Code',
                labelStyle: TextStyle(color: Colors.white54),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: redeem logic
              },
              child: const Text('Redeem'),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                itemCount: redeemedGifts.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => Card(
                  color: const Color(0xFF1A1A1A),
                  child: ListTile(
                    leading: const Icon(
                      Icons.check_circle,
                      color: Colors.white70,
                    ),
                    title: Text(
                      redeemedGifts[i],
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
