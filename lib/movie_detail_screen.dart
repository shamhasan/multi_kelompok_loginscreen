import 'package:flutter/material.dart';
import 'package:multi_kelompok/models/movie.dart'; // Asumsi model Movie ada di sini
import 'package:multi_kelompok/widgets/add_review_form.dart';
import 'package:multi_kelompok/widgets/review_list.dart';

class MovieDetailScreen extends StatelessWidget {
  // Halaman ini menerima objek Movie untuk ditampilkan
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian Detail Film
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
                    errorBuilder: (context, error, stackTrace) => 
                      const Icon(Icons.movie_creation_outlined, size: 120),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${movie.year} • ${movie.duration}',
                        style: const TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6.0,
                        runSpacing: 4.0,
                        children: movie.genres.map((genre) => Chip(
                          label: Text(genre),
                          backgroundColor: Colors.lightGreen.shade100,
                          padding: EdgeInsets.zero,
                        )).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              movie.overview,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),

            const SizedBox(height: 24),
            const Divider(thickness: 1),
            const SizedBox(height: 16),

            // Bagian Review
            const Text(
              'Ulasan & Rating Pengguna',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Menampilkan daftar review menggunakan widget yang sudah dibuat
            ReviewList(movieId: movie.id), // Pastikan Movie model punya `id`

            const SizedBox(height: 24),
            const Divider(thickness: 1),
            const SizedBox(height: 16),

            // Bagian Form Tambah Review
            const Text(
              'Tulis Ulasan Anda',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Menampilkan form tambah review menggunakan widget yang sudah dibuat
            AddReviewForm(movieId: movie.id), // Pastikan Movie model punya `id`
          ],
        ),
      ),
    );
  }
}
