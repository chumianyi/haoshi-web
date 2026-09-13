import 'package:flutter/material.dart';
import '../data/poem_service.dart';
import 'poem_detail.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final _ctrl = TextEditingController();
  String? _dynasty;
  List<Poem> _results = [];

  @override
  void initState() {
    super.initState();
    _results = PoemService().all;
  }

  void _search() {
    setState(() {
      _results = PoemService().search(
        keyword: _ctrl.text.trim(),
        dynasty: _dynasty,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final svc = PoemService();
    return Scaffold(
      appBar: AppBar(title: const Text('古诗查询'), centerTitle: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _ctrl,
              decoration: InputDecoration(
                hintText: '搜索诗名、作者或诗句...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _ctrl.clear();
                      _search();
                    }),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onSubmitted: (_) => _search(),
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                ChoiceChip(
                  label: const Text('全部朝代'),
                  selected: _dynasty == null,
                  onSelected: (_) {
                    setState(() => _dynasty = null);
                    _search();
                  },
                ),
                ...svc.dynasties.map((d) => Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: ChoiceChip(
                        label: Text(d),
                        selected: _dynasty == d,
                        onSelected: (_) {
                          setState(() => _dynasty = d);
                          _search();
                        },
                      ),
                    )),
              ],
            ),
          ),
          Expanded(
            child: _results.isEmpty
                ? const Center(child: Text('未找到相关古诗'))
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _results.length,
                    itemBuilder: (_, i) {
                      final p = _results[i];
                      return Card(
                        child: ListTile(
                          title: Text(p.title,
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('${p.dynasty} · ${p.author}'),
                          trailing: const Icon(Icons.chevron_right),
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
