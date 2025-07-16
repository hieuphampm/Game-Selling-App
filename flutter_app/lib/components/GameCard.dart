import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../screens/game_detail_screen.dart';

class GameCard extends StatelessWidget {
  final String documentId;

  const GameCard({super.key, required this.documentId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance.collection('game').doc(documentId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            width: 150,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const SizedBox(
            width: 150,
            child: Center(child: Text('Game not found')),
          );
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final title = data['title'] ?? 'Unknown';
        final price = data['price'] ?? '\$0.00';
        final rating = data['rating']?.toDouble() ?? 0.0;
        final thumbnail = data['thumbnail'] ?? '';

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => GameDetailScreen(documentId: documentId),
              ),
            );
          },
          child: Container(
            width: 150,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF333333)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: 'game-image-$documentId',
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      thumbnail,
                      height: 100,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 100,
                        color: Colors.grey,
                        child: const Icon(Icons.videogame_asset, size: 40),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Color(0xFFFFD9F5),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star,
                              color: Color(0xFFFAB4E5), size: 16),
                          Text(
                            rating.toStringAsFixed(1),
                            style: const TextStyle(
                              color: Color(0xFF60D3F3),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        price,
                        style: const TextStyle(
                          color: Color(0xFFFAB4E5),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
