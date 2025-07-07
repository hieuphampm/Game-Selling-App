import 'package:flutter/cupertino.dart';

import 'GameCard.dart';

class PopularGamesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
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
        SizedBox(height: 12),
        Container(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            children: [
              GameCard(
                title: 'Neon Racer',
                price: '\$29.99',
                rating: 4.7,
                imageColor: Color(0xFF60D3F3),
              ),
              GameCard(
                title: 'Mystic Legends',
                price: '\$44.99',
                rating: 4.5,
                imageColor: Color(0xFFFAB4E5),
              ),
              GameCard(
                title: 'Battle Royale X',
                price: '\$19.99',
                rating: 4.8,
                imageColor: Color(0xFFFFD9F5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}