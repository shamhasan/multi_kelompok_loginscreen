class Vote {
  final int id;
  final String userId;
  final int movieId;
  final bool isLike; // true for like, false for dislike

  Vote({
    required this.id,
    required this.userId,
    required this.movieId,
    required this.isLike,
  });

  // Konversi objek Vote menjadi format JSON untuk dikirim ke Supabase
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'movie_id': movieId,
      'is_like': isLike,
    };
  }

  // Membuat objek Vote dari data JSON yang diterima dari Supabase
  factory Vote.fromJson(Map<String, dynamic> json) {
    return Vote(
      id: json['id'] as int,
      userId: json['user_id'] as String,
      movieId: json['movie_id'] as int,
      isLike: json['is_like'] as bool,
    );
  }
}
