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
  Future<List<Game>>? _purchasedGamesFuture;

  @override
  void initState() {
    super.initState();
    _refreshGames();
  }

  void _refreshGames() {
    setState(() {
      _purchasedGamesFuture = fetchPurchasedGames();
    });
  }

  Future<List<Game>> fetchPurchasedGames() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('purchased_games').get();

      print('Total documents found: ${snapshot.docs.length}'); // Debug log

      return snapshot.docs.map((doc) {
        final data = doc.data();
        print('Document ID: ${doc.id}'); // Debug log
        print('Raw data: $data'); // Debug log

        // Xử lý category linh hoạt - có thể là String hoặc List
        List<String> categoryList = [];
        if (data['category'] != null) {
          if (data['category'] is List) {
            // Nếu là List, convert thành List<String>
            categoryList = (data['category'] as List<dynamic>)
                .map((e) => e.toString())
                .toList();
          } else if (data['category'] is String) {
            // Nếu là String, tạo List chỉ có 1 phần tử
            categoryList = [data['category'].toString()];
          }
        }

        final game = Game(
          id: doc.id,
          name: data['name'] ?? 'Unknown',
          category: categoryList,
          image_url: data['image_url'] ?? '',
          price: (data['price'] as num?)?.toDouble() ?? 0.0,
          rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
          code: data['code'] ?? 'No key',
        );

        print('Created game: ${game.name}, Code: ${game.code}'); // Debug log
        return game;
      }).toList();
    } catch (e) {
      print('Error fetching games: $e');
      print('Stack trace: ${StackTrace.current}'); // Thêm stack trace để debug
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        title: const Text("My Library"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          // Thêm refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshGames,
          ),
        ],
      ),
      body: FutureBuilder<List<Game>>(
        future: _purchasedGamesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Error loading library",
                      style: TextStyle(color: Colors.white)),
                  const SizedBox(height: 8),
                  Text("${snapshot.error}",
                      style: const TextStyle(color: Colors.red, fontSize: 12)),
                  ElevatedButton(
                    onPressed: _refreshGames,
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("No games purchased yet",
                      style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _refreshGames,
                    child: const Text("Refresh"),
                  ),
                ],
              ),
            );
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
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.videogame_asset,
                      color: Colors.white54, size: 24);
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(game.name,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
          Text(game.category.isNotEmpty ? game.category[0] : 'Unknown',
              style: const TextStyle(color: Colors.white54, fontSize: 12)),
          const SizedBox(height: 4),
          if (game.code != null &&
              game.code!.isNotEmpty &&
              game.code != 'No key') ...[
            const Text("Code:",
                style: TextStyle(color: Colors.cyanAccent, fontSize: 12)),
            SelectableText(
              game.code!,
              style: const TextStyle(color: Colors.greenAccent, fontSize: 11),
            )
          ] else
            const Text("No key yet",
                style: TextStyle(color: Colors.redAccent, fontSize: 12)),
        ],
      ),
    );
  }
}
