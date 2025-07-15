import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GameDetailScreen extends StatefulWidget {
  final String title;
  final String price;
  final double rating;
  final Color imageColor;

  const GameDetailScreen({
    super.key,
    required this.title,
    required this.price,
    required this.rating,
    required this.imageColor,
  });

  @override
  State<GameDetailScreen> createState() => _GameDetailScreenState();
}

class _GameDetailScreenState extends State<GameDetailScreen> {
  String _aiSummary = '';
  bool _isLoadingSummary = false;
  bool _showAiSummary = false;

  // Gemini API configuration
  static const String _apiKey = 'AIzaSyChgARKLloeKbo4UsWcYyDdDS7wKe7hpCs';
  static const String _apiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$_apiKey';

  Future<void> _generateAiSummary() async {
    setState(() {
      _isLoadingSummary = true;
      _showAiSummary = true;
    });

    try {
      final gameDescription =
          '''
      Game: ${widget.title}
      Price: ${widget.price}
      Rating: ${widget.rating}/5.0
      Genre: Action RPG
      Description: Embark on an epic adventure in this stunning game that combines breathtaking visuals with immersive gameplay. Experience a rich storyline, dynamic combat system, and explore vast open worlds filled with mysteries and challenges.
      ''';

      final requestBody = {
        'contents': [
          {
            'parts': [
              {
                'text':
                    'Please provide a comprehensive summary of this game in Vietnamese. Include gameplay features, what makes it unique, and who would enjoy playing it. Here\'s the game information:\n\n$gameDescription',
              },
            ],
          },
        ],
        'generationConfig': {'temperature': 0.7, 'maxOutputTokens': 500},
      };

      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final summary = data['candidates'][0]['content']['parts'][0]['text'];

        setState(() {
          _aiSummary = summary;
          _isLoadingSummary = false;
        });
      } else {
        setState(() {
          _aiSummary = 'Không thể tạo tóm tắt. Vui lòng thử lại sau.';
          _isLoadingSummary = false;
        });
      }
    } catch (e) {
      setState(() {
        _aiSummary = 'Đã xảy ra lỗi: $e';
        _isLoadingSummary = false;
      });
    }
  }

  @override
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
                      widget.imageColor.withOpacity(0.8),
                      widget.imageColor.withOpacity(0.4),
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
            ),
          ),
          // Game Details
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Price Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.title,
                          style: TextStyle(
                            color: Color(0xFFFFD9F5),
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        widget.price,
                        style: TextStyle(
                          color: Color(0xFF60D3F3),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),

                  // Rating and Reviews
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 20),
                      SizedBox(width: 4),
                      Text(
                        widget.rating.toString(),
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

                  // AI Summary Button
                  Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextButton.icon(
                      onPressed: _isLoadingSummary ? null : _generateAiSummary,
                      icon: Icon(
                        Icons.auto_awesome,
                        color: Colors.white,
                        size: 20,
                      ),
                      label: Text(
                        _isLoadingSummary
                            ? 'Đang tạo tóm tắt...'
                            : 'Tóm tắt bằng AI',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // AI Summary Section
                  if (_showAiSummary) ...[
                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xFF8B5CF6).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Color(0xFF8B5CF6).withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.auto_awesome,
                                color: Color(0xFF8B5CF6),
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'AI Summary',
                                style: TextStyle(
                                  color: Color(0xFF8B5CF6),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Spacer(),
                              IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: Colors.white54,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _showAiSummary = false;
                                  });
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          if (_isLoadingSummary)
                            Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF8B5CF6),
                              ),
                            )
                          else
                            Text(
                              _aiSummary,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],

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
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                              colors: [
                                widget.imageColor.withOpacity(0.3),
                                widget.imageColor.withOpacity(0.1),
                              ],
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.image,
                              size: 50,
                              color: Colors.white24,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 24),

                  // System Requirements
                  Text(
                    'System Requirements',
                    style: TextStyle(
                      color: Color(0xFFFFD9F5),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  _buildRequirementRow('OS', 'Windows 10/11 64-bit'),
                  _buildRequirementRow('Processor', 'Intel Core i5-8400'),
                  _buildRequirementRow('Memory', '8 GB RAM'),
                  _buildRequirementRow('Graphics', 'NVIDIA GTX 1060'),
                  _buildRequirementRow('Storage', '50 GB available space'),

                  SizedBox(height: 100), // Space for bottom buttons
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom Action Buttons
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFF0A0E21),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Add to Cart Button
            Expanded(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF60D3F3)),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Add to Cart',
                    style: TextStyle(
                      color: Color(0xFF60D3F3),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            // Buy Now Button
            Expanded(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFAB4E5), Color(0xFF60D3F3)],
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Buy Now',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(label, style: TextStyle(color: Colors.white54, fontSize: 12)),
            SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: Color(0xFFFFD9F5),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequirementRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(color: Colors.white54, fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
