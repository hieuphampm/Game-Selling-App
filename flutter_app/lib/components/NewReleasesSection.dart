import 'package:flutter/material.dart';
import 'GameCard.dart';

class NewReleasesSection extends StatelessWidget {
  const NewReleasesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
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
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: const [
              GameCard(
                documentId: 'quantum_shift',
                title: 'Quantum Shift',
                price: '\$34.99',
                rating: 4.5,
                thumbnailUrl:
                    'https://placehold.co/600x200/000/FFF?text=Quantum+Shift',
              ),
              GameCard(
                documentId: 'ocean_depths',
                title: 'Ocean Depths',
                price: '\$24.99',
                rating: 4.3,
                thumbnailUrl:
                    'https://placehold.co/600x200/003366/FFF?text=Ocean+Depths',
              ),
              GameCard(
                documentId: 'galaxy_heroes',
                title: 'Galaxy Heroes',
                price: '\$29.99',
                rating: 4.6,
                thumbnailUrl:
                    'https://placehold.co/600x200/0f0f0f/FFF?text=Galaxy+Heroes',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
