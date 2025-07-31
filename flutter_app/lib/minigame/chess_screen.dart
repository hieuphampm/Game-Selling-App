import 'dart:math';

import 'package:flutter/material.dart';

// Palette
const Color bgColor = Color(0xFF0D0D0D);
const Color pinkLight = Color(0xFFFFD9F5);
const Color blueAccentColor = Color(0xFF60D3F3);
const Color pinkAccentColor = Color(0xFFFAB4E5);

class ChessGameScreen extends StatefulWidget {
  static const routeName = '/chess';
  const ChessGameScreen({Key? key}) : super(key: key);

  @override
  _ChessGameScreenState createState() => _ChessGameScreenState();
}

class _ChessGameScreenState extends State<ChessGameScreen> {
  static const int size = 8;
  late List<List<String>> _board;
  Point<int>? _selected;

  @override
  void initState() {
    super.initState();
    _resetBoard();
  }

  void _resetBoard() {
    _board = List.generate(size, (y) => List.filled(size, ''));
    const backRank = ['r', 'n', 'b', 'q', 'k', 'b', 'n', 'r'];
    for (int x = 0; x < size; x++) {
      _board[0][x] = 'b${backRank[x]}';
      _board[1][x] = 'bp';
      _board[6][x] = 'wp';
      _board[7][x] = 'w${backRank[x]}';
    }
    setState(() => _selected = null);
  }

  void _onTap(int x, int y) {
    final piece = _board[y][x];
    if (_selected == null) {
      if (piece.isNotEmpty) setState(() => _selected = Point(x, y));
    } else {
      setState(() {
        // move regardless of legality
        _board[y][x] = _board[_selected!.y][_selected!.x];
        _board[_selected!.y][_selected!.x] = '';
        _selected = null;
      });
    }
  }

  Widget _buildSquare(int x, int y, double cellSize) {
    final isLight = (x + y) % 2 == 0;
    final bg =
        isLight ? pinkLight.withOpacity(0.3) : blueAccentColor.withOpacity(0.3);
    final sel = _selected != null && _selected!.x == x && _selected!.y == y;
    final piece = _board[y][x];
    Widget? icon;
    if (piece.isNotEmpty) {
      final color = piece[0] == 'w' ? Colors.white : Colors.black;
      final type = piece[1];
      IconData data;
      switch (type) {
        case 'p':
          data = Icons.adjust;
          break;
        case 'r':
          data = Icons.directions_car;
          break;
        case 'n':
          data = Icons.toys;
          break;
        case 'b':
          data = Icons.crop_square;
          break;
        case 'q':
          data = Icons.brightness_7;
          break;
        case 'k':
          data = Icons.star;
          break;
        default:
          data = Icons.help;
      }
      icon = Icon(data, color: color, size: cellSize * 0.6);
    }
    return GestureDetector(
      onTap: () => _onTap(x, y),
      child: Container(
        width: cellSize,
        height: cellSize,
        decoration: BoxDecoration(
          color: sel ? pinkAccentColor : bg,
          border: Border.all(color: Colors.black26),
        ),
        child: icon == null ? null : Center(child: icon),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cellSize = (width - 32) / size;
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Cờ vua', style: TextStyle(color: Colors.black)),
        backgroundColor: blueAccentColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: _resetBoard,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              width: cellSize * size,
              height: cellSize * size,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: size,
                ),
                itemCount: size * size,
                itemBuilder: (_, idx) {
                  final x = idx % size;
                  final y = idx ~/ size;
                  return _buildSquare(x, y, cellSize);
                },
              ),
            ),
            const SizedBox(height: 16),
            Text('Tap a piece, then an empty square or enemy to move.',
                style: const TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}
