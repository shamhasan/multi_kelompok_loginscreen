import 'package:flutter/material.dart';
import 'dart:math';

import 'package:multi_kelompok/models/movie.dart';
import 'package:multi_kelompok/screens/movie_detail_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PopularMoviesPage extends StatefulWidget {
  const PopularMoviesPage({super.key});

  @override
  State<PopularMoviesPage> createState() => _PopularMoviesPageState();
}

class _PopularMoviesPageState extends State<PopularMoviesPage> {
  List<Movie> _movies = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchPopularMovies();
  }

  // Mengambil dan mengurutkan film langsung dari Supabase
  Future<void> _fetchPopularMovies() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      // PERBAIKAN: Mengurutkan berdasarkan 'likes'
      final moviesResponse = await Supabase.instance.client
          .from('movies')
          .select()
          .order('likes', ascending: false); // Urutkan dari like terbanyak

      if (mounted) {
        final allMovies = (moviesResponse as List).map((data) => Movie.fromJson(data)).toList();
        setState(() {
          _movies = allMovies;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Gagal memuat film populer: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Film Populer'),
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
      return Center(child: Padding(padding: const EdgeInsets.all(16), child: Text(_error!, textAlign: TextAlign.center)));
    }
    if (_movies.isEmpty) {
      return const Center(child: Text('Belum ada film di database.'));
    }

    return RefreshIndicator(
      onRefresh: _fetchPopularMovies,
      child: ListView.builder(
        itemCount: _movies.length,
        itemBuilder: (context, index) {
          final movie = _movies[index];
          return _buildMovieListItem(context, movie);
        },
      ),
    );
  }

  Widget _buildMovieListItem(BuildContext context, Movie movie) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double detailSize = screenWidth > 720 ? 14 : 12;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MovieDetailScreen(movieId: movie.id),
              ),
            ).then((_) => _fetchPopularMovies()); // Refresh saat kembali
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    movie.posterUrl,
                    width: 100,
                    height: 150,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => const Icon(Icons.movie, color: Colors.grey, size: 50),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(movie.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('${movie.year} • ${movie.duration}', style: TextStyle(color: Colors.grey[600], fontSize: detailSize)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6.0,
                        runSpacing: 4.0,
                        children: movie.genres.map((genre) => Chip(label: Text(genre.trim()), backgroundColor: Colors.green.shade100)).toList(),
                      ),
                      const SizedBox(height: 8),
                      // PERBAIKAN: Menampilkan HANYA jumlah likes
                      Row(
                        children: [
                          Icon(Icons.thumb_up, color: Colors.green, size: detailSize + 2),
                          const SizedBox(width: 4),
                          Text(
                            movie.likes.toString(), // Menggunakan movie.likes
                            style: TextStyle(fontSize: detailSize, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        movie.overview,
                        style: TextStyle(fontSize: detailSize, color: Colors.grey[700]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
