class Movie {
  final int? id;
  final String title;
  final String overview;
  final String posterUrl;
  final bool isNowPlaying;
  final int voteCount;
  final double rating;
  final int year;
  final String duration;
  final String ageRating;
  final List<String> genres;

  Movie({
    this.id,
    required this.title,
    required this.overview,
    required this.posterUrl,
    required this.isNowPlaying,
    required this.voteCount,
    required this.rating,
    required this.year,
    required this.duration,
    required this.ageRating,
    required this.genres,
  });

  // Factory: Mengubah JSON (Map) dari Supabase menjadi Object Movie
  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'],
      title: map['title'] ?? '',

      // PERHATIKAN: Mapping nama kolom beda
      overview: map['description'] ?? '',
      posterUrl: map['poster_url'] ?? '',
      isNowPlaying: map['is_now_playing'] ?? false,
      voteCount: map['vote_count'] ?? 0,

      // Konversi aman ke double (karena DB bisa return int atau float)
      rating: (map['rating'] ?? 0).toDouble(),

      // Handle field yang di DB boleh null
      year: map['year'] ?? 0,
      duration: map['duration'] ?? '',
      ageRating: map['age_rating'] ?? '',

      // Konversi Array Postgres (text[]) ke List<String> Dart
      genres: List<String>.from(map['genres'] ?? []),
    );
  }

  // Method: Mengubah Object Movie menjadi JSON untuk dikirim ke Supabase
  Map<String, dynamic> toMap() {
    return {
      // id biasanya tidak dikirim saat insert (biar auto increment)
      'title': title,
      'description': overview, // Kirim sebagai 'description'
      'poster_url': posterUrl,
      'is_now_playing': isNowPlaying,
      'vote_count': voteCount,
      'rating': rating,
      'year': year,
      'duration': duration,
      'age_rating': ageRating,
      'genres': genres, // Supabase otomatis handle List<String> jadi array text[]
    };
  }
}