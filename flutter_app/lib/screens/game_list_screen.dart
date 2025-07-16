import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../components/GameCard.dart';

class GameListScreen extends StatelessWidget {
  const GameListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🔥 All Games'),
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('games').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong 😢"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final games = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: games.length,
            itemBuilder: (context, index) {
              final game = games[index];
              final data = game.data() as Map<String, dynamic>;

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    // Hero Thumbnail
                    Hero(
                      tag: 'thumbnail_${game.id}',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          data['thumbnail'] ?? '',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                              width: 100, height: 100, color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Game Info
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/game-detail',
                            arguments: game.id,
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['title'] ?? 'Untitled',
                              style: const TextStyle(
                                color: Color(0xFFFFD9F5),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.star,
                                    size: 16, color: Color(0xFFFAB4E5)),
                                const SizedBox(width: 4),
                                Text(
                                  data['rating']?.toString() ?? 'N/A',
                                  style:
                                      const TextStyle(color: Color(0xFF60D3F3)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              data['description'] ??
                                  'Một tựa game hấp dẫn đang chờ bạn khám phá...',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.white70),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
