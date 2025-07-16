import 'package:flutter/material.dart';
import 'GameCard.dart';

class PopularGamesSection extends StatelessWidget {
  const PopularGamesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Popular Games',
            style: TextStyle(
              color: Color(0xFFFFD9F5),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: const [
              GameCard(
                documentId: 'gta_v',
                title: 'GTA V',
                price: '\$29.99',
                rating: 4.9,
                thumbnailUrl:
                    'https://cdn.cloudflare.steamstatic.com/steam/apps/271590/header.jpg',
              ),
              GameCard(
                documentId: 'euro_truck_simulator_2',
                title: 'Euro Truck 2',
                price: '\$19.99',
                rating: 4.7,
                thumbnailUrl:
                    'https://cdn.cloudflare.steamstatic.com/steam/apps/227300/header.jpg',
              ),
              GameCard(
                documentId: 'hollow_knight',
                title: 'Hollow Knight',
                price: '\$14.99',
                rating: 4.8,
                thumbnailUrl:
                    'https://cdn.cloudflare.steamstatic.com/steam/apps/367520/header.jpg',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
