import 'package:flutter/material.dart';
import '../components/BannerComponent.dart';
import '../components/CategoriesSection.dart';
import '../components/FeaturedGamesSection.dart';
import '../components/NewReleasesSection.dart';
import '../components/PopularGamesSection.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedCategory;

  void onCategorySelected(String category) {
    setState(() {
      selectedCategory = category.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF0D0D0D),
        elevation: 0,
        title: const Text(
          'GameStore',
          style: TextStyle(
            color: Color(0xFFFFD9F5),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF60D3F3)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Color(0xFFFAB4E5)),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: const Color(0xFF0D0D0D),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BannerComponent(),
            const SizedBox(height: 20),
            CategoriesSection(onCategorySelected: onCategorySelected),
            const SizedBox(height: 20),
            FeaturedGamesSection(category: selectedCategory),
            const SizedBox(height: 20),
            PopularGamesSection(category: selectedCategory),
            const SizedBox(height: 20),
            NewReleasesSection(category: selectedCategory),
          ],
        ),
      ),
    );
  }
}
