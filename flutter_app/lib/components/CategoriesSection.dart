import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'CategoryCard.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
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
        SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            children: [
              CategoryCard(title: 'Action', icon: Icons.flash_on),
              CategoryCard(title: 'Adventure', icon: Icons.explore),
              CategoryCard(title: 'RPG', icon: Icons.shield),
              CategoryCard(title: 'Strategy', icon: Icons.psychology),
              CategoryCard(title: 'Sports', icon: Icons.sports_soccer),
            ],
          ),
        ),
      ],
    );
  }
}
