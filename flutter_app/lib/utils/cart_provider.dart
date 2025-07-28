import 'package:flutter/foundation.dart';

// Game model class - Export this class so other files can use it
class Game {
  final String id;
  final String name;
  final double price;
  final String image_url;
  final String? category;
  final String? description;

  Game({
    required this.id,
    required this.name,
    required this.price,
    required this.image_url,
    this.category,
    this.description,
  });

  // Add factory constructor to create Game from Map (useful for Firestore)
  factory Game.fromMap(Map<String, dynamic> map, String id) {
    return Game(
      id: id,
      name: map['name'] ?? '',
      price: (map['price'] is int)
          ? (map['price'] as int).toDouble()
          : (map['price'] ?? 0).toDouble(),
      image_url: map['image_url'] ?? '',
      category: map['category'] is List
          ? (map['category'] as List).join(', ')
          : map['category'],
      description: map['description'],
    );
  }
}

class CartProvider extends ChangeNotifier {
  final List<Game> _items = [];

  // Getter để lấy danh sách items
  List<Game> get items => [..._items];

  // Getter để lấy số lượng items
  int get itemCount => _items.length;

  // Getter để tính tổng giá
  double get totalAmount {
    double total = 0.0;
    for (var item in _items) {
      total += item.price;
    }
    return total;
  }

  // Thêm game vào cart
  void addItem(Game game) {
    // Kiểm tra xem game đã có trong cart chưa
    bool exists = _items.any((item) => item.id == game.id);

    if (!exists) {
      _items.add(game);
      notifyListeners();
    }
  }

  // Xóa game khỏi cart
  void removeItem(Game game) {
    _items.removeWhere((item) => item.id == game.id);
    notifyListeners();
  }

  // Xóa game theo index
  void removeItemByIndex(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      notifyListeners();
    }
  }

  // Clear toàn bộ cart
  void clear() {
    _items.clear();
    notifyListeners();
  }

  // Kiểm tra xem game có trong cart không
  bool isInCart(String gameId) {
    return _items.any((item) => item.id == gameId);
  }

  // Lấy game theo id
  Game? findById(String id) {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }
}
