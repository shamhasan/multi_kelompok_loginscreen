import 'package:flutter/material.dart';
import 'package:multi_kelompok/providers/watchlist_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:multi_kelompok/Providers/MovieProvider.dart';
import 'package:multi_kelompok/Providers/auth_provider/AuthProvider.dart';
import 'package:multi_kelompok/providers/genre_provider.dart';
import 'package:multi_kelompok/widgets/auth/AuthGate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
        ChangeNotifierProvider(create: (_) => GenreProvider()),
        ChangeNotifierProvider(create: (_) => WatchlistProvider()),


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
