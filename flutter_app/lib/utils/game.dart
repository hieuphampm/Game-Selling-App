class Game {
  final String id;
  final String name;
  final String genre;
  final String image_url;
  final double price;
  final double rating;
  final String? code; // null nếu chưa mua

  Game({
    required this.id,
    required this.name,
    required this.genre,
    required this.image_url,
    required this.price,
    required this.rating,
    this.code,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      genre: json['genre'] ?? '',
      image_url: json['image_url'] ?? '',
      price: (json['price'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'genre': genre,
      'image_url': image_url,
      'price': price,
      'rating': rating,
      'code': code,
    };
  }
}
