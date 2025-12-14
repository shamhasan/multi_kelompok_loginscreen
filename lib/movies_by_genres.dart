import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:multi_kelompok/models/movie_model.dart';

// --- Model Genre (Tidak Berubah) ---
class Genre {
  final int id;
  String name;
  String? description;
  final DateTime createdAt;

  Genre({required this.id, required this.name, required this.createdAt, this.description});

  factory Genre.fromMap(Map<String, dynamic> map) {
    return Genre(
      id: map['id'] as int,
      name: map['name'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      description: map['description'] as String?,
    );
  }
}


final supabase = Supabase.instance.client;
const Color _primaryColor = Color(0xFF469756);
const Color _accentColor = Color(0xFF88D68A);

// ---------------------------------------------
// ⚙ LOGIKA SUPABASE (Tidak Berubah)
// ---------------------------------------------
const String ACTUAL_GENRE_FK_COLUMN = 'genres_id';

Future<List<Movie>> fetchMoviesByGenreId(int genreId) async {
  debugPrint('Mencari film untuk genre ID: $genreId, menggunakan kolom: $ACTUAL_GENRE_FK_COLUMN');
  try {
    final response = await supabase
        .from('movies')
        .select('*')
        .eq(ACTUAL_GENRE_FK_COLUMN, genreId);

    debugPrint('Hasil query Supabase: ${response.length} film ditemukan.');

    return (response as List)
        .map((item) => Movie.fromMap(item))
        .toList();

  } catch (e) {
    debugPrint('Error fetching movies by genre: $e');
    return [];
  }
}

// ---------------------------------------------
// 🎨 WIDGET HALAMAN (DIUBAH MENJADI StatelessWidget)
// ---------------------------------------------

class MoviesByGenrePage extends StatelessWidget { // 👈 Perubahan di sini
  final int genreId;
  final String genreName;

  const MoviesByGenrePage({
    super.key,
    required this.genreId,
    required this.genreName,
  });

  // Karena ini StatelessWidget, kita menggunakan FutureBuilder di metode build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('${genreName} Cinema'), // Menggunakan genreName
        backgroundColor: _primaryColor,
        titleTextStyle: const TextStyle(
            fontWeight: FontWeight.w900, fontSize: 22, color: Colors.white),
      ),
      body: FutureBuilder<List<Movie>>( // 👈 Mengganti stateful logic dengan FutureBuilder
        future: fetchMoviesByGenreId(genreId), // Panggil fungsi asinkronus
        builder: (context, snapshot) {
          // --- 1. KONDISI LOADING ---
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: _primaryColor));
          }

          // --- 2. KONDISI ERROR (Opsional) ---
          if (snapshot.hasError) {
            return Center(
              child: Text('Gagal memuat film: ${snapshot.error}', style: TextStyle(color: Colors.red)),
            );
          }

          // --- 3. KONDISI DATA KOSONG ---
          // snapshot.data bisa null, jadi gunakan List kosong jika null
          final movies = snapshot.data ?? [];
          if (movies.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.theaters_outlined,
                      size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 20),
                  Text(
                    'Oops! Belum ada film di box office genre $genreName.',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          // --- 4. KONDISI DATA ADA ---
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return FunMovieCard(movie: movie);
            },
          );
        },
      ),
    );
  }
}

// ---------------------------------------------
// WIDGET ITEM FILM BARU (FunMovieCard) - Tidak Berubah
// ---------------------------------------------

class FunMovieCard extends StatelessWidget {
  final Movie movie;

  const FunMovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          // TODO: Navigasi ke Halaman Detail Film (Fitur 1)
          debugPrint('Go to details of: ${movie.title}');
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Poster Film (30% Lebar Card)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: (movie.posterUrl != null && movie.posterUrl!.isNotEmpty)
                    ? Image.network(
                  movie.posterUrl ?? "https://via.placeholder.com/150",
                  width: 80,
                  height: 120,
                  fit: BoxFit.cover,
                  loadingBuilder: (c, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: 80,
                      height: 120,
                      color: Colors.grey[300],
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                          color: _accentColor, strokeWidth: 2),
                    );
                  },
                  errorBuilder: (c, o, s) => Container(
                    width: 80,
                    height: 120,
                    color: _primaryColor.withOpacity(0.1),
                    child: const Icon(Icons.movie_filter_outlined,
                        size: 40, color: _primaryColor),
                  ),
                )
                    : Container(
                  width: 80,
                  height: 120,
                  color: _primaryColor.withOpacity(0.1),
                  child: const Icon(Icons.movie_filter_outlined,
                      size: 40, color: _primaryColor),
                ),
              ),
              const SizedBox(width: 16),

              // 2. Detail Film (70% Lebar Card)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Judul Film ---
                    Text(
                      movie.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                          color: Colors.black87),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),

                    // --- Status Film (Now Playing/Upcoming) ---
                    if (movie.isNowPlaying)
                      const Chip(
                        avatar:
                        Icon(Icons.star, color: Colors.white, size: 16),
                        label: Text('NOW PLAYING',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10)),
                        backgroundColor: Colors.redAccent,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: EdgeInsets.zero,
                      )
                    else
                      const Chip(
                        avatar:
                        Icon(Icons.schedule, color: Colors.white, size: 16),
                        label: Text('UPCOMING',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10)),
                        backgroundColor: Colors.blueGrey,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: EdgeInsets.zero,
                      ),
                    const SizedBox(height: 8),

                    // --- Sinopsis Singkat ---
                    Text(
                      movie.overview ?? 'Sinopsis tidak tersedia.',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),

                    // --- Vote Count ---
                    Row(
                      children: [
                        Icon(Icons.thumb_up_alt_outlined,
                            color: _primaryColor, size: 16),
                        const SizedBox(width: 6),
                        Text('${movie.voteCount} Likes',
                            style: TextStyle(
                                fontSize: 12,
                                color: _primaryColor,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}