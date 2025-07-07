import 'package:flutter/material.dart';

import '../components/BannerComponent.dart';
import '../components/CategoriesSection.dart';
import '../components/FeaturedGamesSection.dart';
import '../components/NewReleasesSection.dart';
import '../components/PopularGamesSection.dart';



class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: Color(0xFF0D0D0D),
        elevation: 0,
        title: Text(
          'GameStore',
          style: TextStyle(
            color: Color(0xFFFFD9F5),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Color(0xFF60D3F3)),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Color(0xFFFAB4E5)),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Component
            BannerComponent(),

            SizedBox(height: 20),

            // Categories Section
            CategoriesSection(),

            SizedBox(height: 20),

            // Featured Games Section
            FeaturedGamesSection(),

            SizedBox(height: 20),

            // Popular Games Section
            PopularGamesSection(),

            SizedBox(height: 20),

            // New Releases Section
            NewReleasesSection(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF0D0D0D),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFFFFD9F5),
        unselectedItemColor: Color(0xFF60D3F3),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.gamepad),
            label: 'Games',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}