import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

// Palette
const Color bgColor = Color(0xFF0D0D0D);
const Color pinkLight = Color(0xFFFFD9F5);
const Color blueAccentColor = Color(0xFF60D3F3);
const Color pinkAccentColor = Color(0xFFFAB4E5);
const Color healthPickupColor = Color(0xFF00FF00);

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
  static const double healthPickupSize = 20;
  static const int gameTickMs = 16; // ~60 FPS
  static const int enemyShootIntervalMs = 1500;
  static const double healthDropChance = 0.3;
  static const double enemySpeed = 2.0; // Side-to-side speed
  static const double formationWidth = 300; // Width of formation movement
  static const int enemiesPerLevel = 10; // Fixed enemies per level
  static const int enemiesPerRow = 5; // Enemies per row
  static const double rowSpacing = 60; // Vertical spacing between rows

  late double screenWidth;
  late double screenHeight;

  // Player state
  Offset planePos = Offset.zero;
  int playerHealth = 3;
  bool gameOver = false;

  // Bullets, enemies, and pickups
  final List<Offset> playerBullets = [];
  final List<Offset> enemyBullets = [];
  final List<Offset> enemies = [];
  final List<Offset> healthPickups = [];

  int score = 0;
  int level = 1;
  int enemiesDestroyed = 0;
  Timer? _gameLoopTimer;
  Timer? _enemyShootTimer;
  final _random = Random();
  double _formationOffset = 0; // Tracks side-to-side movement
  bool _moveRight = true; // Direction of formation movement
  bool _enemiesSpawned = false; // Track if enemies for the level are spawned

  @override
  void initState() {
    super.initState();
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
    _gameLoopTimer?.cancel();
    _enemyShootTimer?.cancel();
    super.dispose();
  }

  void _spawnEnemies() {
    if (_enemiesSpawned) return;
    // Spawn 10 enemies in 2 rows of 5
    const double spacing = 60;
    double startX = (screenWidth - (enemiesPerRow * spacing)) / 2;
    for (int row = 0; row < 2; row++) {
      for (int i = 0; i < enemiesPerRow; i++) {
        enemies.add(Offset(startX + i * spacing, 50 + row * rowSpacing));
      }
    }
    _enemiesSpawned = true;
  }

  void _startGame() {
    if (gameOver) return;
    _spawnEnemies();
    _enemyShootTimer =
        Timer.periodic(const Duration(milliseconds: enemyShootIntervalMs), (_) {
      for (final enemy in enemies) {
        enemyBullets.add(Offset(
            enemy.dx + enemySize / 2 - bulletWidth / 2, enemy.dy + enemySize));
      }
    });

    _gameLoopTimer = Timer.periodic(
        const Duration(milliseconds: gameTickMs), (_) => _update());
  }

  void _update() {
    if (gameOver) return;

    // Calculate bullet speed based on level
    double bulletSpeed = 8.0 + level * 2;

    // Move player bullets up
    for (int i = playerBullets.length - 1; i >= 0; i--) {
      playerBullets[i] = playerBullets[i].translate(0, -bulletSpeed);
      if (playerBullets[i].dy < -bulletHeight) playerBullets.removeAt(i);
    }

    // Move enemy bullets down
    for (int i = enemyBullets.length - 1; i >= 0; i--) {
      enemyBullets[i] = enemyBullets[i].translate(0, bulletSpeed / 2);
      if (enemyBullets[i].dy > screenHeight) enemyBullets.removeAt(i);
    }

    // Move enemies side-to-side within screen bounds
    double minX = enemies.isEmpty ? 0 : enemies.map((e) => e.dx).reduce(min);
    double maxX = enemies.isEmpty ? 0 : enemies.map((e) => e.dx).reduce(max);
    if (_moveRight && maxX + enemySize + enemySpeed > screenWidth) {
      _moveRight = false; // Reverse if hitting right edge
    } else if (!_moveRight && minX - enemySpeed < 0) {
      _moveRight = true; // Reverse if hitting left edge
    }
    _formationOffset += _moveRight ? enemySpeed : -enemySpeed;
    for (int i = enemies.length - 1; i >= 0; i--) {
      enemies[i] = Offset(
          enemies[i].dx + (_moveRight ? enemySpeed : -enemySpeed),
          enemies[i].dy);
    }

    // Move health pickups down
    for (int i = healthPickups.length - 1; i >= 0; i--) {
      healthPickups[i] = healthPickups[i].translate(0, 2);
      if (healthPickups[i].dy > screenHeight) healthPickups.removeAt(i);
    }

    // Collisions: Player bullets vs Enemies
    for (int ei = enemies.length - 1; ei >= 0; ei--) {
      final e = enemies[ei];
      for (int bi = playerBullets.length - 1; bi >= 0; bi--) {
        final b = playerBullets[bi];
        final rectE = Rect.fromLTWH(e.dx, e.dy, enemySize, enemySize);
        final rectB = Rect.fromLTWH(b.dx, b.dy, bulletWidth, bulletHeight);
        if (rectE.overlaps(rectB)) {
          enemies.removeAt(ei);
          playerBullets.removeAt(bi);
          score += 10;
          enemiesDestroyed++;
          // Drop health pickup with probability
          if (_random.nextDouble() < healthDropChance && playerHealth < 3) {
            healthPickups.add(Offset(
                e.dx + enemySize / 2 - healthPickupSize / 2,
                e.dy + enemySize / 2));
          }
          break;
        }
      }
    }

    // Collisions: Enemy bullets vs Player
    for (int bi = enemyBullets.length - 1; bi >= 0; bi--) {
      final b = enemyBullets[bi];
      final rectB = Rect.fromLTWH(b.dx, b.dy, bulletWidth, bulletHeight);
      final rectP =
          Rect.fromLTWH(planePos.dx, planePos.dy, planeWidth, planeHeight);
      if (rectB.overlaps(rectP)) {
        enemyBullets.removeAt(bi);
        playerHealth--;
        if (playerHealth <= 0) {
          _gameOver();
        }
      }
    }

    // Collisions: Player vs Health Pickups
    for (int hi = healthPickups.length - 1; hi >= 0; hi--) {
      final h = healthPickups[hi];
      final rectH =
          Rect.fromLTWH(h.dx, h.dy, healthPickupSize, healthPickupSize);
      final rectP =
          Rect.fromLTWH(planePos.dx, planePos.dy, planeWidth, planeHeight);
      if (rectH.overlaps(rectP) && playerHealth < 3) {
        healthPickups.removeAt(hi);
        playerHealth++;
      }
    }

    // Level progression
    if (enemiesDestroyed >= enemiesPerLevel * level) {
      level++;
      _enemiesSpawned = false; // Allow spawning for new level
      enemies.clear(); // Clear remaining enemies
      _spawnEnemies(); // Spawn new enemies for the next level
    }

    setState(() {});
  }

  void _gameOver() {
    setState(() {
      gameOver = true;
      _gameLoopTimer?.cancel();
      _enemyShootTimer?.cancel();
    });
  }

  void _fireBullet() {
    if (gameOver) return;
    final bulletX = planePos.dx + planeWidth / 2 - bulletWidth / 2;
    final bulletY = planePos.dy - bulletHeight;
    playerBullets.add(Offset(bulletX, bulletY));
  }

  void _onHorizontalDrag(DragUpdateDetails d) {
    if (gameOver) return;
    setState(() {
      double newX = planePos.dx + d.delta.dx;
      if (newX < 0) newX = 0;
      if (newX > screenWidth - planeWidth) newX = screenWidth - planeWidth;
      planePos = Offset(newX, planePos.dy);
    });
  }

  void _restartGame() {
    setState(() {
      playerBullets.clear();
      enemyBullets.clear();
      enemies.clear();
      healthPickups.clear();
      score = 0;
      level = 1;
      enemiesDestroyed = 0;
      playerHealth = 3;
      gameOver = false;
      _formationOffset = 0;
      _moveRight = true;
      _enemiesSpawned = false;
      planePos = Offset(
          screenWidth / 2 - planeWidth / 2, screenHeight - planeHeight - 20);
      _startGame();
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
            onPressed: _restartGame,
          )
        ],
      ),
      body: GestureDetector(
        onHorizontalDragUpdate: _onHorizontalDrag,
        onTap: _fireBullet,
        child: Stack(
          children: [
            // Score and Health
            Positioned(
              top: 16,
              left: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Score: $score',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    'Health: $playerHealth',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    'Level: $level',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            // Player Bullets
            ...playerBullets.map((b) {
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
            // Enemy Bullets
            ...enemyBullets.map((b) {
              return Positioned(
                left: b.dx,
                top: b.dy,
                child: Container(
                  width: bulletWidth,
                  height: bulletHeight,
                  color: Colors.red,
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
            // Health Pickups
            ...healthPickups.map((h) {
              return Positioned(
                left: h.dx,
                top: h.dy,
                child: Container(
                  width: healthPickupSize,
                  height: healthPickupSize,
                  decoration: const BoxDecoration(
                    color: healthPickupColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(Icons.favorite, color: Colors.white, size: 12),
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
            // Game Over Screen
            if (gameOver)
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.black.withOpacity(0.8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Game Over',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Score: $score',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 24),
                      ),
                      Text(
                        'Level: $level',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 24),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _restartGame,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: blueAccentColor,
                        ),
                        child: const Text('Restart',
                            style: TextStyle(color: Colors.black)),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
