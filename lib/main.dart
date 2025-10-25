import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// import halaman
import 'package:multi_kelompok/home_screen.dart';
import 'package:multi_kelompok/login_screen.dart';
import 'package:multi_kelompok/watchlist.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔗 Inisialisasi Supabase
  await Supabase.initialize(
    url: 'https://ffcihnaanrecuwemqlxu.supabase.co', // Ganti
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZmY2lobmFhbnJlY3V3ZW1xbHh1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjEzOTkxMzAsImV4cCI6MjA3Njk3NTEzMH0.5qLLpWPscaIzTkvDPQKDmg_xs9BC4ZW5k_nfuEE9lik', // Ganti
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    final currentUser = supabase.auth.currentUser;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Multi Platform Kelompok 6',
      home: currentUser == null ? const LoginScreen() : const HomeScreen(),
      routes: {
        '/watchlist': (context) => const WatchlistPage(),
      },
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:multi_kelompok/home_screen.dart';
// import 'package:multi_kelompok/login_screen.dart';
// import 'package:multi_kelompok/popular_movie_ui.dart';
// import 'package:multi_kelompok/watchlist.dart';
//
// void main() {
//   runApp(
//     MaterialApp(
//       home:
//       // HomeScreen()
//       // WatchlistPage()
//       // PopularMoviesPage()
//       // GenreListPage()
//       LoginScreen()
//       ,
//       debugShowCheckedModeBanner: false
//       )
//     );
// }
