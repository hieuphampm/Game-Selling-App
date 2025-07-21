import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'payment_screen.dart'; // Add this import

class GameDetailScreen extends StatefulWidget {
  final String documentId;

  const GameDetailScreen({super.key, required this.documentId});

  @override
  State<GameDetailScreen> createState() => _GameDetailScreenState();
}

class _GameDetailScreenState extends State<GameDetailScreen> {
  Map<String, dynamic>? gameData;
  bool isLoading = true;
  String _aiSummary = '';
  bool _isLoadingSummary = false;
  bool _showAiSummary = false;
  bool _isAddingToCart = false;
  bool _isBuying = false;
  Gemini? gemini;

  @override
  void initState() {
    super.initState();
    fetchGameData();
  }

  Future<void> fetchGameData() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('game')
          .doc(widget.documentId)
          .get();

      if (doc.exists) {
        setState(() {
          gameData = doc.data();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> loadGemini() async {
    if (!dotenv.isInitialized) {
      await dotenv.load(fileName: ".env");
    }

    final apiKey = dotenv.env['API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception("API key not found in .env file");
    }

    gemini = Gemini.init(apiKey: apiKey);
  }

  Future<void> _generateAiSummary() async {
    setState(() {
      _isLoadingSummary = true;
      _showAiSummary = true;
    });

    try {
      if (gemini == null) {
        await loadGemini();
      }

      final prompt = '''
      You are a game review expert. Write a compelling English summary for this game, including genre, features, gameplay, graphics, and target audience.

      Name: ${gameData?['name'] ?? ''}
      Category: ${gameData?['category']?.join(', ') ?? ''}
      System requirements: ${gameData?['requirements']?.join(', ') ?? ''}
      Play modes: ${gameData?['modes']?.join(', ') ?? ''}
      ''';

      final response = await gemini!.text(prompt);

      setState(() {
        _aiSummary = response?.output ?? 'AI not responding.';
      });
    } catch (e) {
      setState(() {
        _aiSummary = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoadingSummary = false;
      });
    }
  }

  Future<void> _addToCart() async {
    setState(() {
      _isAddingToCart = true;
    });

    try {
      // Add your cart logic here
      // Example: Add to Firestore cart collection
      await FirebaseFirestore.instance.collection('cart').add({
        'gameId': widget.documentId,
        'gameName': gameData!['name'],
        'price': gameData!['price'],
        'imageUrl': gameData!['image_url'],
        'addedAt': FieldValue.serverTimestamp(),
        // Add user ID when you implement authentication
        // 'userId': currentUserId,
      });

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${gameData!['name']} added to cart!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cannot add to cart: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAddingToCart = false;
        });
      }
    }
  }

  Future<void> _buyNow() async {
    setState(() {
      _isBuying = true;
    });

    try {
      // Add your purchase logic here
      // Example: Create order in Firestore
      await FirebaseFirestore.instance.collection('orders').add({
        'gameId': widget.documentId,
        'gameName': gameData!['name'],
        'price': gameData!['price'],
        'imageUrl': gameData!['image_url'],
        'orderDate': FieldValue.serverTimestamp(),
        'status': 'pending',
        // Add user ID when you implement authentication
        // 'userId': currentUserId,
      });

      // Navigate to payment screen
      if (mounted) {
        Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (context) => PaymentScreen(gameData: gameData!)
          )
        );
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error when buy game: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isBuying = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        title:
            const Text("Game Details", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0A0E21),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.cyan))
          : gameData == null
              ? const Center(
                  child: Text("Không tìm thấy game",
                      style: TextStyle(color: Colors.white)),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (gameData!['image_url'] != null)
                        Container(
                          width: double.infinity,
                          height: 200,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              gameData!['image_url'],
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  color: Colors.white10,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                      color: Colors.cyan,
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.white10,
                                  child: const Icon(Icons.image_not_supported,
                                      color: Colors.white54, size: 50),
                                );
                              },
                            ),
                          ),
                        ),
                      Text(
                        gameData!['name'] ?? '',
                        style: const TextStyle(
                          color: Color(0xFFFFD9F5),
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "\$${gameData!['price'].toString()}",
                        style: const TextStyle(
                          color: Color(0xFF60D3F3),
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Buy and Add to Cart buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _isBuying ? null : _buyNow,
                              icon: _isBuying
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(Icons.shopping_bag),
                              label: Text(_isBuying ? 'Processing...' : 'Buy Now'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF71CFFE),
                                foregroundColor: Colors.white,
                                minimumSize: const Size.fromHeight(50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _isAddingToCart ? null : _addToCart,
                              icon: _isAddingToCart
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(Icons.add_shopping_cart),
                              label: Text(_isAddingToCart ? 'Adding...' : 'Add to Cart'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFB3D9),
                                foregroundColor: Colors.white,
                                minimumSize: const Size.fromHeight(50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 20),
                      
                      if (gameData!['description'] != null &&
                          gameData!['description']
                              .toString()
                              .trim()
                              .isNotEmpty) ...[
                        _buildSectionTitle('Description'),
                        const SizedBox(height: 8),
                        Text(
                          gameData!['description'],
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                      if (gameData!['category'] != null) ...[
                        _buildSectionTitle('Category'),
                        _buildListItems(gameData!['category']),
                        const SizedBox(height: 20),
                      ],
                      if (gameData!['requirements'] != null) ...[
                        _buildSectionTitle('System Requirements'),
                        _buildListItems(gameData!['requirements']),
                        const SizedBox(height: 20),
                      ],
                      if (gameData!['modes'] != null) ...[
                        _buildSectionTitle('Play modes'),
                        _buildListItems(gameData!['modes']),
                        const SizedBox(height: 20),
                      ],
                      ElevatedButton.icon(
                        onPressed:
                            _isLoadingSummary ? null : _generateAiSummary,
                        icon: const Icon(Icons.auto_awesome),
                        label: Text(
                          _isLoadingSummary
                              ? 'Creating summary...'
                              : 'Summary with AI',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF60D3F3 ),
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(45),
                        ),
                      ),
                      if (_showAiSummary) ...[
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: _isLoadingSummary
                              ? const Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.purple))
                              : Text(
                                  _aiSummary,
                                  style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                      height: 1.5),
                                ),
                        ),
                      ],
                    ],
                  ),
                ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFFFFD9F5),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildListItems(List<dynamic>? items) {
    if (items == null || items.isEmpty) {
      return const Text('No Data',
          style: TextStyle(color: Colors.white54));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text("• $e",
                  style: const TextStyle(color: Colors.white70, fontSize: 14)),
            ),
          )
          .toList(),
    );
  }
}