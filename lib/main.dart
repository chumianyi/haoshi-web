import 'package:flutter/material.dart';
import 'screens/home_nav.dart';
import 'data/poem_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PoemService().load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '快来古诗积累',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8B4513),
          primary: const Color(0xFF8B4513),
        ),
        useMaterial3: true,
      ),
      home: const HomeNav(),
    );
  }
}
