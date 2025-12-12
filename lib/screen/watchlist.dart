import 'package:flutter/material.dart';
import 'package:multi_kelompok/models/movie.dart';
import 'package:multi_kelompok/screens/movie_detail_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WatchlistPage extends StatefulWidget {
  const WatchlistPage({super.key});

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
  bool _isLoading = true;
  String? _error;
  List<Movie> _watchlistMovies = [];

  @override
  void initState() {
    super.initState();
    _fetchWatchlist();
  }

  Future<void> _fetchWatchlist() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Anda harus login untuk melihat watchlist.');
      }

      // 1. Ambil semua movie_id dari tabel watchlist milik pengguna
      final watchlistResponse = await Supabase.instance.client
          .from('watchlist')
          .select('movie_id')
          .eq('user_id', userId);

      final movieIds = (watchlistResponse as List).map((item) => item['movie_id'] as int).toList();

      if (movieIds.isEmpty) {
        if (mounted) {
          setState(() {
            _watchlistMovies = [];
            _isLoading = false;
          });
        }
        return;
      }

      // 2. Ambil semua detail film berdasarkan movie_id yang didapat
      final moviesResponse = await Supabase.instance.client
          .from('movies')
          .select()
          .inFilter('id', movieIds);

      if (mounted) {
        final movies = (moviesResponse as List).map((data) => Movie.fromJson(data)).toList();
        setState(() {
          _watchlistMovies = movies;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = "Gagal memuat watchlist: $e";
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Watchlist"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(_error!, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
        ),
      );
    }

    if (_watchlistMovies.isEmpty) {
      return const Center(
        child: Text(
          'Watchlist Anda masih kosong.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchWatchlist,
      child: ListView.builder(
        itemCount: _watchlistMovies.length,
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, index) {
          final movie = _watchlistMovies[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDetailScreen(movieId: movie.id),
                ),
              ).then((_) => _fetchWatchlist()); // Refresh data saat kembali
            },
            child: Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 4,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    movie.posterUrl, // Menggunakan properti yang benar
                    width: 100,
                    height: 150,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Container(
                      width: 100,
                      height: 150,
                      color: Colors.grey[200],
                      child: const Icon(Icons.movie, color: Colors.grey, size: 40),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
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
                          const SizedBox(height: 8),
                          Text(
                            movie.genres.join(', '),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${movie.year} • ${movie.duration}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
