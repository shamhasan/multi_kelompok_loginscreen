import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:multi_kelompok/models/movie.dart';

class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterUrl;
  final bool isNowPlaying;
  final int voteCount;
  final DateTime createdAt;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterUrl,
    required this.isNowPlaying,
    required this.voteCount,
    required this.createdAt,
  });

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'] as int,
      title: map['title'] as String,
      overview: map['overview'] as String,
      posterUrl: map['poster_url'] as String,
      isNowPlaying: map['is_now_playing'] as bool,
      voteCount: map['vote_count'] as int,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}

// Model Genre (Seperti yang sudah Anda miliki)
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

// Asumsi model Movie dan Genre sudah di-import atau dideklarasikan di atas file ini.
final supabase = Supabase.instance.client;
const Color _primaryColor = Color(0xFF469756); // Warna tema yang sama

// ---------------------------------------------
// ⚙️ LOGIKA SUPABASE
// ---------------------------------------------

Future<List<Movie>> fetchMoviesByGenreId(int genreId) async {
  try {
    // Query menggunakan JOIN dengan notasi Supabase:
    // 1. Ambil semua kolom dari tabel 'movies'
    // 2. JOIN ke tabel 'movie_genres' (!inner memastikan hanya data yang berelasi yang diambil)
    // 3. FILTER berdasarkan genre_id yang cocok
    final response = await supabase
        .from('movies')
        .select('''
          id, title, overview, poster_url, is_now_playing, vote_count, created_at,
          movie_genres!inner(genre_id) 
        ''')
        .eq('movie_genres.genre_id', genreId);

    // Konversi hasil respons ke List<Movie>
    return (response as List)
        .map((item) => Movie.fromMap(item))
        .toList();

  } catch (e) {
    // Di lingkungan produksi, gunakan logger.
    debugPrint('Error fetching movies by genre: $e');
    return [];
  }
}

class fromMap {
}

// ---------------------------------------------
// 🎨 WIDGET HALAMAN
// ---------------------------------------------

class MoviesByGenrePage extends StatefulWidget {
  final int genreId;
  final String genreName;

  const MoviesByGenrePage({
    super.key,
    required this.genreId,
    required this.genreName,
  });

  @override
  State<MoviesByGenrePage> createState() => _MoviesByGenrePageState();
}

class _MoviesByGenrePageState extends State<MoviesByGenrePage> {
  List<Movie> _movies = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMovies(); // Panggil fungsi pengambilan data saat widget dibuat
  }

  Future<void> _loadMovies() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    final movies = await fetchMoviesByGenreId(widget.genreId);

    if (!mounted) return;
    setState(() {
      _movies = movies;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.genreName} Films'), // Judul dinamis: Misal "Action Films"
        backgroundColor: _primaryColor,
        titleTextStyle: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: _primaryColor))
          : _movies.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.theaters, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 20),
            Text(
              'Tidak ada film dalam genre ${widget.genreName}.',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _movies.length,
        itemBuilder: (context, index) {
          final movie = _movies[index];
          return MovieListItem(movie: movie);
        },
      ),
    );
  }
}

// ---------------------------------------------
// WIDGET ITEM FILM (Custom ListItem)
// ---------------------------------------------

class MovieListItem extends StatelessWidget {
  final Movie movie;

  const MovieListItem({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: movie.posterUrl.isNotEmpty
              ? Image.network(
            movie.posterUrl,
            width: 50,
            height: 80,
            fit: BoxFit.cover,
            errorBuilder: (c, o, s) => const Icon(Icons.movie, size: 50),
          )
              : const Icon(Icons.movie, size: 50, color: _primaryColor),
        ),
        title: Text(
          movie.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                movie.overview,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text('${movie.voteCount} Votes', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                ],
              ),
            ],
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // TODO: Navigasi ke Halaman Detail Film (Fitur 1)
          debugPrint('Go to details of: ${movie.title}');
        },
      ),
    );
  }
}