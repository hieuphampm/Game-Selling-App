import 'package:flutter/material.dart';
import 'CategoryCard.dart';

class CategoriesSection extends StatelessWidget {
  final void Function(String) onCategorySelected;

  const CategoriesSection({super.key, required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Categories',
            style: TextStyle(
              color: Color(0xFFFFD9F5),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              CategoryCard(
                title: 'All',
                icon: Icons.apps,
                onTap: () => onCategorySelected('all'),
              ),
              CategoryCard(
                title: 'Action',
                icon: Icons.flash_on,
                onTap: () => onCategorySelected('action'),
              ),
              CategoryCard(
                title: 'Adventure',
                icon: Icons.explore,
                onTap: () => onCategorySelected('adventure'),
              ),
              CategoryCard(
                title: 'RPG',
                icon: Icons.shield,
                onTap: () => onCategorySelected('rpg'),
              ),
              CategoryCard(
                title: 'Strategy',
                icon: Icons.psychology,
                onTap: () => onCategorySelected('strategy'),
              ),
              CategoryCard(
                title: 'Sports',
                icon: Icons.sports_soccer,
                onTap: () => onCategorySelected('sport'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
