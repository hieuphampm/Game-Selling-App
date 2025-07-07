// lib/screens/about_us.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AboutUsScreen extends StatelessWidget {
  static const routeName = '/about-us';
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFF0D0D0D);
    const pinkAccent = Color(0xFFFFD9F5);
    const lightPinkAccent = Color(0xFFFAB4E5);

    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with background image and title
            Stack(
              children: [
                Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/about_header.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  height: 200,
                  color: Colors.black.withOpacity(0.5),
                  alignment: Alignment.center,
                  child: const Text(
                    'About us',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Introduction Section (updated for GameStore)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Text(
                    'Welcome to GameStore!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: pinkAccent,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'GameStore is your one‑stop shop for the best PC and mobile games. '
                    'Discover new releases, exclusive deals, and community favorites—all in one place. '
                    'Join millions of gamers and level up your collection today!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 24),

                  // Feature Cards
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      _FeatureCard(
                        icon: Icons.local_offer,
                        title: 'Exclusive Deals',
                        subtitle: 'Up to 70% off top titles.',
                      ),
                      _FeatureCard(
                        icon: Icons.new_releases,
                        title: 'New Releases',
                        subtitle: 'Stay ahead with the latest games.',
                      ),
                      _FeatureCard(
                        icon: Icons.people,
                        title: 'Community Picks',
                        subtitle: 'Top-rated by fellow gamers.',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Media Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/images/team_photo.jpg',
                        height: 160,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/images/video_thumbnail.jpg',
                            height: 160,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 48,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 48),

            // Team Members Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Text(
                    'Team Members',
                    style: TextStyle(
                      color: pinkAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: const [
                      _MemberCard(
                        image: 'assets/images/member1.jpg',
                        name: 'Pham Phuoc Minh Hieu',
                        role: 'Head Developer, Director',
                      ),
                      _MemberCard(
                        image: 'assets/images/member2.jpg',
                        name: 'Vo Huynh Thai Bao (Peter)',
                        role: 'Developer',
                      ),
                      _MemberCard(
                        image: 'assets/images/member3.jpg',
                        name: 'Cao Sy Sieu',
                        role: 'Developer',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 48),

            // Footer (simple)
            Container(
              color: Colors.white12,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
              child: Column(
                children: [
                  Text(
                    'www.DownloadNewThemes.com',
                    style: TextStyle(color: lightPinkAccent),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '© 2025 GameStore. All rights reserved.',
                    style: TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    const pinkAccent = Color(0xFFFFD9F5);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: pinkAccent),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _MemberCard extends StatelessWidget {
  final String image, name, role;
  const _MemberCard({
    required this.image,
    required this.name,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: Column(
        children: [
          ClipOval(
            child: Image.asset(image, width: 96, height: 96, fit: BoxFit.cover),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            role,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              FaIcon(
                FontAwesomeIcons.facebookF,
                size: 16,
                color: Color(0xFF60D3F3),
              ),
              SizedBox(width: 8),
              FaIcon(FontAwesomeIcons.x, size: 16, color: Color(0xFF60D3F3)),
              SizedBox(width: 8),
              FaIcon(
                FontAwesomeIcons.linkedinIn,
                size: 16,
                color: Color(0xFFFAB4E5),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
