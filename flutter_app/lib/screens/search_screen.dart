import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'game_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Map<String, dynamic>> allGames = [];
  List<Map<String, dynamic>> filteredGames = [];

  @override
  void initState() {
    super.initState();
    fetchGames();
  }

  Future<void> fetchGames() async {
    final snapshot = await FirebaseFirestore.instance.collection('game').get();
    final games = snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        ...doc.data(),
      };
    }).toList();

    setState(() {
      allGames = games;
      filteredGames = games;
    });
  }

  void search(String query) {
    final results = allGames.where((game) {
      final name = game['name'].toString().toLowerCase();
      return name.contains(query.toLowerCase());
    }).toList();

    setState(() => filteredGames = results);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Games'),
        backgroundColor: const Color(0xFF0D0D0D),
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFF0D0D0D),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search games...',
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.cyan),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: search,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredGames.length,
              itemBuilder: (context, index) {
                final game = filteredGames[index];
                return ListTile(
                  title: Text(game['name'],
                      style: const TextStyle(color: Colors.white)),
                  subtitle: Text("\$${game['price']}",
                      style: const TextStyle(color: Colors.white70)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            GameDetailScreen(documentId: game['id']),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
