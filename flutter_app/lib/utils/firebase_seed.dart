import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> seedGamesToFirestore() async {
  final List<Map<String, dynamic>> games = [
    {
      'id': 'microsoft_flight_simulator',
      'title': 'Microsoft Flight Simulator (2020)',
      'price': '\$59.99',
      'rating': 4.8,
      'thumbnail':
          'https://upload.wikimedia.org/wikipedia/en/2/2d/Microsoft_Flight_Simulator_Cover_Art.jpg',
      'description':
          'Fly around the world in stunning detail with realistic aircraft.'
    },
    {
      'id': 'forza_horizon_5',
      'title': 'Forza Horizon 5',
      'price': '\$49.99',
      'rating': 4.7,
      'thumbnail':
          'https://upload.wikimedia.org/wikipedia/en/7/76/Forza_Horizon_5_cover_art.jpg',
      'description':
          'Race through the vibrant open world of Mexico with powerful cars.'
    },
    {
      'id': 'left_4_dead_2',
      'title': 'Left 4 Dead 2',
      'price': '\$9.99',
      'rating': 4.5,
      'thumbnail':
          'https://upload.wikimedia.org/wikipedia/en/8/8e/Left4Dead2.jpg',
      'description': 'Survive the zombie apocalypse with your friends.'
    },
    {
      'id': 'gta_v',
      'title': 'Grand Theft Auto V',
      'price': '\$29.99',
      'rating': 4.9,
      'thumbnail':
          'https://upload.wikimedia.org/wikipedia/en/a/a5/Grand_Theft_Auto_V.png',
      'description': 'Explore the criminal underworld of Los Santos.'
    },
    {
      'id': 'ready_or_not',
      'title': 'Ready or Not',
      'price': '\$39.99',
      'rating': 4.6,
      'thumbnail':
          'https://upload.wikimedia.org/wikipedia/en/e/e4/Ready_or_Not_cover.jpg',
      'description': 'Tactical FPS game where you lead SWAT missions.'
    },
    {
      'id': 'euro_truck_simulator_2',
      'title': 'Euro Truck Simulator 2',
      'price': '\$24.99',
      'rating': 4.4,
      'thumbnail':
          'https://upload.wikimedia.org/wikipedia/en/5/5c/Euro_Truck_Simulator_2_cover_art.jpg',
      'description':
          'Drive trucks across Europe delivering cargo and exploring roads.'
    },
    {
      'id': 'cyberpunk_2077',
      'title': 'Cyberpunk 2077',
      'price': '\$59.99',
      'rating': 4.2,
      'thumbnail':
          'https://upload.wikimedia.org/wikipedia/en/9/9f/Cyberpunk_2077_box_art.jpg',
      'description': 'Experience a futuristic open world in Night City.'
    },
    {
      'id': 'hollow_knight',
      'title': 'Hollow Knight',
      'price': '\$14.99',
      'rating': 4.9,
      'thumbnail':
          'https://upload.wikimedia.org/wikipedia/en/3/32/Hollow_Knight_cover.jpg',
      'description': 'Explore the ancient underground world of Hallownest.'
    },
    {
      'id': 'blasphemous',
      'title': 'Blasphemous',
      'price': '\$19.99',
      'rating': 4.6,
      'thumbnail':
          'https://upload.wikimedia.org/wikipedia/en/0/0d/Blasphemous_art.jpg',
      'description': 'Dark and brutal metroidvania with religious themes.'
    },
    {
      'id': 'alien_isolation',
      'title': 'Alien: Isolation',
      'price': '\$29.99',
      'rating': 4.7,
      'thumbnail':
          'https://upload.wikimedia.org/wikipedia/en/f/f1/Alien_Isolation.jpg',
      'description': 'Hide from the terrifying Xenomorph in deep space.'
    },
  ];

  for (final gameData in games) {
    final id = gameData['id']?.toString() ?? 'unknown_id';
    await FirebaseFirestore.instance.collection('game').doc(id).set(gameData);
  }

  print('✅ Seeded all games to Firestore.');
}
