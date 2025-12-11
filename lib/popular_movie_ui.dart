import 'package:flutter/material.dart';
import 'dart:math';

import 'package:multi_kelompok/models/movie.dart';
import 'package:multi_kelompok/providers/vote_provider.dart';

import 'package:multi_kelompok/screens/movie_detail_screen.dart';
import 'package:provider/provider.dart';
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
    _fetchInitialData();
  }

  // Mengambil data film dan data vote secara bersamaan
  Future<void> _fetchInitialData() async {
    try {
      // 1. Ambil data vote terlebih dahulu
      await Provider.of<VoteProvider>(context, listen: false).fetchAllVoteCounts();

      // 2. Ambil data film
      final response = await Supabase.instance.client
          .from('movies')
          .select();

      if (mounted) {
        setState(() {
          _movies = (response as List).map((data) => Movie.fromJson(data)).toList();
          _isLoading = false;
        });
      }

    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Gagal memuat data: $e';
          _isLoading = false;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Film Populer'),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        body: Center(child: Text(_error!)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Film Populer'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: _fetchInitialData, // Memungkinkan pull-to-refresh
        child: ListView.builder(
          itemCount: _movies.length,
          itemBuilder: (context, index) {
            final movie = _movies[index];
            return _buildMovieListItem(context, movie);
          },
        ),
      ),
    );
  }

  Widget _buildMovieListItem(BuildContext context, Movie movie) {
    final screenWidth = MediaQuery.of(context).size.width;

    const double maxPosterWidth = 200.0;
    final double posterWidth = min(screenWidth * 0.3, maxPosterWidth);
    final double posterHeight = posterWidth * 1.5;
    final double titleSize = screenWidth > 720 ? 18 : 16;
    final double detailSize = screenWidth > 720 ? 14 : 12;
    final double chipTextSize = screenWidth > 720 ? 12 : 11;

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
            ).then((_) => _fetchInitialData()); // Ambil ulang data saat kembali dari halaman detail
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: posterWidth,
                  height: posterHeight,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      movie.posterUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) =>
                      progress == null ? child : const Center(child: CircularProgressIndicator()),
                      errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.movie, color: Colors.grey, size: 40),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(movie.year.toString(), style: TextStyle(color: Colors.grey[600], fontSize: detailSize)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6.0),
                            child: Icon(Icons.circle, size: 3, color: Colors.grey[500]),
                          ),
                          Text(movie.duration, style: TextStyle(color: Colors.grey[600], fontSize: detailSize)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6.0,
                        runSpacing: 4.0,
                        children: movie.genres.map((genre) {
                          return Chip(
                            label: Text(genre.trim()),
                            backgroundColor: Colors.green.shade100,
                            labelStyle: TextStyle(color: Colors.green.shade900, fontSize: chipTextSize),
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 8),
                      Consumer<VoteProvider>(
                        builder: (context, voteProvider, child) {
                          final likes = voteProvider.likes[movie.id] ?? 0;
                          final dislikes = voteProvider.dislikes[movie.id] ?? 0;

                          return Row(
                            children: [
                              Icon(Icons.thumb_up, color: Colors.green, size: detailSize + 2),
                              const SizedBox(width: 4),
                              Text(
                                likes.toString(),
                                style: TextStyle(fontSize: detailSize, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 12),
                              Icon(Icons.thumb_down, color: Colors.red, size: detailSize + 2),
                              const SizedBox(width: 4),
                              Text(
                                dislikes.toString(),
                                style: TextStyle(fontSize: detailSize, fontWeight: FontWeight.bold),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      Text(
                        movie.overview,
                        style: TextStyle(fontSize: detailSize, color: Colors.grey[700]),
                        maxLines: 3, 
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
