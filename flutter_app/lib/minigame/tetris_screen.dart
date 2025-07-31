import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

const Color bgColor = Color(0xFF0D0D0D);
const Color pinkLight = Color(0xFFFFD9F5);
const Color blueAccentColor = Color(0xFF60D3F3);
const Color pinkAccentColor = Color(0xFFFAB4E5);

enum TetrominoType { I, O, T, S, Z, J, L }

class TetrisGameScreen extends StatefulWidget {
  const TetrisGameScreen({Key? key}) : super(key: key);
  @override
  _TetrisGameScreenState createState() => _TetrisGameScreenState();
}

class _TetrisGameScreenState extends State<TetrisGameScreen> {
  static const int rows = 20;
  static const int cols = 10;
  static const Duration tickRate = Duration(milliseconds: 500);

  late List<List<int>> _board; // 0 = empty, 1 = locked
  List<Point<int>> _piece = [];
  late Point<int> _pivot;
  TetrominoType? _type;
  Color _color = blueAccentColor;
  Timer? _timer;
  int _score = 0;
  final _rnd = Random();

  @override
  void initState() {
    super.initState();
    _newGame();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _newGame() {
    _timer?.cancel();
    _score = 0;
    _board = List.generate(rows, (_) => List.filled(cols, 0));
    _spawn();
    _timer = Timer.periodic(tickRate, (_) => _tick());
  }

  void _spawn() {
    _type = TetrominoType.values[_rnd.nextInt(7)];
    final mid = cols ~/ 2;
    switch (_type!) {
      case TetrominoType.I:
        _piece = [
          Point(mid - 2, 0),
          Point(mid - 1, 0),
          Point(mid, 0),
          Point(mid + 1, 0)
        ];
        _color = blueAccentColor;
        break;
      case TetrominoType.O:
        _piece = [
          Point(mid, 0),
          Point(mid + 1, 0),
          Point(mid, 1),
          Point(mid + 1, 1)
        ];
        _color = pinkLight;
        break;
      case TetrominoType.T:
        _piece = [
          Point(mid - 1, 0),
          Point(mid, 0),
          Point(mid + 1, 0),
          Point(mid, 1)
        ];
        _color = pinkAccentColor;
        break;
      case TetrominoType.S:
        _piece = [
          Point(mid, 0),
          Point(mid + 1, 0),
          Point(mid - 1, 1),
          Point(mid, 1)
        ];
        _color = blueAccentColor;
        break;
      case TetrominoType.Z:
        _piece = [
          Point(mid - 1, 0),
          Point(mid, 0),
          Point(mid, 1),
          Point(mid + 1, 1)
        ];
        _color = pinkLight;
        break;
      case TetrominoType.J:
        _piece = [
          Point(mid - 1, 0),
          Point(mid - 1, 1),
          Point(mid, 1),
          Point(mid + 1, 1)
        ];
        _color = pinkAccentColor;
        break;
      case TetrominoType.L:
        _piece = [
          Point(mid + 1, 0),
          Point(mid - 1, 1),
          Point(mid, 1),
          Point(mid + 1, 1)
        ];
        _color = blueAccentColor;
        break;
    }
    _pivot = _piece[1];
    // Nếu ngay lúc spawn đã chạm block thì game over
    if (_piece.any((p) => !_emptyAt(p))) {
      _timer?.cancel();
    }
  }

  bool _emptyAt(Point<int> p) =>
      p.x >= 0 && p.x < cols && p.y >= 0 && p.y < rows && _board[p.y][p.x] == 0;

  bool _valid(List<Point<int>> cand) => cand.every(_emptyAt);

  void _lock() {
    for (var p in _piece) {
      if (p.y >= 0 && p.y < rows) {
        _board[p.y][p.x] = 1;
      }
    }
    // clear lines
    for (int y = rows - 1; y >= 0; y--) {
      if (_board[y].every((c) => c == 1)) {
        _board.removeAt(y);
        _board.insert(0, List.filled(cols, 0));
        _score += 100;
        y++; // re-check this row
      }
    }
    _spawn();
  }

  void _tick() {
    // Nếu bất cứ ô nào của piece đã chạm đáy row == rows-1 → khóa ngay
    if (_piece.any((p) => p.y == rows - 1)) {
      _lock();
      return;
    }
    // else thử rơi
    final down = _piece.map((p) => Point(p.x, p.y + 1)).toList();
    if (_valid(down)) {
      setState(() {
        _piece = down;
        _pivot = Point(_pivot.x, _pivot.y + 1);
      });
    } else {
      _lock();
    }
  }

  void _moveHoriz(int dx) {
    final moved = _piece.map((p) => Point(p.x + dx, p.y)).toList();
    if (_valid(moved)) {
      setState(() {
        _piece = moved;
        _pivot = Point(_pivot.x + dx, _pivot.y);
      });
    }
  }

  void _rotate() {
    if (_type == TetrominoType.O) return;
    final rot = _piece.map((p) {
      final rx = p.x - _pivot.x;
      final ry = p.y - _pivot.y;
      return Point(_pivot.x + ry, _pivot.y - rx);
    }).toList();
    const kicks = [0, -1, 1, -2, 2];
    for (var dx in kicks) {
      final kicked = rot.map((p) => Point(p.x + dx, p.y)).toList();
      if (_valid(kicked)) {
        setState(() {
          _piece = kicked;
          _pivot = Point(_pivot.x + dx, _pivot.y);
        });
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Tetris', style: TextStyle(color: Colors.black)),
        backgroundColor: blueAccentColor,
        elevation: 0,
        leading: BackButton(color: Colors.black),
        actions: [
          IconButton(
              icon: const Icon(Icons.refresh, color: Colors.black),
              onPressed: _newGame),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Text('Score: $_score',
              style: const TextStyle(color: Colors.white, fontSize: 18)),
          const SizedBox(height: 8),
          // Khung chơi 10:20, tự co dãn theo chiều rộng
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onHorizontalDragUpdate: (d) {
                if (d.delta.dx > 5) _moveHoriz(1);
                if (d.delta.dx < -5) _moveHoriz(-1);
              },
              onTap: _rotate,
              child: Center(
                child: AspectRatio(
                  aspectRatio: cols / rows, // 10:20 = 0.5
                  child: LayoutBuilder(
                    builder: (ctx, cons) {
                      final cell = cons.maxWidth / cols;
                      final pad = cell * 0.1;
                      return Stack(
                        children: [
                          // locked blocks
                          for (int y = 0; y < rows; y++)
                            for (int x = 0; x < cols; x++)
                              if (_board[y][x] == 1)
                                Positioned(
                                  left: x * cell,
                                  top: y * cell,
                                  child: Container(
                                    width: cell,
                                    height: cell,
                                    padding: EdgeInsets.all(pad),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade800),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: pinkLight,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                  ),
                                ),
                          // current piece
                          for (var p in _piece)
                            if (p.y >= 0 && p.y < rows)
                              Positioned(
                                left: p.x * cell,
                                top: p.y * cell,
                                child: Container(
                                  width: cell,
                                  height: cell,
                                  padding: EdgeInsets.all(pad),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade800),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: _color,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ),
                              ),
                          // boundary line ở đáy
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(height: 2, color: Colors.white),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text('Swipe ← → to move, Tap to rotate',
              style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
