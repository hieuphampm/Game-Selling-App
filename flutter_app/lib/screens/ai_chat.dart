import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class AIChat extends StatefulWidget {
  const AIChat({super.key});

  @override
  State<AIChat> createState() => _AIChatState();
}

class _AIChatState extends State<AIChat> {
  final Gemini gemini = Gemini.init(
    apiKey: 'AIzaSyChgARKLloeKbo4UsWcYyDdDS7wKe7hpCs',
  );

  final List<String> games = [
    "The Last of Us: an emotional zombie survival game with deep characters.",
    "God of War: a mythological action-adventure with Kratos and Atreus.",
    "Hollow Knight: a Metroidvania game with challenging combat and exploration.",
    "Elden Ring: a dark fantasy open world action RPG by FromSoftware.",
    "Stardew Valley: a farming and life simulation game full of charm.",
  ];

  String result = '';
  bool isLoading = false;

  Future<void> summarizeGames() async {
    setState(() {
      isLoading = true;
      result = '';
    });

    final prompt = '''
You are an AI game reviewer. Please summarize the following games into a short paragraph, highlighting their genre, gameplay, and style:

${games.join('\n')}
''';

    try {
      final response = await gemini.text(prompt);
      setState(() {
        result = response?.output ?? 'No summary generated.';
      });
    } catch (e) {
      setState(() {
        result = 'Error: $e';
      });
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🧠 AI Game Summary')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: summarizeGames,
              icon: const Icon(Icons.smart_toy),
              label: const Text('Summarize Games'),
            ),
            const SizedBox(height: 20),
            if (isLoading)
              const CircularProgressIndicator()
            else
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    result,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
