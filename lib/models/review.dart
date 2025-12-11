class Review {
  final String id;
  final String userId; // ID pengguna yang memberi review
  final String movieId; // ID film yang direview
  final double rating; // Rating (misal: 1.0 - 5.0)
  final String comment; // Komentar review

  Review({
    required this.id,
    required this.userId,
    required this.movieId,
    required this.rating,
    required this.comment,
  });
}
