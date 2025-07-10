// screens/about_us_screen.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hugeicons/hugeicons.dart';

class AboutUsScreen extends StatefulWidget {
  static const routeName = '/about-us';

  const AboutUsScreen({super.key});
  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        title: const Text('About Us'),
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section with background image
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('assets/images/about_header.jpg'),
                  fit: BoxFit.cover,
                ),
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.3),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.videogame_asset,
                      size: 50,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Game Store',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Your Ultimate Gaming Destination',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),

            // Main Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mission Section
                  _buildSection(
                    context,
                    icon: Icons.flag,
                    title: 'Our Mission',
                    content:
                        'We strive to provide gamers with the best digital marketplace experience. Our platform offers a vast selection of games, competitive prices, and a vibrant community where gamers can connect and share their passion.',
                  ),
                  const SizedBox(height: 24),

                  // Vision Section
                  _buildSection(
                    context,
                    icon: Icons.visibility,
                    title: 'Our Vision',
                    content:
                        'To become the world\'s most trusted and innovative gaming platform, where every gamer finds their perfect adventure and builds lasting connections with fellow enthusiasts.',
                  ),
                  const SizedBox(height: 32),

                  // Stats Section
                  const Text(
                    'Our Impact',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          context,
                          number: '10M+',
                          label: 'Active Users',
                          icon: Icons.people,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          context,
                          number: '50K+',
                          label: 'Games',
                          icon: Icons.sports_esports,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          context,
                          number: '180+',
                          label: 'Countries',
                          icon: Icons.public,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          context,
                          number: '24/7',
                          label: 'Support',
                          icon: Icons.support_agent,
                          color: Colors.purple,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Team Section
                  const Text(
                    'Meet Our Team',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 240,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildTeamMember(
                          imagePath: 'assets/images/member1.jpg',
                          name: 'Axel',
                          role: 'CEO, Junior Developer & Founder',
                          githubUrl: 'https://github.com/hieuphampm',
                        ),
                        _buildTeamMember(
                          imagePath: 'assets/images/member2.jpg',
                          name: 'Peter-san🦅',
                          role: 'CTO, Junior Developer & Co-founder',
                          githubUrl: 'https://github.com/vina123baov',
                        ),
                        _buildTeamMember(
                          imagePath: 'assets/images/member3.jpg',
                          name: 'Sieuuuuuuuuuuu',
                          role: 'COO, Junior Developer & Co-founder',
                          githubUrl: 'https://github.com/saintsl4y3r',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Contact Section
                  const Text(
                    'Get in Touch',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(
                              Icons.email,
                              color: Colors.blue,
                            ),
                            title: const Text('Email'),
                            subtitle: const Text('support@gamestore.com'),
                            onTap: () {},
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(
                              Icons.phone,
                              color: Colors.green,
                            ),
                            title: const Text('Phone'),
                            subtitle: const Text('+1 (555) 123-4567'),
                            onTap: () {},
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(
                              Icons.location_on,
                              color: Colors.red,
                            ),
                            title: const Text('Address'),
                            subtitle: const Text(
                              '123 Gaming Street, Digital City, DC 12345',
                            ),
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Social Media Section
                  const Text(
                    'Follow Us',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildSocialButton(
                        icon: HugeIcons.strokeRoundedFacebook01,
                        color: Colors.blue[700]!,
                        onTap: () {},
                      ),
                      _buildSocialButton(
                        icon: HugeIcons.strokeRoundedTiktok,
                        color: Colors.purple,
                        onTap: () {},
                      ),
                      _buildSocialButton(
                        icon: HugeIcons.strokeRoundedDiscord,
                        color: Colors.red,
                        onTap: () {},
                      ),
                      _buildSocialButton(
                        icon: HugeIcons.strokeRoundedLinkedin02,
                        color: Colors.lightBlue,
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Version Info
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Game Store v2.5.0',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '© 2025 Game Store. All rights reserved.',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
  }) {
    final primary = Theme.of(context).primaryColor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(color: primary, shape: BoxShape.circle),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: TextStyle(fontSize: 16, color: Colors.grey[300], height: 1.5),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String number,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              number,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamMember({
    required String imagePath,
    required String name,
    required String role,
    required String githubUrl,
  }) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: const Color(0xFF1A1A1A),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(radius: 50, backgroundImage: AssetImage(imagePath)),
              const SizedBox(height: 12),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                role,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => _launchUrl(githubUrl),
                child: Image.asset(
                  'assets/images/github_logo.png',
                  width: 24,
                  height: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 30),
      ),
    );
  }

  void _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
