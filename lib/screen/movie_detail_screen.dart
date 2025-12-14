import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:multi_kelompok/models/movie_model.dart';
import 'package:multi_kelompok/providers/watchlist_provider.dart';
import 'package:multi_kelompok/widgets/vote_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MovieDetailScreen extends StatefulWidget {
  final int movieId;

  const MovieDetailScreen({super.key, required this.movieId});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  Movie? _movie;
  // PERBAIKAN: Mengganti nama variabel agar sesuai dengan fungsinya.
  int _likeCount = 0;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchMovie();
  }

  Future<void> _fetchMovie() async {
    if (mounted && !_isLoading) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      final movieResponse = await Supabase.instance.client
          .from('movies')
          .select()
          .eq('id', widget.movieId)
          .single();

      final dislikeResponse = await Supabase.instance.client
          .from('votes')
          .select('id')
          .eq('movie_id', widget.movieId)
          .eq('is_like', false);

      if (mounted) {
        setState(() {
          _movie = Movie.fromMap(movieResponse);
          // PERBAIKAN: Menyimpan jumlah dislike dengan benar.
          _likeCount = dislikeResponse.length;
          _isLoading = false;
          _error = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Gagal memuat detail film: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(backgroundColor: Colors.green, foregroundColor: Colors.white, elevation: 0),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null || _movie == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error'), backgroundColor: Colors.green, foregroundColor: Colors.white),
        body: Center(child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(_error ?? 'Film tidak ditemukan.'),
        )),
      );
    }

    final movie = _movie!;

    // DITAMBAHKAN: Consumer untuk mendapatkan akses ke WatchlistProvider
    return Consumer<WatchlistProvider>(
      builder: (context, watchlistProvider, child) {
        // Cek apakah film ini sudah ada di watchlist
        final bool isInWatchlist = watchlistProvider.isMovieInWatchlist(movie.id.toString());

        return Scaffold(
          appBar: AppBar(
            title: Text(movie.title),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            actions: [
              // DITAMBAHKAN: Tombol untuk menambah/menghapus watchlist
              IconButton(
                icon: Icon(
                  isInWatchlist ? Icons.bookmark_added : Icons.bookmark_add_outlined,
                  size: 28,
                ),
                onPressed: () {
                  // Panggil fungsi toggle dari provider
                  watchlistProvider.toggleWatchlist(movie.id.toString(), context);
                },
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: _fetchMovie,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          movie.posterUrl,
                          width: 120,
                          height: 180,
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => const Icon(Icons.movie_creation_outlined, size: 120, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(movie.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text('${movie.year} • ${movie.duration}', style: const TextStyle(fontSize: 16, color: Colors.black54)),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 6.0,
                              runSpacing: 4.0,
                              children: movie.genres.map((g) => Chip(label: Text(g.trim()), backgroundColor: Colors.lightGreen.shade100)).toList(),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.thumb_up, color: Colors.green, size: 16),
                                const SizedBox(width: 4),
                                Text(movie.likes.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(width: 16),
                                const Icon(Icons.thumb_down, color: Colors.red, size: 16),
                                const SizedBox(width: 4),
                                // PERBAIKAN: Menampilkan _dislikeCount yang sudah benar.
                                Text(_likeCount.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(movie.overview, style: const TextStyle(fontSize: 16, height: 1.5)),
                  const SizedBox(height: 24),
                  const Divider(thickness: 1),
                  const SizedBox(height: 16),
                  const Text('Berikan Penilaian Anda', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  VoteWidget(movieId: movie.id!, onVoted: _fetchMovie),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
