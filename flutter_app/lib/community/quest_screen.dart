import 'package:flutter/material.dart';

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
    ),
    Quest(
      title: 'Invite a Friend',
      description: 'Invite a friend to the game for mutual rewards.',
      requiresFriend: true,
    ),
    Quest(
      title: 'Post in Community',
      description: 'Share a tip or question in the community group.',
    ),
    Quest(
      title: 'Watch an AD',
      description: 'Watch an AD to get 50 coins!',
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
