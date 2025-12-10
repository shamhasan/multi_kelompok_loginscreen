import 'package:flutter/material.dart';
import 'package:multi_kelompok/Providers/auth_provider/AuthProvider.dart';
import 'package:multi_kelompok/Providers/MovieProvider.dart';
import 'package:multi_kelompok/admin/admin_screen.dart';
import 'package:multi_kelompok/admin/genre_admin_screen.dart';
import 'package:multi_kelompok/admin/movie_admin_screen.dart';
import 'package:multi_kelompok/home_screen.dart';
import 'package:multi_kelompok/login_screen.dart';
import 'package:multi_kelompok/popular_movie_ui.dart';
import 'package:multi_kelompok/watchlist.dart';
import 'package:multi_kelompok/widgets/auth/AuthGate.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
    url: "https://vafjsmuirzjuwvuocpwq.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZhZmpzbXVpcnpqdXd2dW9jcHdxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjEyNDcwMTAsImV4cCI6MjA3NjgyMzAxMH0.epwC9GtxSQxb3PvVIqCWFuKNwoVti9okPqPUl-dLLWg",
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MovieProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home:
            // HomeScreen()
            // WatchlistPage()
            // PopularMoviesPage()
            // GenreListPage()
            // LoginScreen(),
            // MovieAdminScreen(),
            // GenreAdminScreen()
            // AdminScreen()
            AuthGate(),
      ),
    ),
  );
}
