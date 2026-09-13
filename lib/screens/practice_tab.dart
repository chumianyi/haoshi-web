import 'package:flutter/material.dart';
import '../data/poem_service.dart';

class PracticeTab extends StatefulWidget {
  const PracticeTab({super.key});

  @override
  State<PracticeTab> createState() => _PracticeTabState();
}

class _PracticeTabState extends State<PracticeTab> {
  int _total = 0;
  int _correct = 0;
  bool _answered = false;
  String _feedback = '';
  late Poem _poem;
  late String _questionLine;
  late String _answerLine;
  late List<String> _options;

  @override
  void initState() {
    super.initState();
    _newQuestion();
  }

  void _newQuestion() {
    final svc = PoemService();
    final poems = svc.all;
    poems.shuffle();
    final p = poems.first;
    if (p.content.length < 2) {
      _newQuestion();
      return;
    }
    final idx = (p.content.length - 1) - 1; // ask second line based on first
    final q = p.content[idx].replaceAll(RegExp(r'[，。！？]'), '');
    final a = p.content[idx + 1].replaceAll(RegExp(r'[，。！？]'), '');
    final wrong = poems.where((e) => e.id != p.id).toList()..shuffle();
    final opts = <String>[
      a,
      wrong[0].content[0].replaceAll(RegExp(r'[，。！？]'), ''),
      wrong[1].content[0].replaceAll(RegExp(r'[，。！？]'), ''),
      wrong[2].content[0].replaceAll(RegExp(r'[，。！？]'), ''),
    ]..shuffle();
    setState(() {
      _poem = p;
      _questionLine = q;
      _answerLine = a;
      _options = opts;
      _answered = false;
      _feedback = '';
    });
  }

  void _answer(String opt) {
    if (_answered) return;
    setState(() {
      _answered = true;
      _total++;
      if (opt == _answerLine) {
        _correct++;
        _feedback = '回答正确！';
      } else {
        _feedback = '正确答案：$_answerLine';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('古诗练习'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _stat('答题', _total.toString()),
                    _stat('正确', _correct.toString()),
                    _stat('正确率', _total == 0 ? '--' : '${(_correct / _total * 100).round()}%'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('${_poem.dynasty} · ${_poem.author}《${_poem.title}》',
                style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 16),
            Text('$_questionLine，',
                style: const TextStyle(fontSize: 24, height: 1.8, letterSpacing: 2)),
            const Text('？',
                style: TextStyle(fontSize: 28, color: Color(0xFF8B4513), fontWeight: FontWeight.bold)),
            const SizedBox(height: 32),
            ..._options.map((opt) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        backgroundColor: _answered
                            ? opt == _answerLine
                                ? Colors.green[100]
                                : Colors.grey[100]
                            : null,
                      ),
                      onPressed: () => _answer(opt),
                      child: Text(opt, style: const TextStyle(fontSize: 16)),
                    ),
                  ),
                )),
            const SizedBox(height: 16),
            if (_answered)
              Column(
                children: [
                  Text(_feedback,
                      style: TextStyle(
                          fontSize: 16,
                          color: _feedback.contains('正确') ? Colors.green : Colors.red)),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: _newQuestion,
                    child: const Text('下一题'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _stat(String label, String value) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}
