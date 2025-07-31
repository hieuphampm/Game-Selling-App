import 'package:flutter/foundation.dart';

/// ✅ Game model class chuẩn hóa `category` là List<String>
class Game {
  final String id;
  final String name;
  final double price;
  final String image_url;
  final List<String> category;
  final String? description;

  Game({
    required this.id,
    required this.name,
    required this.price,
    required this.image_url,
    required this.category,
    this.description,
  });

  // Factory tạo Game từ Firestore map
  factory Game.fromMap(Map<String, dynamic> map, String id) {
    return Game(
      id: id,
      name: map['name'] ?? '',
      price: (map['price'] is int)
          ? (map['price'] as int).toDouble()
          : (map['price'] ?? 0).toDouble(),
      image_url: map['image_url'] ?? '',
      category: map['category'] is List
          ? List<String>.from(map['category'])
          : map['category'] != null
              ? [map['category'].toString()]
              : [],
      description: map['description'],
    );
  }
}

class CartProvider extends ChangeNotifier {
  final List<Game> _items = [];

  /// Getter lấy danh sách item
  List<Game> get items => [..._items];

  /// Getter lấy số lượng items
  int get itemCount => _items.length;

  /// Tổng giá tiền
  double get totalAmount {
    double total = 0.0;
    for (var item in _items) {
      total += item.price;
    }
    return total;
  }

  /// Thêm game
  void addItem(Game game) {
    bool exists = _items.any((item) => item.id == game.id);
    if (!exists) {
      _items.add(game);
      notifyListeners();
    }
  }

  /// Xoá game
  void removeItem(Game game) {
    _items.removeWhere((item) => item.id == game.id);
    notifyListeners();
  }

  /// Xoá theo index
  void removeItemByIndex(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      notifyListeners();
    }
  }

  /// Xoá toàn bộ
  void clear() {
    _items.clear();
    notifyListeners();
  }

  /// Kiểm tra có trong cart chưa
  bool isInCart(String gameId) {
    return _items.any((item) => item.id == gameId);
  }

  /// Lấy game theo ID
  Game? findById(String id) {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }
}
