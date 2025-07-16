import 'package:flutter/cupertino.dart';
import 'GameCard.dart';

class NewReleasesSection extends StatelessWidget {
  const NewReleasesSection({super.key});

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
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            children: const [
              GameCard(documentId: 'quantum_shift'),
              GameCard(documentId: 'ocean_depths'),
              GameCard(documentId: 'galaxy_heroes'),
            ],
          ),
        ),
      ],
    );
  }
}
