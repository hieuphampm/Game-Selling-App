import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

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
Bạn là chuyên gia đánh giá game. Hãy viết một đoạn tóm tắt tiếng Việt thật hấp dẫn cho trò chơi này, bao gồm thể loại, điểm đặc trưng, lối chơi, đồ họa, và đối tượng yêu thích.

Tên: ${gameData?['name'] ?? ''}
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
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        title: const Text(
          "Game Details",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0A0E21),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.cyan))
          : gameData == null
              ? const Center(
                  child: Text(
                    "Không tìm thấy game",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                        "\$${gameData!['price']}",
                        style: const TextStyle(
                          color: Color(0xFF60D3F3),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildSectionTitle('Chế độ chơi'),
                      _buildListItems(gameData!['modes']),
                      const SizedBox(height: 20),
                      _buildSectionTitle('Yêu cầu hệ thống'),
                      _buildListItems(gameData!['requirements']),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed:
                            _isLoadingSummary ? null : _generateAiSummary,
                        icon: const Icon(Icons.auto_awesome),
                        label: Text(
                          _isLoadingSummary
                              ? 'Đang tạo tóm tắt...'
                              : 'Tóm tắt bằng AI',
                        ),
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
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: _isLoadingSummary
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.purple,
                                  ),
                                )
                              : Text(
                                  _aiSummary,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
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
        color: Color(0xFFFFD9F5),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildListItems(List<dynamic>? items) {
    if (items == null || items.isEmpty) {
      return const Text(
        'Không có dữ liệu',
        style: TextStyle(color: Colors.white54),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                "• $e",
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ),
          )
          .toList(),
    );
  }
}
