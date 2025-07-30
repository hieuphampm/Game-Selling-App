import 'package:flutter/material.dart';
import '../community/add_friend_screen.dart';
import '../community/gift_screen.dart';
import '../community/join_group_screen.dart';
import '../community/quest_screen.dart';

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
            // … phần header giữ nguyên …
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
