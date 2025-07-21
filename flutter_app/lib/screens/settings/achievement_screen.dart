// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class AchievementScreen extends StatelessWidget {
  static const routeName = '/achievement';
  const AchievementScreen({super.key});

  final List<Map<String, dynamic>> achievements = const [
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
      'description': 'Play a total of 100 hours',
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
      appBar: AppBar(
        title: const Text('Achievements'),
        leading: const BackButton(),
      ),
      body: SafeArea(
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.75, // Adjusted for more vertical space
          ),
          itemCount: achievements.length,
          itemBuilder: (context, index) {
            final ach = achievements[index];
            return InkWell(
              onTap: () => _showAchievementDetail(context, ach),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                decoration: BoxDecoration(
                  gradient: ach['completed']
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
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(2, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0), // Reduced padding
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ach['completed']
                              ? Colors.white.withOpacity(0.2)
                              : Colors.grey.withOpacity(0.15),
                        ),
                        child: Icon(
                          ach['icon'],
                          size: 40, // Reduced icon size
                          color: ach['completed']
                              ? Colors.amber.shade800
                              : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Flexible(
                        child: Text(
                          ach['title'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14, // Reduced font size
                            color: ach['completed']
                                ? Colors.black87
                                : Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Flexible(
                        child: Text(
                          ach['description'],
                          style: TextStyle(
                              fontSize: 10, // Reduced font size
                              color: Colors.grey[500]),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 6),
                      if (!ach['completed']) ...[
                        LinearProgressIndicator(
                          value: ach['progress'] / 100,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.blue.shade400,
                          ),
                          minHeight: 4, // Reduced height
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${ach['progress']}%',
                          style:
                              TextStyle(fontSize: 10, color: Colors.grey[600]),
                        ),
                      ] else
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade600,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'Completed',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      const SizedBox(height: 6),
                      Text(
                        ach['reward'],
                        style: TextStyle(
                          fontSize: 12,
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
      ),
    );
  }

  void _showAchievementDetail(
    BuildContext context,
    Map<String, dynamic> achievement,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(
              achievement['icon'],
              color: achievement['completed'] ? Colors.amber[700] : Colors.grey,
              size: 28,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                achievement['title'],
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.4, // Limit height
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement['description'],
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 12),
                if (!achievement['completed']) ...[
                  const Text(
                    'Progress',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: achievement['progress'] / 100,
                    minHeight: 6,
                  ),
                  const SizedBox(height: 4),
                  Text('${achievement['progress']}% completed'),
                ] else ...[
                  Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green[700]),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Achievement Unlocked!',
                          style: TextStyle(
                            color: Colors.green[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                ],
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text(
                      'Reward: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Text(
                        achievement['reward'],
                        style: TextStyle(
                          color: Colors.purple[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}