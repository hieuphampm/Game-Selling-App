import 'package:flutter/material.dart';

class CommunityScreen extends StatefulWidget {
  static const routeName = '/community';

  static Map<String, WidgetBuilder> routes = {
    CommunityScreen.routeName: (_) => const CommunityScreen(),
    AddFriendScreen.routeName: (_) => const AddFriendScreen(),
    JoinGroupScreen.routeName: (_) => const JoinGroupScreen(),
    GiftScreen.routeName: (_) => const GiftScreen(),
    QuestScreen.routeName: (_) => const QuestScreen(),
  };

  const CommunityScreen({super.key});

  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
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
        title: const Text(
          'Community',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
            shadows: [
              Shadow(
                color: Colors.black45,
                offset: Offset(1, 1),
                blurRadius: 2,
              ),
            ],
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
                          offset: Offset(0, 4),
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
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      shadows: [
                        Shadow(
                          color: Colors.black54,
                          offset: Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'This is where you can find people with the same hobby and desire!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
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
                  label: 'Add Friend',
                  icon: Icons.person_add_alt_1,
                  backgroundColor: _cardColors[0],
                  onTap: () =>
                      Navigator.pushNamed(context, AddFriendScreen.routeName),
                ),
                _OptionCard(
                  label: 'Join Group',
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
                  label: 'Quests',
                  icon: Icons.emoji_events,
                  backgroundColor: _cardColors[3],
                  onTap: () =>
                      Navigator.pushNamed(context, QuestScreen.routeName),
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
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
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
  const AddFriendScreen({super.key});

  final List<String> friends = const [
    'Alice',
    'Bob',
    'Charlie',
    'Diana',
    'Eve',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        title: const Text(
          'Add Friend',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Search Friends',
                labelStyle: TextStyle(color: Colors.white54),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: friends.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => Card(
                  color: const Color(0xFF1A1A1A),
                  child: ListTile(
                    title: Text(
                      friends[i],
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: const Icon(
                      Icons.circle,
                      color: Colors.green,
                      size: 12,
                    ),
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
  const JoinGroupScreen({super.key});

  // Sample list of joined groups
  final List<String> groups = const [
    'Flutter Knights',
    'Kotlin Lovers',
    'Swift Play',
    'Firebase Buddies',
    'COCOAPODS Fans',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        title: const Text(
          'Join Group',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Search Groups',
                labelStyle: TextStyle(color: Colors.white54),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: groups.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => Card(
                  color: const Color(0xFF1A1A1A),
                  child: ListTile(
                    title: Text(
                      groups[i],
                      style: const TextStyle(color: Colors.white),
                    ),
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
  const GiftScreen({super.key});

  final List<String> redeemedGifts = const [
    'SUMMER2025',
    'WELCOME50',
    'FLUTTERLOVE',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        title: const Text(
          'Gift',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Enter Gift Code',
                labelStyle: TextStyle(color: Colors.white54),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                /* TODO: redeem logic */
              },
              child: const Text('Redeem'),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                itemCount: redeemedGifts.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => Card(
                  color: const Color(0xFF1A1A1A),
                  child: ListTile(
                    leading: const Icon(
                      Icons.check_circle,
                      color: Colors.white70,
                    ),
                    title: Text(
                      redeemedGifts[i],
                      style: const TextStyle(color: Colors.white),
                    ),
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

class Quest {
  final String title;
  final String description;
  final bool requiresFriend;

  const Quest({
    required this.title,
    required this.description,
    this.requiresFriend = false,
  });
}

class QuestScreen extends StatelessWidget {
  static const routeName = '/quests';
  const QuestScreen({super.key});

  final List<Quest> quests = const [
    Quest(
      title: 'Daily Login Bonus',
      description: 'Log in every day to receive 50 coins.',
      requiresFriend: false,
    ),
    Quest(
      title: 'Win 3 Matches',
      description: 'Win 3 solo matches in any mode.',
      requiresFriend: false,
    ),
    Quest(
      title: 'Invite a Friend',
      description: 'Invite a friend to the game for mutual rewards.',
      requiresFriend: true,
    ),
    Quest(
      title: 'Post in Community',
      description: 'Share a tip or question in the community group.',
      requiresFriend: false,
    ),
    Quest(
      title: 'Team Battle',
      description: 'Join and win a team match with friends.',
      requiresFriend: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        title: const Text(
          'Quests',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          itemCount: quests.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, i) {
            final quest = quests[i];
            return Card(
              color: const Color(0xFF1A1A1A),
              child: ListTile(
                title: Text(
                  quest.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  quest.description,
                  style: const TextStyle(color: Colors.white70),
                ),
                trailing: Icon(
                  quest.requiresFriend ? Icons.group : Icons.person,
                  color: quest.requiresFriend
                      ? Colors.blueAccent
                      : Colors.greenAccent,
                ),
                onTap: () {
                  // TODO: handle quest selection
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
