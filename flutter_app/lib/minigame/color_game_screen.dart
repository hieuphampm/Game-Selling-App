import 'dart:math';
import 'package:flutter/material.dart';

// Palette (for UI elements)
const Color bgColor = Color(0xFF0D0D0D);
const Color blueAccentColor = Color(0xFF60D3F3);

class ColorMatchGameScreen extends StatefulWidget {
  static const routeName = '/color-match';
  const ColorMatchGameScreen({Key? key}) : super(key: key);

  @override
  _ColorMatchGameScreenState createState() => _ColorMatchGameScreenState();
}

class _ColorMatchGameScreenState extends State<ColorMatchGameScreen> {
  final Random _random = Random();
  int _level = 1;
  late int _gridSize;
  late Color _baseColor;
  late Color _oddColor;
  late int _oddIndex;

  @override
  void initState() {
    super.initState();
    _setupRound();
  }

  void _setupRound() {
    // Increase grid size up to 6×6
    _gridSize = min(2 + (_level ~/ 2), 6);
    // Generate a random base color
    final hue = _random.nextDouble() * 360;
    final lightness = 0.5;
    final saturation = 0.6;
    _baseColor = HSLColor.fromAHSL(1, hue, saturation, lightness).toColor();
    // Difference in lightness shrinks as level increases
    final delta = (0.2 - (_level - 1) * 0.02).clamp(0.02, 0.2);
    final oddLightness =
        (lightness + (_random.nextBool() ? delta : -delta)).clamp(0.0, 1.0);
    _oddColor = HSLColor.fromAHSL(1, hue, saturation, oddLightness).toColor();
    // Choose random position for odd color
    _oddIndex = _random.nextInt(_gridSize * _gridSize);
  }

  void _onTileTap(int index) {
    if (index == _oddIndex) {
      // correct
      setState(() {
        _level++;
        _setupRound();
      });
    } else {
      // game over
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: bgColor,
          title: const Text('Game Over', style: TextStyle(color: Colors.white)),
          content: Text(
            'You reached level $_level.',
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _level = 1;
                  _setupRound();
                });
              },
              child: const Text('Restart',
                  style: TextStyle(color: Colors.blueAccent)),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tiles = List.generate(_gridSize * _gridSize, (i) {
      return GestureDetector(
        onTap: () => _onTileTap(i),
        child: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: i == _oddIndex ? _oddColor : _baseColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      );
    });

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Color Game', style: TextStyle(color: Colors.black)),
        backgroundColor: blueAccentColor,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                'Level $_level',
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: 1,
          child: GridView.count(
            padding: const EdgeInsets.all(16),
            crossAxisCount: _gridSize,
            children: tiles,
          ),
        ),
      ),
    );
  }
}
