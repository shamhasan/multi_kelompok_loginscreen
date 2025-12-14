class Movie {
  final int? id;
  final String title;
  final String overview;
  final String posterUrl;
  final bool isNowPlaying;
  final int likes;
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
    required this.likes,
    required this.year,
    required this.duration,
    required this.ageRating,
    required this.genres,
  });

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'],
      title: map['title'] ?? '',
      overview: map['description'] ?? '',
      posterUrl: map['poster_url'] ?? '',
      isNowPlaying: map['is_now_playing'] ?? false,
      likes: map['likes'] ?? 0,
      year: map['year'] ?? 0,
      duration: map['duration'] ?? '',
      ageRating: map['age_rating'] ?? '',
      genres: List<String>.from(map['genres'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': overview,
      'poster_url': posterUrl,
      'is_now_playing': isNowPlaying,
      'likes': likes,
      'year': year,
      'duration': duration,
      'age_rating': ageRating,
      'genres': genres,
    };
  }
}