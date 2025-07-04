import 'package:flutter/material.dart';

class AIProfile {
  final String id;
  final String name;
  final String avatarUrl;
  final String description;

  AIProfile({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.description,
  });
}

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';

  final List<AIProfile> _aiProfiles = [
    AIProfile(
      id: 'ai1',
      name: 'Lily - Chuyên viên HR',
      avatarUrl: 'https://i.pravatar.cc/150?img=32',
      description: 'Phỏng vấn kỹ năng mềm và văn hoá công ty.',
    ),
    AIProfile(
      id: 'ai2',
      name: 'Max - Kỹ sư Phần mềm',
      avatarUrl: 'https://i.pravatar.cc/150?img=12',
      description: 'Phỏng vấn chuyên sâu về lập trình Dart/Flutter.',
    ),
    AIProfile(
      id: 'ai3',
      name: 'Sophia - Quản lý Dự án',
      avatarUrl: 'https://i.pravatar.cc/150?img=48',
      description: 'Phỏng vấn về quản lý dự án và Agile.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chọn em AI phỏng vấn'), centerTitle: true),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        itemCount: _aiProfiles.length,
        itemBuilder: (ctx, i) {
          final ai = _aiProfiles[i];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(ai.avatarUrl),
              ),
              title: Text(
                ai.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(ai.description),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // TODO: Đưa vào màn InterviewScreen, truyền ai.id hoặc toàn bộ ai
                Navigator.of(context).pushNamed('/interview', arguments: ai);
              },
            ),
          );
        },
      ),
    );
  }
}
