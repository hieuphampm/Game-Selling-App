import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class AIChat extends StatefulWidget {
  static const String routeName = '/ai-chat';

  static Route<void> route() {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const AIChat(),
    );
  }

  const AIChat({super.key});

  @override
  State<AIChat> createState() => _AIChatState();
}

class _AIChatState extends State<AIChat> {
  Gemini? gemini;
  String result = '';
  bool isLoading = false;

  final List<String> games = [
    "The Last of Us: an emotional zombie survival game with deep characters.",
    "God of War: a mythological action-adventure with Kratos and Atreus.",
    "Hollow Knight: a Metroidvania game with challenging combat and exploration.",
    "Elden Ring: a dark fantasy open world action RPG by FromSoftware.",
    "Stardew Valley: a farming and life simulation game full of charm.",
  ];

  Future<void> loadGemini() async {
    if (!dotenv.isInitialized) {
      await dotenv.load(fileName: ".env");
    }

    final apiKey = dotenv.env['API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception("API key not found in .env file");
    }

    gemini = Gemini.init(apiKey: apiKey);
  }

  Future<void> summarizeGames() async {
    setState(() {
      isLoading = true;
      result = '';
    });

    try {
      if (gemini == null) {
        await loadGemini();
      }

      final prompt =
          '''
You are an AI game reviewer. Please summarize the following games into a short paragraph, highlighting their genre, gameplay, and style:

${games.join('\n')}
''';

      final response = await gemini!.text(prompt);
      setState(() {
        result = response?.output ?? 'No summary generated.';
      });
    } catch (e) {
      setState(() {
        result = 'Error: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🎮 AI Game Summary')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: isLoading ? null : summarizeGames,
              icon: const Icon(Icons.auto_awesome),
              label: const Text("Summarize Games"),
            ),
            const SizedBox(height: 20),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (result.isNotEmpty)
              Expanded(
                child: SingleChildScrollView(
                  child: Text(result, style: const TextStyle(fontSize: 16)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
