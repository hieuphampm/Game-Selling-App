import 'package:flutter/material.dart';

// Palette
const Color bgColor = Color(0xFF0D0D0D);
const Color pinkLight = Color(0xFFFFD9F5);
const Color blueAccentColor = Color(0xFF60D3F3);
const Color pinkAccentColor = Color(0xFFFAB4E5);

class QuizGameScreen extends StatefulWidget {
  static const routeName = '/quiz';
  const QuizGameScreen({Key? key}) : super(key: key);

  @override
  _QuizGameScreenState createState() => _QuizGameScreenState();
}

class _QuizGameScreenState extends State<QuizGameScreen> {
  final _questions = const [
    {
      'q': 'Thủ đô của Việt Nam là gì?',
      'choices': ['Hà Nội', 'Hồ Chí Minh', 'Đà Nẵng', 'Hải Phòng'],
      'answer': 0,
    },
    {
      'q': '2 + 2 = ?',
      'choices': ['3', '4', '5', '22'],
      'answer': 1,
    },
    {
      'q': 'Màu nào không có trong cờ Việt Nam?',
      'choices': ['Đỏ', 'Vàng', 'Xanh', 'Trắng'],
      'answer': 2,
    },
  ];

  int _currentIndex = 0;
  int _score = 0;
  int? _selected;

  void _submit() {
    if (_selected == null) return;
    final correct = _questions[_currentIndex]['answer'] as int;
    if (_selected == correct) _score += 10;
    setState(() {
      _currentIndex++;
      _selected = null;
    });
  }

  void _restart() {
    setState(() {
      _currentIndex = 0;
      _score = 0;
      _selected = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final end = _currentIndex >= _questions.length;
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Quizz', style: TextStyle(color: Colors.black)),
        backgroundColor: blueAccentColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: _restart,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: end
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Quiz Completed!',
                        style: TextStyle(color: pinkLight, fontSize: 24)),
                    const SizedBox(height: 12),
                    Text('Your score: $_score',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18)),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: pinkAccentColor),
                      onPressed: _restart,
                      child: const Text('Play Again'),
                    ),
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Question ${_currentIndex + 1}/${_questions.length}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _questions[_currentIndex]['q'] as String,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ...((_questions[_currentIndex]['choices'] as List<String>)
                      .asMap()
                      .entries
                      .map((e) {
                    final idx = e.key;
                    final text = e.value;
                    final sel = _selected == idx;
                    return Card(
                      color: sel ? pinkLight : pinkAccentColor,
                      child: RadioListTile<int>(
                        value: idx,
                        groupValue: _selected,
                        onChanged: (v) => setState(() => _selected = v),
                        title: Text(text,
                            style: const TextStyle(color: Colors.black)),
                      ),
                    );
                  }).toList()),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: blueAccentColor),
                      onPressed: _selected != null ? _submit : null,
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
