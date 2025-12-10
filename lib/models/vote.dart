class Vote {
  final int id;
  final String userId;
  final int movieId;
  final bool isLike;

  Vote({
    required this.id,
    required this.userId,
    required this.movieId,
    required this.isLike,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'movie_id': movieId,
      'is_like': isLike,
    };
  }

  factory Vote.fromJson(Map<String, dynamic> json) {
    return Vote(
      id: json['id'],
      userId: json['user_id'],
      movieId: json['movie_id'],
      isLike: json['is_like'],
    );
  }
}
