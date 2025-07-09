import 'package:flutter/material.dart';

class NewsScreen extends StatelessWidget {
  NewsScreen({super.key});

  final List<Map<String, String>> newsList = [
    {
      'title': 'New RPG Game Released!',
      'subtitle':
          'Experience the ultimate fantasy adventure with stunning graphics',
      'date': '2 hours ago',
      'category': 'New Release',
    },
    {
      'title': 'Summer Sale Starts Tomorrow',
      'subtitle': 'Get up to 70% off on selected titles. Don\'t miss out!',
      'date': '5 hours ago',
      'category': 'Sale',
    },
    {
      'title': 'Game Update 2.5 Available',
      'subtitle': 'New maps, characters, and bug fixes for Adventure Quest',
      'date': '1 day ago',
      'category': 'Update',
    },
    {
      'title': 'Esports Tournament 2024',
      'subtitle': 'Join the biggest gaming tournament with \$1M prize pool',
      'date': '2 days ago',
      'category': 'Event',
    },
    {
      'title': 'Developer Interview: Behind the Scenes',
      'subtitle': 'Learn about the making of the year\'s best indie game',
      'date': '3 days ago',
      'category': 'Interview',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12.0),
      itemCount: newsList.length,
      itemBuilder: (context, index) {
        final news = newsList[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Opening: ${news['title']}'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                children: [
                  // Image Placeholder
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [Colors.grey.shade300, Colors.grey.shade200],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Icon(
                      Icons.image,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getCategoryColor(
                              news['category']!,
                            ).withOpacity(0.9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            news['category']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          news['title']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          news['subtitle']!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: Colors.grey[500],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              news['date']!,
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static Color _getCategoryColor(String category) {
    switch (category) {
      case 'New Release':
        return Colors.blueAccent;
      case 'Sale':
        return Colors.redAccent;
      case 'Update':
        return Colors.green;
      case 'Event':
        return Colors.purple;
      case 'Interview':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
