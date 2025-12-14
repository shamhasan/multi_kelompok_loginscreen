class Movie {
  final String id;
  final String title;
  final String imageUrl;
  final double rating;
  final String overview;
  final List<String> genres;
  final int year;
  final String duration;
  final String ageRating;

  Movie({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.rating,
    required this.overview,
    required this.genres,
    required this.year,
    required this.duration,
    required this.ageRating,
  });

  // Constructor factory untuk membuat objek Movie dari data JSON (Map)
  factory Movie.fromJson(Map<String, dynamic> json) {
    // Penanganan khusus untuk genres, karena ini adalah List<String>
    final List<dynamic> genresJson = json['genres'] ?? [];

    return Movie(
      id: json['id'] as String,
      title: json['title'] as String,
      imageUrl: json['imageUrl'] as String,
      // API seringkali mengembalikan rating sebagai int/double, kita pastikan di sini
      rating: (json['rating'] as num).toDouble(),
      overview: json['overview'] as String,
      // Mengubah List<dynamic> menjadi List<String>
      genres: genresJson.map((e) => e.toString()).toList(),
      year: json['year'] as int,
      duration: json['duration'] as String,
      ageRating: json['ageRating'] as String,
    );
  }

  // Anda juga bisa menambahkan method toJson() jika perlu mengirim data kembali ke API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'rating': rating,
      'overview': overview,
      'genres': genres,
      'year': year,
      'duration': duration,
      'ageRating': ageRating,
    };
  }
}