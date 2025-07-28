class Game {
  final String id;
  final String name;
  final List<String> category; // Thay genre bằng category và dùng List<String>
  final String image_url;
  final double price;
  final double rating; // Thêm giá trị mặc định
  final String? code; // null nếu chưa mua

  Game({
    required this.id,
    required this.name,
    required this.category,
    required this.image_url,
    required this.price,
    this.rating = 0.0, // Giá trị mặc định cho rating
    this.code,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: (json['category'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [], // Xử lý mảng category
      image_url: json['image_url'] ?? '',
      price: (json['price'] as num).toDouble(),
      rating: (json['rating'] as num?)?.toDouble() ??
          0.0, // Giá trị mặc định nếu không có
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'image_url': image_url,
      'price': price,
      'rating': rating,
      'code': code,
    };
  }
}
