import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

// Palette
const Color bgColor = Color(0xFF0D0D0D);
const Color pinkLight = Color(0xFFFFD9F5);
const Color blueAccentColor = Color(0xFF60D3F3);
const Color pinkAccentColor = Color(0xFFFAB4E5);

class PlaneShooterScreen extends StatefulWidget {
  static const routeName = '/plane-shooter';
  const PlaneShooterScreen({Key? key}) : super(key: key);

  @override
  _PlaneShooterScreenState createState() => _PlaneShooterScreenState();
}

class _PlaneShooterScreenState extends State<PlaneShooterScreen> {
  static const double planeWidth = 40;
  static const double planeHeight = 40;
  static const double bulletWidth = 4;
  static const double bulletHeight = 10;
  static const double enemySize = 30;
  static const int spawnIntervalMs = 800;
  static const int gameTickMs = 16; // ~60 FPS

  late double screenWidth;
  late double screenHeight;

  // Player plane position
  Offset planePos = Offset.zero;

  // Bullets and enemies
  final List<Offset> bullets = [];
  final List<Offset> enemies = [];

  int score = 0;
  Timer? _spawnTimer;
  Timer? _gameLoopTimer;
  final _random = Random();

  @override
  void initState() {
    super.initState();
    // Start when layout known
    WidgetsBinding.instance.addPostFrameCallback((_) {
      screenWidth = context.size!.width;
      screenHeight = context.size!.height - kToolbarHeight;
      planePos = Offset(
          screenWidth / 2 - planeWidth / 2, screenHeight - planeHeight - 20);
      _startGame();
    });
  }

  @override
  void dispose() {
    _spawnTimer?.cancel();
    _gameLoopTimer?.cancel();
    super.dispose();
  }

  void _startGame() {
    _spawnTimer =
        Timer.periodic(const Duration(milliseconds: spawnIntervalMs), (_) {
      // spawn at random x
      final x = _random.nextDouble() * (screenWidth - enemySize);
      enemies.add(Offset(x, -enemySize));
    });
    _gameLoopTimer = Timer.periodic(
        const Duration(milliseconds: gameTickMs), (_) => _update());
  }

  void _update() {
    // Move bullets up
    for (int i = bullets.length - 1; i >= 0; i--) {
      bullets[i] = bullets[i].translate(0, -8);
      if (bullets[i].dy < -bulletHeight) bullets.removeAt(i);
    }
    // Move enemies down
    for (int i = enemies.length - 1; i >= 0; i--) {
      enemies[i] = enemies[i].translate(0, 3);
      if (enemies[i].dy > screenHeight) enemies.removeAt(i);
    }
    // Collisions
    for (int ei = enemies.length - 1; ei >= 0; ei--) {
      final e = enemies[ei];
      for (int bi = bullets.length - 1; bi >= 0; bi--) {
        final b = bullets[bi];
        final rectE = Rect.fromLTWH(e.dx, e.dy, enemySize, enemySize);
        final rectB = Rect.fromLTWH(b.dx, b.dy, bulletWidth, bulletHeight);
        if (rectE.overlaps(rectB)) {
          enemies.removeAt(ei);
          bullets.removeAt(bi);
          score += 10;
          break;
        }
      }
    }
    setState(() {});
  }

  void _fireBullet() {
    final bulletX = planePos.dx + planeWidth / 2 - bulletWidth / 2;
    final bulletY = planePos.dy - bulletHeight;
    bullets.add(Offset(bulletX, bulletY));
  }

  void _onHorizontalDrag(DragUpdateDetails d) {
    setState(() {
      double newX = planePos.dx + d.delta.dx;
      if (newX < 0) newX = 0;
      if (newX > screenWidth - planeWidth) newX = screenWidth - planeWidth;
      planePos = Offset(newX, planePos.dy);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title:
            const Text('Plane Shooter', style: TextStyle(color: Colors.black)),
        backgroundColor: blueAccentColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: () {
              setState(() {
                bullets.clear();
                enemies.clear();
                score = 0;
                _spawnTimer?.cancel();
                _gameLoopTimer?.cancel();
                _startGame();
              });
            },
          )
        ],
      ),
      body: GestureDetector(
        onHorizontalDragUpdate: _onHorizontalDrag,
        onTap: _fireBullet,
        child: Stack(
          children: [
            // Score
            Positioned(
              top: 16,
              left: 16,
              child: Text(
                'Score: $score',
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            // Bullets
            ...bullets.map((b) {
              return Positioned(
                left: b.dx,
                top: b.dy,
                child: Container(
                  width: bulletWidth,
                  height: bulletHeight,
                  color: pinkAccentColor,
                ),
              );
            }),
            // Enemies
            ...enemies.map((e) {
              return Positioned(
                left: e.dx,
                top: e.dy,
                child: Container(
                  width: enemySize,
                  height: enemySize,
                  decoration: BoxDecoration(
                    color: pinkLight,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Center(
                    child: Icon(Icons.airplanemode_active,
                        color: Colors.white, size: 18),
                  ),
                ),
              );
            }),
            // Player plane
            Positioned(
              left: planePos.dx,
              top: planePos.dy,
              child: Container(
                width: planeWidth,
                height: planeHeight,
                decoration: BoxDecoration(
                  color: pinkAccentColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Center(
                  child: Icon(Icons.flight, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
