import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WishlistScreen extends StatefulWidget {
  static const routeName = '/wishlist';
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> wishlistItems = [
    {
      'id': 'cyberpunk2077',
      'title': 'Cyberpunk 2077',
      'price': '\$59.99',
      'discountPrice': '\$39.99',
      'discount': '-34%',
      'rating': 4.2,
      'imageUrl':
          'https://firebasestorage.googleapis.com/v0/b/game-selling-app.appspot.com/o/cyberpunk.jpg?alt=media',
      'inCart': false,
    },
    {
      'id': 'forzahorizon5',
      'title': 'Forza Horizon 5',
      'price': '\$49.99',
      'discountPrice': '\$29.99',
      'discount': '-40%',
      'rating': 4.7,
      'imageUrl':
          'https://firebasestorage.googleapis.com/v0/b/game-selling-app.appspot.com/o/forza.jpg?alt=media',
      'inCart': true,
    },
    {
      'id': 'hollowknight',
      'title': 'Hollow Knight',
      'price': '\$14.99',
      'discountPrice': null,
      'discount': null,
      'rating': 4.9,
      'imageUrl':
          'https://firebasestorage.googleapis.com/v0/b/game-selling-app.appspot.com/o/hollow.jpg?alt=media',
      'inCart': false,
    },
    {
      'id': 'gtav',
      'title': 'Grand Theft Auto V',
      'price': '\$29.99',
      'discountPrice': null,
      'discount': null,
      'rating': 4.9,
      'imageUrl':
          'https://firebasestorage.googleapis.com/v0/b/game-selling-app.appspot.com/o/gta.jpg?alt=media',
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
        content: const Text('Removed from wishlist'),
        backgroundColor: Colors.pinkAccent,
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.white,
          onPressed: () {},
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
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        title: const Text('Wishlist'),
        backgroundColor: const Color(0xFF0A0E21),
      ),
      body: wishlistItems.isEmpty
          ? const Center(
              child: Text(
                'Wishlist is empty.',
                style: TextStyle(color: Colors.white54),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: wishlistItems.length,
              itemBuilder: (context, index) {
                final item = wishlistItems[index];
                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: Duration(milliseconds: 500 + index * 100),
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
              },
            ),
    );
  }

  Widget _buildWishlistItem(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1C2C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            item['imageUrl'],
            width: 70,
            height: 70,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          item['title'],
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text(
                  item['rating'].toString(),
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                if (item['discountPrice'] != null) ...[
                  Text(
                    item['price'],
                    style: const TextStyle(
                      color: Colors.white38,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    item['discountPrice'],
                    style: const TextStyle(
                      color: Color(0xFF60D3F3),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item['discount'] ?? '',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ] else
                  Text(
                    item['price'],
                    style: const TextStyle(
                      color: Color(0xFF60D3F3),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(
                item['inCart'] ? Icons.shopping_cart : Icons.add_shopping_cart,
                color: item['inCart'] ? Colors.cyan : Colors.white54,
              ),
              onPressed: () => _toggleCart(item['id']),
            ),
            IconButton(
              icon: const Icon(Icons.favorite, color: Colors.pinkAccent),
              onPressed: () => _removeFromWishlist(item['id']),
            ),
          ],
        ),
      ),
    );
  }
}
