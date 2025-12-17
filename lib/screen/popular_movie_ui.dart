import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:multi_kelompok/models/movie_model.dart';
import 'package:multi_kelompok/providers/MovieProvider.dart';
import 'package:multi_kelompok/screen/movie_detail_screen.dart';

// Halaman ini sekarang lebih sederhana dan hanya bergantung pada MovieProvider.
class PopularMoviesPage extends StatefulWidget {
  const PopularMoviesPage({super.key});

  @override
  State<PopularMoviesPage> createState() => _PopularMoviesPageState();
}

class _PopularMoviesPageState extends State<PopularMoviesPage> {
  @override
  void initState() {
    super.initState();
    // Memanggil fungsi untuk mengambil data film populer dari provider.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MovieProvider>(context, listen: false).fetchPopularMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Film Populer'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      // Gunakan Consumer untuk mendengarkan perubahan dari MovieProvider.
      body: Consumer<MovieProvider>(
        builder: (context, provider, child) {
          // Tampilkan loading indicator jika sedang memuat.
          if (provider.isPopularLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          // Tampilkan pesan error jika terjadi kesalahan.
          if (provider.popularError.isNotEmpty) {
            return Center(child: Padding(padding: const EdgeInsets.all(16), child: Text(provider.popularError, textAlign: TextAlign.center)));
          }
          // Tampilkan pesan jika tidak ada film.
          if (provider.popularMovies.isEmpty) {
            return const Center(child: Text('Belum ada film di database.'));
          }

          final movies = provider.popularMovies;

          // Widget untuk fungsionalitas "pull-to-refresh".
          return RefreshIndicator(
            onRefresh: () => provider.fetchPopularMovies(),
            child: ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return _buildMovieListItem(context, movie);
              },
            ),
          );
        },
      ),
    );
  }

  // Widget untuk membangun satu item film (tidak berubah, hanya sumber datanya yang berbeda).
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
                builder: (context) => MovieDetailScreen(movieId: movie.id!),
              ),
            ).then((_) => Provider.of<MovieProvider>(context, listen: false).fetchPopularMovies());
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
                      Row(
                        children: [
                          Icon(Icons.thumb_up, color: Colors.green, size: detailSize + 2),
                          const SizedBox(width: 4),
                          Text(
                            movie.likes.toString(),
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
