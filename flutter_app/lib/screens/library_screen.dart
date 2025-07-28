import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/game.dart';

class LibraryScreen extends StatefulWidget {
  static const routeName = '/library';
  const LibraryScreen({super.key});

  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  Future<List<Game>> fetchPurchasedGames() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('purchased_games').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Game(
        id: doc.id,
        name: data['name'],
        genre: data['genre'],
        image_url: data['image_url'],
        price: (data['price'] as num).toDouble(),
        rating: (data['rating'] as num).toDouble(),
        code: data['code'], // Mã game nếu có
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        title: const Text("My Library"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Game>>(
        future: fetchPurchasedGames(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
                child: Text("Error loading library",
                    style: TextStyle(color: Colors.white)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text("No games purchased yet",
                    style: TextStyle(color: Colors.white70)));
          }

          final games = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.72,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: games.length,
            itemBuilder: (context, index) {
              return LibraryGameCard(game: games[index]);
            },
          );
        },
      ),
    );
  }
}

class LibraryGameCard extends StatelessWidget {
  final Game game;

  const LibraryGameCard({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                game.image_url,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(game.name,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
          Text(game.genre,
              style: const TextStyle(color: Colors.white54, fontSize: 12)),
          const SizedBox(height: 4),
          if (game.code != null && game.code!.isNotEmpty) ...[
            const Text("Code:",
                style: TextStyle(color: Colors.cyanAccent, fontSize: 12)),
            SelectableText(
              game.code!,
              style: const TextStyle(color: Colors.greenAccent),
            )
          ] else
            const Text("No key yet",
                style: TextStyle(color: Colors.redAccent, fontSize: 12)),
        ],
      ),
    );
  }
}
