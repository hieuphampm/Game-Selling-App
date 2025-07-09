import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WishlistScreen extends StatefulWidget {
  static var routeName;

  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Sample wishlist data
  final List<Map<String, dynamic>> wishlistItems = [
    {
      'id': '1',
      'title': 'Cyber Quest 2024',
      'price': '\$59.99',
      'discountPrice': '\$39.99',
      'discount': '-33%',
      'rating': 4.8,
      'imageColor': const Color(0xFFFFD9F5),
      'inCart': false,
    },
    {
      'id': '2',
      'title': 'Space Warriors',
      'price': '\$49.99',
      'discountPrice': null,
      'rating': 4.6,
      'imageColor': const Color(0xFF60D3F3),
      'inCart': true,
    },
    {
      'id': '3',
      'title': 'Dragon Tales',
      'price': '\$39.99',
      'discountPrice': '\$29.99',
      'discount': '-25%',
      'rating': 4.9,
      'imageColor': const Color(0xFFFAB4E5),
      'inCart': false,
    },
    {
      'id': '4',
      'title': 'Neon Racer',
      'price': '\$29.99',
      'discountPrice': null,
      'rating': 4.7,
      'imageColor': const Color(0xFF60D3F3),
      'inCart': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _removeFromWishlist(String id) {
    setState(() {
      wishlistItems.removeWhere((item) => item['id'] == id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Removed from wishlist'),
        backgroundColor: Color(0xFFFAB4E5),
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.white,
          onPressed: () {
            // Implement undo functionality
          },
        ),
      ),
    );
  }

  void _toggleCart(String id) {
    setState(() {
      final index = wishlistItems.indexWhere((item) => item['id'] == id);
      if (index != -1) {
        wishlistItems[index]['inCart'] = !wishlistItems[index]['inCart'];
      }
    });

    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0E21),
      body: CustomScrollView(
        slivers: [
          // Custom App Bar
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            backgroundColor: Color(0xFF0A0E21),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'My Wishlist',
                style: TextStyle(
                  color: Color(0xFFFFD9F5),
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFAB4E5).withOpacity(0.3),
                      Color(0xFF60D3F3).withOpacity(0.3),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.sort, color: Colors.white),
                onPressed: () {
                  _showSortOptions();
                },
              ),
              IconButton(
                icon: Icon(Icons.filter_list, color: Colors.white),
                onPressed: () {
                  _showFilterOptions();
                },
              ),
            ],
          ),

          // Summary Card
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1a1e30), Color(0xFF252b42)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSummaryItem(
                          'Total Items',
                          wishlistItems.length.toString(),
                          Icons.favorite,
                          Color(0xFFFAB4E5),
                        ),
                        _buildSummaryItem(
                          'Total Value',
                          '\$${_calculateTotalValue()}',
                          Icons.attach_money,
                          Color(0xFF60D3F3),
                        ),
                        _buildSummaryItem(
                          'Savings',
                          '\$${_calculateSavings()}',
                          Icons.local_offer,
                          Color(0xFFFFD9F5),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Wishlist Items
          wishlistItems.isEmpty
              ? SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite_border,
                          size: 80,
                          color: Colors.white24,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Your wishlist is empty',
                          style: TextStyle(color: Colors.white54, fontSize: 18),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Start adding games you love!',
                          style: TextStyle(color: Colors.white38, fontSize: 14),
                        ),
                        SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFFAB4E5),
                            padding: EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: Text(
                            'Browse Games',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SliverPadding(
                  padding: EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final item = wishlistItems[index];
                      return TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: Duration(milliseconds: 500 + (index * 100)),
                        curve: Curves.easeOutBack,
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: Opacity(
                              opacity: value,
                              child: _buildWishlistItem(item),
                            ),
                          );
                        },
                      );
                    }, childCount: wishlistItems.length),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label, style: TextStyle(color: Colors.white54, fontSize: 12)),
      ],
    );
  }

  Widget _buildWishlistItem(Map<String, dynamic> item) {
    return Dismissible(
      key: Key(item['id']),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        _removeFromWishlist(item['id']);
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(Icons.delete, color: Colors.white, size: 30),
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [item['imageColor'].withOpacity(0.1), Colors.transparent],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: item['imageColor'].withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              // Navigate to game detail
            },
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  // Game Image Placeholder
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          item['imageColor'],
                          item['imageColor'].withOpacity(0.6),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.gamepad,
                      color: Colors.white.withOpacity(0.8),
                      size: 40,
                    ),
                  ),
                  SizedBox(width: 16),

                  // Game Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            SizedBox(width: 4),
                            Text(
                              item['rating'].toString(),
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            if (item['discountPrice'] != null) ...[
                              Text(
                                item['price'],
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 14,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                item['discountPrice'],
                                style: TextStyle(
                                  color: Color(0xFF60D3F3),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  item['discount'] ?? '',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ] else
                              Text(
                                item['price'],
                                style: TextStyle(
                                  color: Color(0xFF60D3F3),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Action Buttons
                  Column(
                    children: [
                      IconButton(
                        onPressed: () => _toggleCart(item['id']),
                        icon: Icon(
                          item['inCart']
                              ? Icons.shopping_cart
                              : Icons.add_shopping_cart,
                          color: item['inCart']
                              ? Color(0xFF60D3F3)
                              : Colors.white54,
                        ),
                      ),
                      IconButton(
                        onPressed: () => _removeFromWishlist(item['id']),
                        icon: Icon(Icons.favorite, color: Color(0xFFFAB4E5)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _calculateTotalValue() {
    double total = 0;
    for (var item in wishlistItems) {
      String priceStr = item['discountPrice'] ?? item['price'];
      double price = double.parse(priceStr.replaceAll('\$', ''));
      total += price;
    }
    return total.toStringAsFixed(2);
  }

  String _calculateSavings() {
    double savings = 0;
    for (var item in wishlistItems) {
      if (item['discountPrice'] != null) {
        double originalPrice = double.parse(item['price'].replaceAll('\$', ''));
        double discountPrice = double.parse(
          item['discountPrice'].replaceAll('\$', ''),
        );
        savings += (originalPrice - discountPrice);
      }
    }
    return savings.toStringAsFixed(2);
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Color(0xFF1a1e30),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sort By',
                style: TextStyle(
                  color: Color(0xFFFFD9F5),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              _buildSortOption('Price: Low to High', Icons.arrow_upward),
              _buildSortOption('Price: High to Low', Icons.arrow_downward),
              _buildSortOption('Rating', Icons.star),
              _buildSortOption('Recently Added', Icons.access_time),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSortOption(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFF60D3F3)),
      title: Text(title, style: TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }

  void _showFilterOptions() {}
}
