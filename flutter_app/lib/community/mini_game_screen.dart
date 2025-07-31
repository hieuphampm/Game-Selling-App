import 'package:flutter/material.dart';
import '../minigame/snake_screen.dart';
import '../minigame/tetris_screen.dart';
import '../minigame/plane_shooter_screen.dart';
import '../minigame/quizz_screen.dart';
import '../minigame/chess_screen.dart';
import '../minigame/color_game_screen.dart';

// Palette
const Color bgColor = Color(0xFF0D0D0D);
const Color pinkLight = Color(0xFFFFD9F5);
const Color blueAccentColor = Color(0xFF60D3F3);
const Color pinkAccentColor = Color(0xFFFAB4E5);

class MiniGameScreen extends StatelessWidget {
  const MiniGameScreen({Key? key}) : super(key: key);

  void _open(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    final games = <_GameOption>[
      _GameOption('Snake', Icons.android, const SnakeGameScreen(), pinkLight),
      _GameOption(
          'Tetris', Icons.grid_view, const TetrisGameScreen(), blueAccentColor),
      _GameOption('Plane Shooter', Icons.airplanemode_active,
          const PlaneShooterScreen(), pinkAccentColor),
      _GameOption('Quiz', Icons.quiz, const QuizGameScreen(), pinkLight),
      _GameOption(
          'Chess', Icons.casino, const ChessGameScreen(), blueAccentColor),
      _GameOption('Color Match', Icons.color_lens, const ColorMatchGameScreen(),
          pinkAccentColor),
    ];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Mini Games', style: TextStyle(color: Colors.black)),
        backgroundColor: blueAccentColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1,
          children: games.map((g) {
            return Card(
              color: g.color,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => _open(context, g.screen),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(g.icon, size: 40, color: Colors.white),
                      const SizedBox(height: 8),
                      Text(
                        g.label,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _GameOption {
  final String label;
  final IconData icon;
  final Widget screen;
  final Color color;
  const _GameOption(this.label, this.icon, this.screen, this.color);
}
