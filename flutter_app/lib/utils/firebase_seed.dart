import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> seedGamesToFirestore() async {
  final List<Map<String, dynamic>> games = [
    {
      'id': 'game_01',
      'name': 'Microsoft Flight Simulator (2020)',
      'price': 49,
      'image_url':
          'https://firebasestorage.googleapis.com/v0/b/computer-shop-management-a2cdd.appspot.com/o/Game%2Fmfs.jpg?alt=media&token=ab591f54-82a5-45f5-b566-1dbad227461d',
      'category': ['simulator'],
      'requirements': [
        'Windows 10',
        'Intel i5-4460 | AMD Ryzen 3 1200',
        '8 GB RAM',
        'NVIDIA GTX 770 | AMD Radeon RX 570',
        '150 GB'
      ],
      'modes': ['Single Player', 'Multiplayer'],
      'codes': [
        'mfsA9K3X2T',
        'mfsB7YQ1NZ',
        'mfsL4W8V0E',
        'mfsT3RM6PA',
        'mfsC2Z8DNL',
        'mfsX1QWER9',
        'mfsU5VBNM2',
        'mfsK8HJ7TR',
        'mfsZ6PLM3A',
        'mfsD9XC4YU'
      ]
    },
    {
      'id': 'game_02',
      'name': 'Forza Horizon 5',
      'price': 35,
      'image_url':
          'https://firebasestorage.googleapis.com/v0/b/computer-shop-management-a2cdd.appspot.com/o/Game%2Fforza.jpg?alt=media&token=ae6d25a4-1ca1-4fb0-abc0-de9c0cc6542e',
      'category': ['simulator', 'racing', 'sport'],
      'requirements': [
        'Windows 10',
        'Intel i5-4460 or AMD Ryzen 3 1200',
        '8 GB RAM',
        'NVidia GTX 970, AMD RX 470, OR Intel Arc A380',
        '110 GB'
      ],
      'modes': ['Single Player', 'Multiplayer'],
      'codes': [
        'fhA7X9T2PQ',
        'fhM3L8WZ1E',
        'fhK5Q2N7YD',
        'fhZ6RP1XMB',
        'fhB8VC3JNL',
        'fhD9YU4TWE',
        'fhL1MK7ZQA',
        'fhU2XN9EPV',
        'fhC3WQ6RBT',
        'fhT0JZ8MLN'
      ]
    },
    // 🎮 Thêm game_03 đến game_10 tương tự tại đây (copy từ JSON)
  ];

  for (final gameData in games) {
    final id = gameData['id'] ?? 'unknown_id';
    final game = Map<String, dynamic>.from(gameData);
    game.remove('id'); // Firestore key sẽ là `id`, không lưu lặp trong nội dung
    await FirebaseFirestore.instance.collection('game').doc(id).set(game);
  }

  print('✅ Seeded all games to Firestore.');
}
