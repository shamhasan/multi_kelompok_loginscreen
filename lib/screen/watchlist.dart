import 'package:flutter/material.dart';
import 'package:multi_kelompok/models/movie_model.dart';
import 'package:multi_kelompok/providers/watchlist_provider.dart';
import 'package:multi_kelompok/screen/movie_detail_screen.dart';
import 'package:provider/provider.dart';

import 'package:multi_kelompok/screens/movie_detail_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WatchlistPage extends StatefulWidget {
  const WatchlistPage({super.key});

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
  @override
  void initState() {
    super.initState();
    // Gunakan addPostFrameCallback untuk memastikan context sudah siap
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Panggil provider untuk memuat data watchlist saat halaman dibuka
      Provider.of<WatchlistProvider>(context, listen: false).loadWatchlist();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Watchlist")),
      // Gunakan Consumer untuk mendengarkan perubahan pada WatchlistProvider
      body: Consumer<WatchlistProvider>(
        builder: (context, watchlistProvider, child) {
          // Tampilkan loading indicator jika sedang memuat data
          if (watchlistProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Jika watchlist kosong, tampilkan pesan
          if (watchlistProvider.watchlist.isEmpty) {
            return const Center(
              child: Text(
                "Watchlist Anda masih kosong.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          // Jika ada data, tampilkan ListView
          return ListView.builder(
            itemCount: watchlistProvider.watchlist.length,
            itemBuilder: (context, index) {
              final Movie movie = watchlistProvider.watchlist[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailScreen(movie: movie),
                    ),
                  );
                },
                child: Container(
                  margin:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          offset: Offset(0, 3)),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          movie.posterUrl,
                          width: 80,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 80,
                              height: 120,
                              color: Colors.grey[200],
                              child: const Icon(Icons.movie_creation_outlined,
                                  color: Colors.grey, size: 40),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              movie.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 7),
                            Text(
                              movie.genres.join(', '),
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              movie.duration,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
