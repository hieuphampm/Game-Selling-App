import 'package:flutter/cupertino.dart';

import 'GameCard.dart';

class FeaturedGamesSection extends StatelessWidget {
  const FeaturedGamesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
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
        SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            children: [
              GameCard(
                title: 'Cyber Quest 2024',
                price: '\$59.99',
                rating: 4.8,
                imageColor: Color(0xFFFFD9F5),
              ),
              GameCard(
                title: 'Space Warriors',
                price: '\$49.99',
                rating: 4.6,
                imageColor: Color(0xFF60D3F3),
              ),
              GameCard(
                title: 'Dragon Tales',
                price: '\$39.99',
                rating: 4.9,
                imageColor: Color(0xFFFAB4E5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
