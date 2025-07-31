import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

// Palette
const Color bgColor = Color(0xFF0D0D0D);
const Color pinkLight = Color(0xFFFFD9F5);
const Color blueAccentColor = Color(0xFF60D3F3);
const Color pinkAccentColor = Color(0xFFFAB4E5);

enum Direction { up, down, left, right }

class SnakeGameScreen extends StatefulWidget {
  const SnakeGameScreen({Key? key}) : super(key: key);

  @override
  _SnakeGameScreenState createState() => _SnakeGameScreenState();
}

class _SnakeGameScreenState extends State<SnakeGameScreen> {
  static const int rowCount = 20;
  static const int colCount = 20;
  static const Duration tickDuration = Duration(milliseconds: 200);

  final random = Random();
  List<Point<int>> snake = [];
  Point<int>? food;
  Direction direction = Direction.right;
  Timer? gameTimer;
  int score = 0;
  bool isGameOver = false;
  bool isPaused = false;

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    super.dispose();
  }

  void _startNewGame() {
    snake = [
      Point(colCount ~/ 2, rowCount ~/ 2),
      Point(colCount ~/ 2 - 1, rowCount ~/ 2),
      Point(colCount ~/ 2 - 2, rowCount ~/ 2),
    ];
    direction = Direction.right;
    score = 0;
    isGameOver = false;
    isPaused = false;
    _generateFood();
    _startTimer();
  }

  void _startTimer() {
    gameTimer?.cancel();
    gameTimer = Timer.periodic(tickDuration, (_) {
      if (!isPaused && !isGameOver) _updateGame();
    });
  }

  void _togglePause() {
    setState(() {
      isPaused = !isPaused;
    });
  }

  void _generateFood() {
    while (true) {
      final x = random.nextInt(colCount);
      final y = random.nextInt(rowCount);
      final p = Point(x, y);
      if (!snake.contains(p)) {
        food = p;
        break;
      }
    }
  }

  void _updateGame() {
    final head = snake.first;
    Point<int> newHead;
    switch (direction) {
      case Direction.up:
        newHead = Point(head.x, head.y - 1);
        break;
      case Direction.down:
        newHead = Point(head.x, head.y + 1);
        break;
      case Direction.left:
        newHead = Point(head.x - 1, head.y);
        break;
      case Direction.right:
        newHead = Point(head.x + 1, head.y);
        break;
    }

    // Va chạm biên hoặc tự cắn
    if (newHead.x < 0 ||
        newHead.x >= colCount ||
        newHead.y < 0 ||
        newHead.y >= rowCount ||
        snake.contains(newHead)) {
      setState(() {
        isGameOver = true;
        gameTimer?.cancel();
      });
      return;
    }

    setState(() {
      snake.insert(0, newHead);
      if (food == newHead) {
        score += 10;
        _generateFood();
      } else {
        snake.removeLast();
      }
    });
  }

  void _onVerticalDrag(DragUpdateDetails details) {
    if (details.delta.dy < 0 && direction != Direction.down) {
      direction = Direction.up;
    } else if (details.delta.dy > 0 && direction != Direction.up) {
      direction = Direction.down;
    }
  }

  void _onHorizontalDrag(DragUpdateDetails details) {
    if (details.delta.dx < 0 && direction != Direction.right) {
      direction = Direction.left;
    } else if (details.delta.dx > 0 && direction != Direction.left) {
      direction = Direction.right;
    }
  }

  @override
  Widget build(BuildContext context) {
    const reservedHeight = kToolbarHeight + 60.0;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Snake', style: TextStyle(color: Colors.black)),
        backgroundColor: blueAccentColor,
        elevation: 0,
        leading: BackButton(color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(isPaused ? Icons.play_arrow : Icons.pause,
                color: Colors.black),
            onPressed: _togglePause,
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: _startNewGame,
          ),
        ],
      ),
      body: GestureDetector(
        onVerticalDragUpdate: _onVerticalDrag,
        onHorizontalDragUpdate: _onHorizontalDrag,
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Tính kích thước board vuông
            final maxW = constraints.maxWidth;
            final maxH = constraints.maxHeight - reservedHeight;
            final boardSize = min(maxW, maxH);
            final cellSize = boardSize / colCount;

            return Stack(
              children: [
                // Thanh điểm
                Positioned(
                  top: 8,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      'Score: $score',
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),

                // Bàn chơi vuông
                Center(
                  child: Container(
                    width: boardSize,
                    height: boardSize,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: colCount,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: rowCount * colCount,
                      itemBuilder: (context, index) {
                        final x = index % colCount;
                        final y = index ~/ colCount;
                        final point = Point(x, y);
                        Color cellColor = bgColor;
                        if (snake.first == point) {
                          cellColor = pinkAccentColor;
                        } else if (snake.contains(point)) {
                          cellColor = pinkLight;
                        } else if (food == point) {
                          cellColor = blueAccentColor;
                        }
                        return Container(
                          margin: EdgeInsets.all(cellSize * 0.05),
                          decoration: BoxDecoration(
                            color: cellColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Overlay Pause
                if (isPaused)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black45,
                      child: const Center(
                        child: Text(
                          'Paused',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                // Thông báo Game Over
                if (isGameOver)
                  Positioned(
                    bottom: 32,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        'Game Over',
                        style: TextStyle(
                          color: pinkAccentColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
