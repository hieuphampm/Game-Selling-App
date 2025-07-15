import 'package:flutter/material.dart';

class AchievementScreen extends StatelessWidget {
  static const routeName = '/achievement';
  AchievementScreen({super.key});

  final List<Map<String, dynamic>> achievements = [
    {
      'title': 'First Victory',
      'description': 'Win your first match',
      'icon': Icons.emoji_events,
      'completed': true,
      'progress': 100,
      'reward': '50 XP',
    },
    {
      'title': 'Collector',
      'description': 'Purchase 10 games',
      'icon': Icons.shopping_bag,
      'completed': true,
      'progress': 100,
      'reward': '100 XP',
    },
    {
      'title': 'Social Butterfly',
      'description': 'Add 20 friends',
      'icon': Icons.people,
      'completed': true,
      'progress': 100,
      'reward': '75 XP',
    },
    {
      'title': 'Marathon Gamer',
      'description': 'Play for a total of 100 hours',
      'icon': Icons.access_time_filled,
      'completed': false,
      'progress': 65,
      'reward': '200 XP',
    },
    {
      'title': 'Review Master',
      'description': 'Write 5 game reviews',
      'icon': Icons.rate_review,
      'completed': false,
      'progress': 40,
      'reward': '150 XP',
    },
    {
      'title': 'Legendary Player',
      'description': 'Reach level 50',
      'icon': Icons.star,
      'completed': false,
      'progress': 20,
      'reward': '500 XP',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.85,
        ),
        itemCount: achievements.length,
        itemBuilder: (context, index) {
          final achievement = achievements[index];
          return InkWell(
            onTap: () => _showAchievementDetail(context, achievement),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                gradient: achievement['completed']
                    ? LinearGradient(
                        colors: [Colors.amber.shade300, Colors.amber.shade100],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : LinearGradient(
                        colors: [Colors.grey.shade100, Colors.grey.shade200],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: const Offset(2, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: achievement['completed']
                            ? Colors.white.withOpacity(0.2)
                            : Colors.grey.withOpacity(0.15),
                      ),
                      child: Icon(
                        achievement['icon'],
                        size: 48,
                        color: achievement['completed']
                            ? Colors.amber.shade800
                            : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      achievement['title'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: achievement['completed']
                            ? Colors.black87
                            : Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      achievement['description'],
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    if (!achievement['completed']) ...[
                      LinearProgressIndicator(
                        value: achievement['progress'] / 100,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.blue.shade400,
                        ),
                        minHeight: 6,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${achievement['progress']}%',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ] else
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade600,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Completed',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    const SizedBox(height: 8),
                    Text(
                      achievement['reward'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.purple[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAchievementDetail(
    BuildContext context,
    Map<String, dynamic> achievement,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(
              achievement['icon'],
              color: achievement['completed'] ? Colors.amber[700] : Colors.grey,
              size: 30,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                achievement['title'],
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              achievement['description'],
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            if (!achievement['completed']) ...[
              const Text(
                'Progress',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: achievement['progress'] / 100,
                minHeight: 8,
              ),
              const SizedBox(height: 4),
              Text('${achievement['progress']}% Complete'),
            ] else ...[
              Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green[700]),
                  const SizedBox(width: 8),
                  Text(
                    'Achievement Unlocked!',
                    style: TextStyle(
                      color: Colors.green[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                const Text(
                  'Reward: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  achievement['reward'],
                  style: TextStyle(
                    color: Colors.purple[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
