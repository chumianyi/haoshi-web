import 'package:flutter/material.dart';
import '../data/poem_service.dart';
import 'poem_detail.dart';

class LearnTab extends StatefulWidget {
  const LearnTab({super.key});

  @override
  State<LearnTab> createState() => _LearnTabState();
}

class _LearnTabState extends State<LearnTab> {
  String? _dynasty;

  @override
  Widget build(BuildContext context) {
    final svc = PoemService();
    final poems = _dynasty == null
        ? svc.all
        : svc.search(dynasty: _dynasty);

    return Scaffold(
      appBar: AppBar(
        title: const Text('古诗学习'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                ChoiceChip(
                  label: const Text('全部'),
                  selected: _dynasty == null,
                  onSelected: (_) => setState(() => _dynasty = null),
                ),
                const SizedBox(width: 8),
                ...svc.dynasties.map((d) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(d),
                        selected: _dynasty == d,
                        onSelected: (_) => setState(() => _dynasty = d),
                      ),
                    )),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: poems.length,
              itemBuilder: (_, i) {
                final p = poems[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF8B4513),
                      child: Text(p.dynasty[0]),
                    ),
                    title: Text(p.title,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${p.dynasty} · ${p.author}'),
                    trailing: Text(p.content.first,
                        style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => PoemDetail(poem: p))),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
