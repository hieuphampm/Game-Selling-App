import 'package:flutter/material.dart';
import 'GameCard.dart';

class FeaturedGamesSection extends StatelessWidget {
  const FeaturedGamesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Featured Games',
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
                documentId: 'cyberpunk_2077',
                title: 'Cyberpunk 2077',
                price: '\$59.99',
                rating: 4.8,
                thumbnailUrl:
                    'https://cdn.cloudflare.steamstatic.com/steam/apps/1091500/header.jpg',
              ),
              GameCard(
                documentId: 'microsoft_flight_simulator',
                title: 'Flight Simulator',
                price: '\$69.99',
                rating: 4.9,
                thumbnailUrl:
                    'https://cdn.cloudflare.steamstatic.com/steam/apps/1250410/header.jpg',
              ),
              GameCard(
                documentId: 'forza_horizon_5',
                title: 'Forza Horizon 5',
                price: '\$49.99',
                rating: 4.7,
                thumbnailUrl:
                    'https://cdn.cloudflare.steamstatic.com/steam/apps/1551360/header.jpg',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
