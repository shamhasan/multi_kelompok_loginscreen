import 'dart:convert';

class Movie {
  final int id;
  final String title;
  final String imageUrl;
  final double rating;
  final String overview;
  final List<String> genres;
  final int year;
  final String duration;
  final String ageRating;
  final bool isNowPlaying; // Properti baru

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
    required this.isNowPlaying, // Diperbarui di constructor
  });

  // Factory constructor untuk membuat instance Movie dari JSON
  factory Movie.fromJson(Map<String, dynamic> json) {
    List<String> genresList;
    if (json['genres'] is String) {
      String genresString = json['genres'].replaceAll('{', '').replaceAll('}', '');
      genresList = genresString.split(',');
    } else if (json['genres'] is List) {
      genresList = List<String>.from(json['genres']);
    } else {
      genresList = [];
    }

    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'N/A',
      posterUrl: json['poster_url'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(), 
      overview: json['description'] ?? 'No overview available.', 
      genres: genresList,
      year: json['year'] ?? 0,
      duration: json['duration'] ?? 'N/A',
      ageRating: json['age_rating'] ?? 'N/A',
      isNowPlaying: json['is_now_playing'] ?? false, // Diperbarui di fromJson
    );
  }
}
