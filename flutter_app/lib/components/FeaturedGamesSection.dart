import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'GameCard.dart';

class FeaturedGamesSection extends StatelessWidget {
  final String? category;

  const FeaturedGamesSection({super.key, this.category});

  Future<List<Map<String, dynamic>>> fetchGames() async {
    final snapshot = await FirebaseFirestore.instance.collection('game').get();
    final allGames = snapshot.docs;

    List<Map<String, dynamic>> games = [];

    for (final doc in allGames) {
      final data = doc.data();
      final categories = List<String>.from(data['category'] ?? []);
      final shouldInclude = category == null ||
          categories
              .map((e) => e.toLowerCase())
              .contains(category!.toLowerCase());

      if (shouldInclude) {
        games.add({
          'documentId': doc.id,
          'name': data['name'] ?? '',
          'price': (data['price'] ?? 0).toString(),
          'image_url': data['image_url'] ?? '',
        });
      }
    }

    if (category == null && games.length > 4) {
      return games.sublist(games.length - 4);
    }

    return games;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchGames(),
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
            child: Text('Không có game phù hợp.',
                style: TextStyle(color: Colors.white)),
          );
        }

        final games = snapshot.data!;

        return _buildGameSection("Featured Games", games);
      },
    );
  }

  Widget _buildGameSection(String title, List<Map<String, dynamic>> games) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            title,
            style: const TextStyle(
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
  }
}
