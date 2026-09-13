import 'package:flutter/material.dart';
import '../data/poem_service.dart';

class PoemDetail extends StatelessWidget {
  final Poem poem;
  const PoemDetail({super.key, required this.poem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(poem.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(poem.title,
                style: const TextStyle(
                    fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('${poem.dynasty} · ${poem.author}',
                style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 24),
            ...poem.content.map((l) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(l,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 20, height: 1.8, letterSpacing: 2)),
                )),
            const SizedBox(height: 24),
            Wrap(
              spacing: 8,
              children: poem.tags
                  .map((t) => Chip(label: Text(t)))
                  .toList(),
            ),
            const Divider(height: 40),
            _section('注释', poem.annotation),
            const SizedBox(height: 16),
            _section('译文', poem.translation),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _section(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF8B4513))),
        const SizedBox(height: 8),
        Text(content,
            style: const TextStyle(fontSize: 15, height: 1.8)),
      ],
    );
  }
}
