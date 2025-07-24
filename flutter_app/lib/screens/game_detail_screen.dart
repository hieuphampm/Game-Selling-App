import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:provider/provider.dart';
import '../utils/cart_provider.dart';
import 'payment_screen.dart';

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
      // Create Game object from gameData
      final game = Game(
        id: widget.documentId,
        name: gameData!['name'],
        price: (gameData!['price'] is int)
            ? (gameData!['price'] as int).toDouble()
            : gameData!['price'].toDouble(),
        image_url: gameData!['image_url'],
        category: gameData!['category']?.join(', '),
        description: gameData!['description'],
      );

      // Add to cart using CartProvider
      Provider.of<CartProvider>(context, listen: false).addItem(game);

      // Optional: Also save to Firestore if you want to persist cart data
      await FirebaseFirestore.instance.collection('cart').add({
        'gameId': widget.documentId,
        'gameName': gameData!['name'],
        'price': gameData!['price'],
        'imageUrl': gameData!['image_url'],
        'addedAt': FieldValue.serverTimestamp(),
      });

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
      // Create Game object
      final game = Game(
        id: widget.documentId,
        name: gameData!['name'],
        price: (gameData!['price'] is int)
            ? (gameData!['price'] as int).toDouble()
            : gameData!['price'].toDouble(),
        image_url: gameData!['image_url'],
        category: gameData!['category']?.join(', '),
        description: gameData!['description'],
      );

      // Save order to Firestore
      await FirebaseFirestore.instance.collection('orders').add({
        'gameId': widget.documentId,
        'gameName': gameData!['name'],
        'price': gameData!['price'],
        'imageUrl': gameData!['image_url'],
        'orderDate': FieldValue.serverTimestamp(),
        'status': 'pending',
      });

      if (mounted) {
        // Navigate to payment with single item
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentScreen(cartItems: [game]),
          ),
        );
      }
    } catch (e) {
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
    final cartProvider = Provider.of<CartProvider>(context);
    final isInCart =
        gameData != null ? cartProvider.isInCart(widget.documentId) : false;

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
                  child: Text("Game not found",
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
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                    color: Colors.cyan,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image,
                                      color: Colors.white),
                            ),
                          ),
                        ),
                      Text(
                        gameData!['name'],
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

                      // ✅ Buy Now & Add to Cart Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _isBuying ? null : _buyNow,
                              icon: _isBuying
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2, color: Colors.white))
                                  : const Icon(Icons.shopping_bag),
                              label:
                                  Text(_isBuying ? 'Processing...' : 'Buy Now'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF71CFFE),
                                foregroundColor: Colors.white,
                                minimumSize: const Size.fromHeight(48),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: (isInCart || _isAddingToCart)
                                  ? null
                                  : _addToCart,
                              icon: _isAddingToCart
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2, color: Colors.white))
                                  : Icon(isInCart
                                      ? Icons.check
                                      : Icons.add_shopping_cart),
                              label: Text(_isAddingToCart
                                  ? 'Adding...'
                                  : isInCart
                                      ? 'In Cart'
                                      : 'Add to Cart'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isInCart
                                    ? Colors.grey
                                    : const Color(0xFFFFB3D9),
                                foregroundColor: Colors.white,
                                minimumSize: const Size.fromHeight(48),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      if (gameData!['description'] != null)
                        _buildSectionTitle(
                            'Description', gameData!['description']),
                      if (gameData!['category'] != null)
                        _buildListSection('Category', gameData!['category']),
                      if (gameData!['requirements'] != null)
                        _buildListSection(
                            'System Requirements', gameData!['requirements']),
                      if (gameData!['modes'] != null)
                        _buildListSection('Play Modes', gameData!['modes']),

                      const SizedBox(height: 20),

                      ElevatedButton.icon(
                        onPressed:
                            _isLoadingSummary ? null : _generateAiSummary,
                        icon: const Icon(Icons.auto_awesome),
                        label: Text(_isLoadingSummary
                            ? 'Creating summary...'
                            : 'Summary with AI'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF60D3F3),
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
                              : Text(_aiSummary,
                                  style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                      height: 1.5)),
                        ),
                      ],
                    ],
                  ),
                ),
    );
  }

  Widget _buildSectionTitle(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              color: Color(0xFFFFD9F5),
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildListSection(String title, List<dynamic> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              color: Color(0xFFFFD9F5),
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...items.map((e) => Text("• $e",
            style: const TextStyle(color: Colors.white70, fontSize: 14))),
        const SizedBox(height: 20),
      ],
    );
  }
}
