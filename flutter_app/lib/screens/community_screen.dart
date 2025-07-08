import 'package:flutter/material.dart';

class CommunityScreen extends StatelessWidget {
  static const routeName = '/community';

  final _cardColors = const [
    Color(0xFFFFD9F5),
    Color(0xFF60D3F3),
    Color(0xFFFAB4E5),
    Color(0xFFFFD9F5),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        title: const Text('Community'),
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withOpacity(0.7),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.group,
                      size: 40,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Game Community',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'This is where you can find people with the same hobby and desire!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1,
              children: [
                _OptionCard(
                  label: 'Add friend',
                  icon: Icons.person_add_alt_1,
                  backgroundColor: _cardColors[0],
                  onTap: () =>
                      Navigator.pushNamed(context, AddFriendScreen.routeName),
                ),
                _OptionCard(
                  label: 'Join group',
                  icon: Icons.group_add,
                  backgroundColor: _cardColors[1],
                  onTap: () =>
                      Navigator.pushNamed(context, JoinGroupScreen.routeName),
                ),
                _OptionCard(
                  label: 'Gift',
                  icon: Icons.card_giftcard,
                  backgroundColor: _cardColors[2],
                  onTap: () =>
                      Navigator.pushNamed(context, GiftScreen.routeName),
                ),
                _OptionCard(
                  label: 'Activities with Friends!',
                  icon: Icons.emoji_events,
                  backgroundColor: _cardColors[3],
                  onTap: () =>
                      Navigator.pushNamed(context, ActivitiesScreen.routeName),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final VoidCallback onTap;

  const _OptionCard({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40, color: Colors.white),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddFriendScreen extends StatelessWidget {
  static const routeName = '/add-friend';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        title: const Text('Community'),
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Add friend',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Enter User ID',
                labelStyle: TextStyle(color: Colors.white54),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: 5,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class JoinGroupScreen extends StatelessWidget {
  static const routeName = '/join-group';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        title: const Text('Community'),
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Join Group',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Enter Groupname',
                labelStyle: TextStyle(color: Colors.white54),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: 5,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GiftScreen extends StatelessWidget {
  static const routeName = '/gift';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        title: const Text('Community'),
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Gift',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Enter Giftcode',
                labelStyle: TextStyle(color: Colors.white54),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActivitiesScreen extends StatelessWidget {
  static const routeName = '/activities';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        title: const Text('Community'),
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Activities with Friends!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: 5,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
