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
            children: const [
              GameCard(documentId: 'cyberpunk_2077'),
              GameCard(documentId: 'microsoft_flight_simulator'),
              GameCard(documentId: 'forza_horizon_5'),
            ],
          ),
        ),
      ],
    );
  }
}
