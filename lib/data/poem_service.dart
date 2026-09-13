import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class Poem {
  final int id;
  final String title;
  final String author;
  final String dynasty;
  final List<String> content;
  final String translation;
  final String annotation;
  final List<String> tags;

  Poem({
    required this.id,
    required this.title,
    required this.author,
    required this.dynasty,
    required this.content,
    required this.translation,
    required this.annotation,
    required this.tags,
  });

  factory Poem.fromJson(Map<String, dynamic> json) {
    return Poem(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      dynasty: json['dynasty'] ?? '',
      content: (json['content'] as List).map((e) => e.toString()).toList(),
      translation: json['translation'] ?? '',
      annotation: json['annotation'] ?? '',
      tags: (json['tags'] as List? ?? []).map((e) => e.toString()).toList(),
    );
  }
}

class PoemService {
  static final PoemService _instance = PoemService._internal();
  factory PoemService() => _instance;
  List<Poem> _poems = [];

  PoemService._internal();

  Future<void> load() async {
    final str = await rootBundle.loadString('assets/poems.json');
    final list = jsonDecode(str) as List;
    _poems = list.map((e) => Poem.fromJson(e)).toList();
  }

  List<Poem> get all => List.unmodifiable(_poems);

  List<String> get dynasties =>
      _poems.map((e) => e.dynasty).toSet().toList();
  List<String> get authors =>
      _poems.map((e) => e.author).toSet().toList();

  List<Poem> search({String? keyword, String? dynasty, String? author}) {
    return _poems.where((p) {
      bool match = true;
      if (keyword != null && keyword.isNotEmpty) {
        match = p.title.contains(keyword) ||
            p.author.contains(keyword) ||
            p.content.any((l) => l.contains(keyword));
      }
      if (dynasty != null && dynasty.isNotEmpty) {
        match = match && p.dynasty == dynasty;
      }
      if (author != null && author.isNotEmpty) {
        match = match && p.author == author;
      }
      return match;
    }).toList();
  }

  Poem random() => (_poems..shuffle()).first;
}
