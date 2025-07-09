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
  final TextEditingController _controller = TextEditingController();

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

  Future<void> getGameSummary() async {
    final userInput = _controller.text.trim();

    if (userInput.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a game name or question')),
      );
      return;
    }

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
You are an AI game expert and reviewer. The user is asking about: "$userInput"

Please provide a helpful response about the game(s) they mentioned. If they're asking for:
- A game summary: Provide details about genre, gameplay, story, and what makes it special
- Game recommendations: Suggest similar games with brief descriptions
- Game comparison: Compare the games they mentioned
- General game questions: Answer their specific question about gaming

Be informative, engaging, and helpful in your response.
''';

      final response = await gemini!.text(prompt);
      setState(() {
        result = response?.output ?? 'No response generated.';
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0d0d0d),
      appBar: AppBar(
        title: const Text('🎮 AI Game Chat'),
        backgroundColor: const Color(0xFF60d3f3),
        foregroundColor: const Color(0xFF0d0d0d),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              color: const Color(0xFFffd9f5),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ask me about games!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0d0d0d),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Examples: "Tell me about Elden Ring", "Games similar to Stardew Valley", "Best RPGs of 2023"',
                      style: TextStyle(fontSize: 14, color: Color(0xFF0d0d0d)),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _controller,
                      style: const TextStyle(color: Color(0xFF0d0d0d)),
                      decoration: const InputDecoration(
                        hintText: 'Enter your game question or game name...',
                        hintStyle: TextStyle(color: Color(0xFF0d0d0d)),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Color(0xFF0d0d0d),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF60d3f3),
                            width: 2,
                          ),
                        ),
                      ),
                      maxLines: 2,
                      onSubmitted: (_) => getGameSummary(),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: isLoading ? null : getGameSummary,
                      icon: const Icon(Icons.auto_awesome),
                      label: Text(isLoading ? 'Getting Response...' : 'Ask AI'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF60d3f3),
                        foregroundColor: const Color(0xFF0d0d0d),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (isLoading)
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(color: Color(0xFF60d3f3)),
                    SizedBox(height: 20),
                    Text(
                      'AI is thinking...',
                      style: TextStyle(color: Color(0xFFffd9f5)),
                    ),
                  ],
                ),
              )
            else if (result.isNotEmpty)
              Expanded(
                child: Card(
                  elevation: 4,
                  color: const Color(0xFFfab4e5),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.smart_toy, color: Colors.black38),
                            const SizedBox(width: 8),
                            const Text(
                              'AI Response:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Text(
                              result,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
