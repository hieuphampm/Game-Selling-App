import 'package:flutter/material.dart';

class GameDetailScreen extends StatefulWidget {
  final Map<String, dynamic>? gameData;

  const GameDetailScreen({super.key, this.gameData});

  @override
  State<GameDetailScreen> createState() => _GameDetailScreenState();
}

class _GameDetailScreenState extends State<GameDetailScreen> {
  bool isInWishlist = false;
  int selectedImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Get game data from parameter or use defaults
    final String gameName = widget.gameData?['title'] ?? 'Cyber Quest 2024';
    final String developer =
        widget.gameData?['developer'] ?? 'Future Games Studio';
    final String releaseDate =
        widget.gameData?['releaseDate'] ?? 'March 15, 2024';
    final double rating = widget.gameData?['rating'] ?? 4.5;
    final String price = widget.gameData?['price'] ?? '\$59.99';
    final String? discountPrice = widget.gameData?['originalPrice'];
    final String? discount = widget.gameData?['discount'];
    final List<String> genres = List<String>.from(
      widget.gameData?['genres'] ?? ['Action', 'RPG', 'Sci-Fi'],
    );
    final Color imageColor =
        widget.gameData?['imageColor'] ?? const Color(0xFFFFD9F5);
    final String description =
        widget.gameData?['description'] ??
        'Experience the future of gaming in this epic adventure. Immerse yourself in a sprawling world where technology and humanity collide.';

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: CustomScrollView(
        slivers: [
          // App Bar with Hero Image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: const Color(0xFF0D0D0D),
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isInWishlist ? Icons.favorite : Icons.favorite_outline,
                    color: isInWishlist
                        ? const Color(0xFFFAB4E5)
                        : Colors.white,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    isInWishlist = !isInWishlist;
                  });
                },
              ),
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.share, color: Colors.white),
                ),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [imageColor, imageColor.withOpacity(0.6)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.videogame_asset,
                        color: Colors.white30,
                        size: 100,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          gameName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          developer,
                          style: const TextStyle(
                            color: Color(0xFF60D3F3),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Game Details
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price and Buy Button
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFFAB4E5).withOpacity(0.3),
                          const Color(0xFF60D3F3).withOpacity(0.3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF333333)),
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (discount != null) ...[
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFAB4E5),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      discount,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  if (discountPrice != null)
                                    Text(
                                      discountPrice,
                                      style: const TextStyle(
                                        color: Color(0xFF666666),
                                        decoration: TextDecoration.lineThrough,
                                        fontSize: 16,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 5),
                            ],
                            Text(
                              price,
                              style: const TextStyle(
                                color: Color(0xFFFFD9F5),
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/payment');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFAB4E5),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            'Buy Now',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Rating and Info
                  Row(
                    children: [
                      _buildInfoItem(
                        Icons.star,
                        '$rating',
                        const Color(0xFFFAB4E5),
                      ),
                      const SizedBox(width: 20),
                      _buildInfoItem(
                        Icons.calendar_today,
                        releaseDate,
                        const Color(0xFF60D3F3),
                      ),
                      const SizedBox(width: 20),
                      _buildInfoItem(
                        Icons.download,
                        '2.5M',
                        const Color(0xFF4CAF50),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Genres
                  Wrap(
                    spacing: 10,
                    children: genres.map((genre) {
                      return Chip(
                        label: Text(
                          genre,
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: const Color(0xFF1A1A1A),
                        side: const BorderSide(color: Color(0xFF60D3F3)),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 30),

                  // About Section
                  const Text(
                    'About This Game',
                    style: TextStyle(
                      color: Color(0xFFFFD9F5),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Color(0xFF60D3F3),
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Screenshots
                  const Text(
                    'Screenshots',
                    style: TextStyle(
                      color: Color(0xFFFFD9F5),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedImageIndex = index;
                            });
                            _showFullScreenImage(context, index);
                          },
                          child: Container(
                            width: 300,
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: LinearGradient(
                                colors: [
                                  imageColor.withOpacity(0.5),
                                  imageColor.withOpacity(0.3),
                                ],
                              ),
                              border: Border.all(
                                color: const Color(0xFF333333),
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.image,
                                color: Colors.white30,
                                size: 50,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 30),

                  // System Requirements
                  const Text(
                    'System Requirements',
                    style: TextStyle(
                      color: Color(0xFFFFD9F5),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildRequirementsSection(),

                  const SizedBox(height: 30),

                  // Reviews Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Reviews',
                        style: TextStyle(
                          color: Color(0xFFFFD9F5),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'See All',
                          style: TextStyle(color: Color(0xFF60D3F3)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildReviewItem(
                    username: 'GamerPro',
                    rating: 5,
                    review:
                        'Best game I\'ve played this year! The graphics are stunning.',
                    date: '2 days ago',
                  ),
                  _buildReviewItem(
                    username: 'CasualPlayer',
                    rating: 4,
                    review: 'Great gameplay but could use more content.',
                    date: '1 week ago',
                  ),

                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 5),
        Text(text, style: const TextStyle(color: Colors.white, fontSize: 14)),
      ],
    );
  }

  Widget _buildRequirementsSection() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFF333333)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Minimum:',
            style: TextStyle(
              color: Color(0xFF60D3F3),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          _buildRequirementItem('OS:', 'Windows 10 64-bit'),
          _buildRequirementItem('Processor:', 'Intel Core i5-6600K'),
          _buildRequirementItem('Memory:', '8 GB RAM'),
          _buildRequirementItem('Graphics:', 'NVIDIA GTX 1060'),
          _buildRequirementItem('Storage:', '50 GB available space'),

          const SizedBox(height: 15),

          const Text(
            'Recommended:',
            style: TextStyle(
              color: Color(0xFF60D3F3),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          _buildRequirementItem('OS:', 'Windows 11 64-bit'),
          _buildRequirementItem('Processor:', 'Intel Core i7-10700K'),
          _buildRequirementItem('Memory:', '16 GB RAM'),
          _buildRequirementItem('Graphics:', 'NVIDIA RTX 3070'),
          _buildRequirementItem('Storage:', '50 GB available space'),
        ],
      ),
    );
  }

  Widget _buildRequirementItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(color: Color(0xFF666666), fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Color(0xFF60D3F3), fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem({
    required String username,
    required int rating,
    required String review,
    required String date,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFF333333)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFFFAB4E5),
                radius: 20,
                child: Text(
                  username[0].toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: const TextStyle(
                      color: Color(0xFFFFD9F5),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < rating ? Icons.star : Icons.star_outline,
                        color: const Color(0xFFFAB4E5),
                        size: 14,
                      );
                    }),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                date,
                style: const TextStyle(color: Color(0xFF666666), fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            review,
            style: const TextStyle(color: Color(0xFF60D3F3), fontSize: 14),
          ),
        ],
      ),
    );
  }

  void _showFullScreenImage(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.7,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFFAB4E5).withOpacity(0.8),
                      const Color(0xFF60D3F3).withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Icon(Icons.image, color: Colors.white30, size: 100),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
