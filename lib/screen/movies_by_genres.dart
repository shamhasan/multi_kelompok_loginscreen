import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:multi_kelompok/models/movie.dart'; // Model dipindahkan ke sini

// ---------------------------------------------
// 1. MODEL DATA (Dipersingkat dan Disesuaikan)
// ---------------------------------------------

class Movie {
  final int id;
  final String title;
  final String? overview;
  final String? posterUrl;
  final bool isNowPlaying;
  final int voteCount;
  final DateTime createdAt;

  Movie({
    required this.id,
    required this.title,
    required this.isNowPlaying,
    required this.voteCount,
    required this.createdAt,
    this.overview,
    this.posterUrl,
  });

  factory Movie.fromMap(Map<String, dynamic> map) {
    // Pastikan nilai non-nullable memiliki fallback yang kuat
    final String titleValue = map['title'] as String? ?? 'Judul Film Tidak Diketahui';

    return Movie(
      id: map['id'] as int,
      title: titleValue,
      // Menggunakan kolom 'description' dari DB untuk 'overview'
      overview: map['description'] as String?,
      posterUrl: map['poster_url'] as String?,
      isNowPlaying: map['is_now_playing'] as bool? ?? false, // Fallback untuk bool
      voteCount: map['vote_count'] as int? ?? 0, // Fallback untuk int
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}

// Model Genre tidak berubah
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


// ---------------------------------------------
// 2. KONSTANTA DAN LOGIKA SUPABASE
// ---------------------------------------------

// Asumsikan Supabase sudah diinisialisasi
final supabase = Supabase.instance.client;
const Color _primaryColor = Color(0xFF469756);
const Color _accentColor = Color(0xFF88D68A);

// Kolom FK yang mengaitkan film dengan genre
const String ACTUAL_GENRE_FK_COLUMN = 'genres_id';

Future<List<Movie>> fetchMoviesByGenreId(int genreId) async {
  debugPrint('Mencari film untuk genre ID: $genreId, menggunakan kolom: $ACTUAL_GENRE_FK_COLUMN');
  try {
    // Menggunakan list<Map<String, dynamic>>
    final List<dynamic> response = await supabase
        .from('movies')
        .select('*')
        .eq(ACTUAL_GENRE_FK_COLUMN, genreId);

    debugPrint('Hasil query Supabase: ${response.length} film ditemukan.');

    // Mapping harus mengiterasi List<dynamic>
    return response.map((item) => Movie.fromMap(item as Map<String, dynamic>)).toList();

  } on PostgrestException catch (e) {
    debugPrint('Postgrest Error fetching movies by genre: ${e.message}');
    return [];
  } catch (e) {
    debugPrint('Error fetching movies by genre: $e');
    return [];
  }
}

// ---------------------------------------------
// 3. WIDGET HALAMAN UTAMA (MoviesByGenrePage)
// ---------------------------------------------

class MoviesByGenrePage extends StatelessWidget {
  final int genreId;
  final String genreName;

  const MoviesByGenrePage({
    super.key,
    required this.genreId,
    required this.genreName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('${genreName} Cinema'),
        backgroundColor: _primaryColor,
        titleTextStyle: const TextStyle(
            fontWeight: FontWeight.w900, fontSize: 22, color: Colors.white),
      ),
      body: FutureBuilder<List<Movie>>(
        future: fetchMoviesByGenreId(genreId),
        builder: (context, snapshot) {
          // 1. KONDISI ERROR
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 50, color: Colors.red),
                    const SizedBox(height: 10),
                    Text('Gagal memuat film: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red), textAlign: TextAlign.center,),
                  ],
                ),
              ),
            );
          }

          // 2. KONDISI LOADING
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: _primaryColor));
          }

          // 3. KONDISI DATA KOSONG
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

          // 4. KONDISI DATA ADA
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
// 4. WIDGET ITEM FILM (FunMovieCard)
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
          // TODO: Navigasi ke Halaman Detail Film
          debugPrint('Go to details of: ${movie.title}');
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Poster Film
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _buildMoviePoster(context, movie.posterUrl),
              ),
              const SizedBox(width: 16),

              // 2. Detail Film
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

                    // --- Status Film ---
                    _buildStatusChip(movie.isNowPlaying),
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

  // Helper untuk Poster Film
  Widget _buildMoviePoster(BuildContext context, String? posterUrl) {
    const double posterWidth = 80;
    const double posterHeight = 120;
    const String placeholderUrl = "https://via.placeholder.com/150";
    final effectiveUrl = (posterUrl != null && posterUrl.isNotEmpty) ? posterUrl : placeholderUrl;

    return Image.network(
      effectiveUrl,
      width: posterWidth,
      height: posterHeight,
      fit: BoxFit.cover,
      loadingBuilder: (c, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          width: posterWidth,
          height: posterHeight,
          color: Colors.grey[300],
          alignment: Alignment.center,
          child: const CircularProgressIndicator(
              color: _accentColor, strokeWidth: 2),
        );
      },
      errorBuilder: (c, o, s) => Container(
        width: posterWidth,
        height: posterHeight,
        color: _primaryColor.withOpacity(0.1),
        child: const Icon(Icons.movie_filter_outlined,
            size: 40, color: _primaryColor),
      ),
    );
  }

  // Helper untuk Chip Status
  Widget _buildStatusChip(bool isNowPlaying) {
    if (isNowPlaying) {
      return const Chip(
        avatar: Icon(Icons.star, color: Colors.white, size: 16),
        label: Text('NOW PLAYING',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 10)),
        backgroundColor: Colors.redAccent,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.zero,
      );
    } else {
      return const Chip(
        avatar: Icon(Icons.schedule, color: Colors.white, size: 16),
        label: Text('UPCOMING',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 10)),
        backgroundColor: Colors.blueGrey,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.zero,
      );
    }
  }
}