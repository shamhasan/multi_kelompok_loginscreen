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
}
