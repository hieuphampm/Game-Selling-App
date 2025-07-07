import 'package:flutter/material.dart';

class MobileNewsScreen extends StatelessWidget {
  static const routeName = '/mobile-news';
  const MobileNewsScreen({super.key});

  final List<_NewsSection> sections = const [
    _NewsSection(
      dateLabel: 'TODAY',
      items: [
        _NewsItem(
          title: 'Version 1.2.0 Released',
          subtitle: 'Major Update · Jul 10',
          imageUrl: 'https://via.placeholder.com/120x60?text=1.2.0',
          likes: 523,
          comments: 34,
        ),
      ],
    ),
    _NewsSection(
      dateLabel: 'YESTERDAY',
      items: [
        _NewsItem(
          title: 'Summer Event Live Now',
          subtitle: 'Limited Time Event · Jul 9',
          imageUrl: 'https://via.placeholder.com/120x60?text=Event',
          likes: 1240,
          comments: 98,
        ),
        _NewsItem(
          title: 'Maintenance Completed',
          subtitle: 'Server Update · Jul 9',
          imageUrl: 'https://via.placeholder.com/120x60?text=Up',
          likes: 310,
          comments: 12,
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: Row(
        children: [
          // ──────── Side navigation ────────
          Container(
            width: 200,
            color: const Color(0xFF1A1A1A),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'MOBILE\nGAME NEWS',
                      style: TextStyle(
                        color: Color(0xFFFFD9F5),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  _SideSection(
                    title: 'UPDATES',
                    subtitle: 'Latest Patches',
                    selected: true,
                    accent: const Color(0xFF60D3F3),
                  ),
                  _SideSection(
                    title: 'EVENTS',
                    subtitle: 'Current & Upcoming',
                    accent: const Color(0xFFFAB4E5),
                  ),
                  _SideSection(title: 'OFFICIAL', subtitle: 'Developer News'),
                  _SideSection(title: 'COMMUNITY', subtitle: 'Fan Posts'),
                ],
              ),
            ),
          ),

          // ──────── Main content ────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: ListView.builder(
                itemCount: sections.length,
                itemBuilder: (ctx, si) {
                  final section = sections[si];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        section.dateLabel,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...section.items.map((item) => _NewsCard(item: item)),
                      const SizedBox(height: 24),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SideSection extends StatelessWidget {
  final String title, subtitle;
  final bool selected;
  final Color? accent;

  const _SideSection({
    required this.title,
    required this.subtitle,
    this.selected = false,
    this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final Color baseColor = selected
        ? accent ?? Theme.of(context).colorScheme.primary
        : Colors.white70;
    return ListTile(
      dense: true,
      selected: selected,
      selectedTileColor: Colors.white12,
      title: Text(title, style: TextStyle(color: baseColor)),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: baseColor.withOpacity(0.7), fontSize: 12),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      onTap: () {},
    );
  }
}

class _NewsSection {
  final String dateLabel;
  final List<_NewsItem> items;
  const _NewsSection({required this.dateLabel, required this.items});
}

class _NewsItem {
  final String title, subtitle, imageUrl;
  final int likes, comments;
  const _NewsItem({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.likes,
    required this.comments,
  });
}

class _NewsCard extends StatelessWidget {
  final _NewsItem item;
  const _NewsCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1E1E1E),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Text info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.subtitle,
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.thumb_up,
                        size: 16,
                        color: const Color(0xFF60D3F3),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.likes.toString(),
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.comment,
                        size: 16,
                        color: const Color(0xFFFAB4E5),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.comments.toString(),
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                item.imageUrl,
                width: 120,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
