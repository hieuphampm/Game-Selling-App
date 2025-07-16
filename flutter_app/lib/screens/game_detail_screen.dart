import 'package:flutter/material.dart';
<<<<<<< Updated upstream

class GameDetailScreen extends StatelessWidget {
  final String title;
  final String price;
  final double rating;
  final Color imageColor;
=======
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class GameDetailScreen extends StatefulWidget {
  final String documentId;
>>>>>>> Stashed changes

  const GameDetailScreen({super.key, required this.documentId});

  @override
<<<<<<< Updated upstream
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0E21),
      body: CustomScrollView(
        slivers: [
          // App Bar with Hero Image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Color(0xFF0A0E21),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.favorite_border, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.share, color: Colors.white),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      imageColor.withOpacity(0.8),
                      imageColor.withOpacity(0.4),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Game cover placeholder
                    Center(
                      child: Icon(
                        Icons.gamepad,
                        size: 120,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                    // Gradient overlay
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      height: 100,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Color(0xFF0A0E21)],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
=======
  State<GameDetailScreen> createState() => _GameDetailScreenState();
}

class _GameDetailScreenState extends State<GameDetailScreen> {
  Map<String, dynamic>? gameData;
  bool isLoading = true;
  bool isWishlisted = false;
  String _aiSummary = '';
  bool _isLoadingSummary = false;
  bool _showAiSummary = false;
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
    if (!dotenv.isInitialized) await dotenv.load(fileName: ".env");

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
      if (gemini == null) await loadGemini();

      final prompt = '''
Viết một đoạn mô tả hấp dẫn bằng tiếng Việt cho game này:
Tên: ${gameData?['title'] ?? ''}
Giá: \$${gameData?['price'] ?? ''}
Chế độ chơi: ${(gameData?['modes'] as List<dynamic>?)?.join(', ') ?? ''}
Yêu cầu hệ thống: ${(gameData?['requirements'] as List<dynamic>?)?.join(', ') ?? ''}
''';

      final response = await gemini!.text(prompt);
      setState(() {
        _aiSummary = response?.output ?? 'Không có phản hồi từ AI.';
      });
    } catch (e) {
      setState(() {
        _aiSummary = 'Lỗi: $e';
      });
    } finally {
      setState(() {
        _isLoadingSummary = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        title:
            const Text("Game Details", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0D0D0D),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(
              isWishlisted ? Icons.favorite : Icons.favorite_border,
              color: isWishlisted ? Colors.pinkAccent : Colors.white,
>>>>>>> Stashed changes
            ),
            onPressed: () {
              setState(() {
                isWishlisted = !isWishlisted;
              });
              // TODO: Lưu vào Firestore wishlist nếu cần
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.cyan))
          : gameData == null
              ? const Center(
                  child: Text("Không tìm thấy game",
                      style: TextStyle(color: Colors.white)))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
<<<<<<< Updated upstream
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            color: Color(0xFFFFD9F5),
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
=======
                      Hero(
                        tag: widget.documentId,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            gameData!['thumbnail'] ?? '',
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
>>>>>>> Stashed changes
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
<<<<<<< Updated upstream
                        price,
                        style: TextStyle(
=======
                        gameData!['title'] ?? '',
                        style: const TextStyle(
                          fontSize: 26,
                          color: Color(0xFFFFD9F5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "\$${gameData!['price']}",
                        style: const TextStyle(
                          fontSize: 20,
>>>>>>> Stashed changes
                          color: Color(0xFF60D3F3),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
<<<<<<< Updated upstream
                    ],
                  ),
                  SizedBox(height: 12),

                  // Rating and Reviews
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 20),
                      SizedBox(width: 4),
                      Text(
                        rating.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '(2.4K Reviews)',
                        style: TextStyle(color: Colors.white54, fontSize: 14),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Game Info Cards
                  Row(
                    children: [
                      _buildInfoCard('Genre', 'Action RPG'),
                      SizedBox(width: 12),
                      _buildInfoCard('Size', '4.2 GB'),
                      SizedBox(width: 12),
                      _buildInfoCard('Age', '16+'),
                    ],
                  ),
                  SizedBox(height: 24),

                  // Description
                  Text(
                    'Description',
                    style: TextStyle(
                      color: Color(0xFFFFD9F5),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Embark on an epic adventure in this stunning game that combines breathtaking visuals with immersive gameplay. Experience a rich storyline, dynamic combat system, and explore vast open worlds filled with mysteries and challenges.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 24),

                  // Screenshots
                  Text(
                    'Screenshots',
                    style: TextStyle(
                      color: Color(0xFFFFD9F5),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    height: 180,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 280,
                          margin: EdgeInsets.only(right: 12),
=======
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            "${gameData?['rating'] ?? '4.5'} / 5",
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if ((gameData?['description'] ?? '').isNotEmpty) ...[
                        _buildSectionTitle('📝 Mô tả'),
                        Text(
                          gameData!['description'],
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 14, height: 1.5),
                        ),
                      ],
                      const SizedBox(height: 16),
                      _buildSectionTitle('🎮 Chế độ chơi'),
                      _buildListItems(gameData!['modes']),
                      const SizedBox(height: 16),
                      _buildSectionTitle('💻 Yêu cầu hệ thống'),
                      _buildListItems(gameData!['requirements']),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed:
                            _isLoadingSummary ? null : _generateAiSummary,
                        icon: const Icon(Icons.auto_awesome),
                        label: Text(_isLoadingSummary
                            ? 'Đang tạo tóm tắt...'
                            : '✨ Tóm tắt bằng AI'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8B5CF6),
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(45),
                        ),
                      ),
                      if (_showAiSummary) ...[
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(16),
>>>>>>> Stashed changes
                          decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(12),
<<<<<<< Updated upstream
                            gradient: LinearGradient(
                              colors: [
                                imageColor.withOpacity(0.3),
                                imageColor.withOpacity(0.1),
                              ],
                            ),
=======
>>>>>>> Stashed changes
                          ),
                          child: _isLoadingSummary
                              ? const Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.purple))
                              : Text(
                                  _aiSummary,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 15,
                                    height: 1.5,
                                  ),
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
        color: Color(0xFFFAB4E5),
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildListItems(List<dynamic>? items) {
    if (items == null || items.isEmpty) {
      return const Text('Không có dữ liệu',
          style: TextStyle(color: Colors.white54));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map((e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(
                  "• $e",
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ))
          .toList(),
    );
  }
}
