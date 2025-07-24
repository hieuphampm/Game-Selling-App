import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'GameCard.dart';

class PopularGamesSection extends StatelessWidget {
  final String? category;

  const PopularGamesSection({super.key, this.category});

  Future<List<Map<String, dynamic>>> fetchPopularGames() async {
    final snapshot = await FirebaseFirestore.instance.collection('game').get();

    final allGames = snapshot.docs;

    final games = allGames
        .where((doc) {
          final data = doc.data();
          final categories = List<String>.from(data['category'] ?? []);
          if (category == null) return true;
          return categories
              .map((e) => e.toLowerCase())
              .contains(category!.toLowerCase());
        })
        .skip(3)
        .take(3)
        .map((doc) {
          final data = doc.data();
          return {
            'documentId': doc.id,
            'name': data['name'] ?? '',
            'price': data['price']?.toString() ?? '',
            'image_url': data['image_url'] ?? '',
          };
        })
        .toList();

    return games;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchPopularGames(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(color: Colors.cyan),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Không có game phổ biến.',
                style: TextStyle(color: Colors.white)),
          );
        }

        final games = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Popular Games',
                style: TextStyle(
                  color: Color(0xFFFFD9F5),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: games.length,
                itemBuilder: (context, index) {
                  final game = games[index];
                  return GameCard(
                    documentId: game['documentId'],
                    title: game['name'],
                    price: '\$${game['price']}',
                    rating: null,
                    thumbnailUrl: game['image_url'],
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
