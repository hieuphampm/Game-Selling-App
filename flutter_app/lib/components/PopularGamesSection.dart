import 'package:flutter/cupertino.dart';
import 'GameCard.dart';

class PopularGamesSection extends StatelessWidget {
  const PopularGamesSection({super.key});

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
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            children: const [
              GameCard(documentId: 'gta_v'),
              GameCard(documentId: 'euro_truck_simulator_2'),
              GameCard(documentId: 'hollow_knight'),
            ],
          ),
        ),
      ],
    );
  }
}
