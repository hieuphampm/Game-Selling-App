import 'package:flutter/cupertino.dart';

import 'GameCard.dart';

class NewReleasesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'New Releases',
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
                title: 'Quantum Shift',
                price: '\$69.99',
                rating: 4.4,
                imageColor: Color(0xFFFAB4E5),
              ),
              GameCard(
                title: 'Ocean Depths',
                price: '\$54.99',
                rating: 4.6,
                imageColor: Color(0xFF60D3F3),
              ),
              GameCard(
                title: 'Galaxy Heroes',
                price: '\$34.99',
                rating: 4.7,
                imageColor: Color(0xFFFFD9F5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}