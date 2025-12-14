import 'package:flutter/material.dart';
import 'package:multi_kelompok/models/movie_model.dart'; // DIUBAH
import 'package:multi_kelompok/screens/movie_detail_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WatchlistPage extends StatefulWidget {
  const WatchlistPage({super.key});

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
  late Future<List<Movie>> _watchlistFuture;

  @override
  void initState() {
    super.initState();
    _watchlistFuture = _fetchWatchlist();
  }

  Future<List<Movie>> _fetchWatchlist() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not logged in');
    }

    final response = await Supabase.instance.client
        .from('watchlist')
        .select('movies(*)')
        .eq('user_id', userId);

    final movieMaps = response.map((item) => item['movies'] as Map<String, dynamic>).toList();
    return movieMaps.map((movieMap) => Movie.fromMap(movieMap)).toList(); // DIUBAH
  }

  Future<void> _refreshWatchlist() async {
    setState(() {
      _watchlistFuture = _fetchWatchlist();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Watchlist'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshWatchlist,
        child: FutureBuilder<List<Movie>>(
          future: _watchlistFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'Your watchlist is empty.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            final movies = snapshot.data!;

            return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(
                        movie.posterUrl,
                        width: 50,
                        height: 75,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => const Icon(Icons.movie),
                      ),
                    ),
                    title: Text(movie.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(movie.year.toString()),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetailScreen(movieId: movie.id!),
                        ),
                      );
                      if (result == true) {
                        _refreshWatchlist();
                      }
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
