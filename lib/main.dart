import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:multi_kelompok/providers/MovieProvider.dart';
import 'package:multi_kelompok/providers/auth_provider/AuthProvider.dart';
import 'package:multi_kelompok/providers/genre_provider.dart';
import 'package:multi_kelompok/providers/vote_provider.dart';
import 'package:multi_kelompok/providers/watchlist_provider.dart';
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
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => VoteProvider()),
        ChangeNotifierProvider(create: (context) => MovieProvider()),
        ChangeNotifierProvider(create: (context) => GenreProvider()),
        ChangeNotifierProvider(create: (context) => WatchlistProvider()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthGate(),
      ),
    ),
  );
}
