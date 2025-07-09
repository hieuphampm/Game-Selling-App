// screens/about_us_screen.dart
import 'package:flutter/material.dart';

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
      appBar: AppBar(title: const Text('About Us'), elevation: 0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withOpacity(0.7),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  // Logo
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

            // About Content
            Padding(
              padding: const EdgeInsets.all(20.0),
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
                    height: 200,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildTeamMember(
                          name: 'Pham Phuoc Minh Hieu',
                          role: 'CEO & Founder',
                          color: Colors.blue,
                        ),
                        _buildTeamMember(
                          name: 'Vo Huynh Thai Bao',
                          role: 'CTO',
                          color: Colors.pink,
                        ),
                        _buildTeamMember(
                          name: 'Cao Sy Sieu',
                          role: 'Head of Design',
                          color: Colors.green,
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
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(
                              Icons.email,
                              color: Colors.blue,
                            ),
                            title: const Text('Email'),
                            subtitle: const Text('support@gamestore.com'),
                            onTap: () {
                              // Open email
                            },
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(
                              Icons.phone,
                              color: Colors.green,
                            ),
                            title: const Text('Phone'),
                            subtitle: const Text('+1 (555) 123-4567'),
                            onTap: () {
                              // Make phone call
                            },
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
                            onTap: () {
                              // Open maps
                            },
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
                        icon: Icons.facebook,
                        color: Colors.blue[700]!,
                        onTap: () {},
                      ),
                      _buildSocialButton(
                        icon: Icons.camera_alt,
                        color: Colors.purple,
                        onTap: () {},
                      ),
                      _buildSocialButton(
                        icon: Icons.videocam,
                        color: Colors.red,
                        onTap: () {},
                      ),
                      _buildSocialButton(
                        icon: Icons.chat,
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
                          '© 2024 Game Store. All rights reserved.',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
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
          style: TextStyle(fontSize: 16, color: Colors.grey[700], height: 1.5),
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
        padding: const EdgeInsets.all(16.0),
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
    required String name,
    required String role,
    required Color color,
  }) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: color.withOpacity(0.2),
                child: Text(
                  name.split(' ').map((e) => e[0]).join(),
                  style: TextStyle(
                    color: color,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                role,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
                textAlign: TextAlign.center,
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
}
