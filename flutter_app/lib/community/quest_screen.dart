import 'package:flutter/material.dart';

// Palette
const Color bgColor = Color(0xFF0D0D0D);
const Color pinkLight = Color(0xFFFFD9F5);
const Color blueAccentColor = Color(0xFF60D3F3);
const Color pinkAccentColor = Color(0xFFFAB4E5);

class Quest {
  final String title;
  final String description;
  final bool requiresFriend;
  final int coin;
  const Quest({
    required this.title,
    required this.description,
    this.requiresFriend = false,
    required this.coin,
  });
}

class QuestItem {
  final Quest quest;
  bool isStarted = false;
  bool isCompleted = false;
  bool isClaimed = false;
  QuestItem(this.quest);
}

class QuestScreen extends StatefulWidget {
  static const routeName = '/quests';
  const QuestScreen({Key? key}) : super(key: key);
  @override
  _QuestScreenState createState() => _QuestScreenState();
}

class _QuestScreenState extends State<QuestScreen> {
  late List<QuestItem> _dailyItems;
  late List<QuestItem> _otherItems;

  @override
  void initState() {
    super.initState();
    final all = const [
      Quest(
        title: 'Daily Login Bonus',
        description: 'Log in every day to receive 50 coins.',
        coin: 50,
      ),
      Quest(
        title: 'Invite a Friend',
        description: 'Invite a friend to the game for mutual rewards.',
        requiresFriend: true,
        coin: 100,
      ),
      Quest(
        title: 'Post in Community',
        description: 'Share a tip or question in the community group.',
        coin: 30,
      ),
      Quest(
        title: 'Watch an AD',
        description: 'Watch an AD to get 50 coins!',
        coin: 50,
      ),
    ].map((q) => QuestItem(q)).toList();

    _dailyItems =
        all.where((i) => i.quest.title == 'Daily Login Bonus').toList();
    _otherItems =
        all.where((i) => i.quest.title != 'Daily Login Bonus').toList();

    for (var item in _dailyItems) {
      item.isStarted = true;
      item.isCompleted = true;
    }
  }

  void _claimReward(QuestItem item, bool isDaily) {
    setState(() => item.isClaimed = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              'You got ${item.quest.coin} coins for "${item.quest.title}"!')),
    );
    setState(() {
      if (isDaily)
        _dailyItems.remove(item);
      else
        _otherItems.remove(item);
    });
  }

  void _startQuest(QuestItem item) {
    setState(() => item.isStarted = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Quest "${item.quest.title}" started!')),
    );
    Future.delayed(const Duration(seconds: 3), () {
      setState(() => item.isCompleted = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Quest "${item.quest.title}" completed!')),
      );
    });
  }

  void _showDetail(Quest q) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: bgColor,
        title: Text(q.title, style: const TextStyle(color: Colors.white)),
        content:
            Text(q.description, style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          )
        ],
      ),
    );
  }

  Widget _buildSection(String header, List<QuestItem> list, bool isDaily) {
    if (list.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(header, style: const TextStyle(color: Colors.white, fontSize: 18)),
        const SizedBox(height: 8),
        ...list.map((item) {
          final q = item.quest;
          final label = isDaily
              ? 'Claim Reward'
              : (!item.isStarted
                  ? 'Start'
                  : (item.isCompleted ? 'Claim Reward' : 'In Progress'));
          final enabled = item.isCompleted && !item.isClaimed;
          return Card(
            color: pinkLight,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => _showDetail(q),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Row(
                  children: [
                    Icon(
                      q.requiresFriend ? Icons.group : Icons.person,
                      color:
                          q.requiresFriend ? blueAccentColor : pinkAccentColor,
                      size: 32,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(q.title,
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.monetization_on,
                                color: Colors.amber),
                            const SizedBox(width: 4),
                            Text('${q.coin}',
                                style: const TextStyle(
                                    color: Colors.amber,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 32,
                          child: ElevatedButton(
                            onPressed: enabled
                                ? () {
                                    if (isDaily || item.isCompleted) {
                                      _claimReward(item, isDaily);
                                    } else {
                                      _startQuest(item);
                                    }
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: enabled ? blueAccentColor : null,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              minimumSize: const Size(0, 32),
                            ),
                            child: Text(label,
                                style: const TextStyle(fontSize: 12)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
        const SizedBox(height: 24),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Quests', style: TextStyle(color: Colors.white)),
        backgroundColor: blueAccentColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _buildSection('Daily Quests', _dailyItems, true),
            _buildSection('Other Quests', _otherItems, false),
            if (_dailyItems.isEmpty && _otherItems.isEmpty)
              const Center(
                  child: Text('No more quests!',
                      style: TextStyle(color: Colors.white70))),
          ],
        ),
      ),
    );
  }
}
