import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:provider/provider.dart';
import '../utils/cart_provider.dart';
import 'payment_screen.dart';

final Map<String, List<Map<String, dynamic>>> gameReviews = {
  'Cyberpunk 2077': [
    {
      "user": "Nguyễn Thảo",
      "rating": 4.5,
      "comment":
          "Đồ họa đỉnh cao, thế giới mở cực kỳ sống động. Tuy vẫn còn một vài lỗi nhỏ."
    },
    {
      "user": "Trần Quốc Bảo",
      "rating": 5.0,
      "comment": "Game siêu hay, cốt truyện lôi cuốn và nhạc nền rất tuyệt!"
    },
  ],
  'The Witcher 3': [
    {
      "user": "Lê Hoàng",
      "rating": 5.0,
      "comment": "Game nhập vai đỉnh nhất mọi thời đại! Geralt quá ngầu!"
    },
    {
      "user": "Phạm Lan",
      "rating": 4.8,
      "comment": "Cốt truyện hấp dẫn, nhiệm vụ phong phú và rất có chiều sâu."
    },
  ],
  'Genshin Impact': [
    {
      "user": "Mai Hương",
      "rating": 4.2,
      "comment":
          "Game miễn phí mà chất lượng quá tuyệt vời, đồ họa anime dễ thương."
    },
    {
      "user": "Vũ Dũng",
      "rating": 3.9,
      "comment": "Lối chơi lôi cuốn nhưng hơi tốn thời gian cày cuốc."
    },
  ],
};

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
      final cart = Provider.of<CartProvider>(context, listen: false);

      if (cart.isInCart(widget.documentId)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${gameData!['name']} Already in cart!'),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } else {
        final game = Game.fromMap(gameData!, widget.documentId);
        cart.addItem(game);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${gameData!['name']} alrealy in cart!'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Không thể thêm vào giỏ: $e'),
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
      final gameList = [Game.fromMap(gameData!, widget.documentId)];

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentScreen(cartItems: gameList),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error buying game: $e'),
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
    final cart = Provider.of<CartProvider>(context);
    final isInCart =
        gameData != null ? cart.isInCart(widget.documentId) : false;

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
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(Icons.shopping_bag),
                              label:
                                  Text(_isBuying ? 'Processing...' : 'Buy Now'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF71CFFE),
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: (_isAddingToCart || isInCart)
                                  ? null
                                  : _addToCart,
                              icon: _isAddingToCart
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Icon(isInCart
                                      ? Icons.check
                                      : Icons.add_shopping_cart),
                              label: Text(_isAddingToCart
                                  ? 'Adding...'
                                  : isInCart
                                      ? 'Already in Cart'
                                      : 'Add to Cart'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isInCart
                                    ? Colors.grey
                                    : const Color(0xFFFFB3D9),
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
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
                        _buildListSection('Game Modes', gameData!['modes']),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed:
                            _isLoadingSummary ? null : _generateAiSummary,
                        icon: const Icon(Icons.auto_awesome),
                        label: Text(_isLoadingSummary
                            ? 'Creating summary...'
                            : 'Summarize with AI'),
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
                      if (gameData != null &&
                          gameReviews.containsKey(gameData!['name'])) ...[
                        const SizedBox(height: 20),
                        const Text(
                          'User Reviews',
                          style: TextStyle(
                            color: Color(0xFFFFD9F5),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...gameReviews[gameData!['name']]!.map((review) =>
                            _buildReviewCard(review['user'], review['rating'],
                                review['comment'])),
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

  Widget _buildReviewCard(String user, double rating, String comment) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person, color: Colors.cyanAccent),
              const SizedBox(width: 8),
              Text(
                user,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Icon(Icons.star, color: Colors.amber, size: 18),
              Text(
                rating.toString(),
                style: const TextStyle(color: Colors.amber),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            comment,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
