import 'dart:convert';

class Movie {
  final int id;
  final String title;
  final String posterUrl;
  final double rating;
  final String overview;
  final List<String> genres;
  final int year;
  final String duration;
  final String ageRating;

  Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.rating,
    required this.overview,
    required this.genres,
    required this.year,
    required this.duration,
    required this.ageRating,
  });

  // Factory constructor untuk membuat instance Movie dari JSON
  factory Movie.fromJson(Map<String, dynamic> json) {
    // Mengatasi genres yang bisa jadi String atau List
    List<String> genresList;
    if (json['genres'] is String) {
      // Jika genres adalah string seperti "{Action,Drama}"
      String genresString = json['genres'].replaceAll('{', '').replaceAll('}', '');
      genresList = genresString.split(',');
    } else if (json['genres'] is List) {
      // Jika genres sudah dalam bentuk List<dynamic>
      genresList = List<String>.from(json['genres']);
    } else {
      genresList = [];
    }

    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'N/A',
      posterUrl: json['poster_url'] ?? '',
      // Menggunakan 'rating' dari database jika ada, jika tidak, default ke 0.0
      rating: (json['rating'] ?? 0.0).toDouble(), 
      overview: json['description'] ?? 'No overview available.', // Menggunakan 'description' dari tabel Anda
      genres: genresList,
      year: json['year'] ?? 0,
      duration: json['duration'] ?? 'N/A',
      ageRating: json['age_rating'] ?? 'N/A',
    );
  }
}
