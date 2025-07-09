import 'package:flutter/material.dart';
import '../components/BannerComponent.dart';
import '../components/CategoriesSection.dart';
import '../components/FeaturedGamesSection.dart';
import '../components/NewReleasesSection.dart';
import '../components/PopularGamesSection.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BannerComponent(),
          SizedBox(height: 20),
          CategoriesSection(),
          SizedBox(height: 20),
          FeaturedGamesSection(),
          SizedBox(height: 20),
          PopularGamesSection(),
          SizedBox(height: 20),
          NewReleasesSection(),
        ],
      ),
    );
  }
}
