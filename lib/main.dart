import 'package:flutter/material.dart';
import 'package:multi_kelompok/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:multi_kelompok/providers/review_provider.dart';

void main() {
  runApp(
    // 1. Mendaftarkan ReviewProvider di level tertinggi aplikasi
    ChangeNotifierProvider(
      create: (context) => ReviewProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Movie App',
      // 2. Memulai aplikasi dari LoginScreen
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
