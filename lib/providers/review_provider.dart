import 'package:flutter/foundation.dart';
import 'package:multi_kelompok/models/review.dart';

// Kelas ini akan menjadi pusat data dan logika untuk review
class ReviewProvider with ChangeNotifier {

  // List privat untuk menyimpan data review (saat ini masih data dummy)
  final List<Review> _reviews = [
    Review(
      id: 'rev1',
      userId: 'user123',
      movieId: '1', // ID dari film 'Dune: Part Two'
      rating: 9.0,
      comment: 'Sinematografinya luar biasa! Ceritanya juga lebih dalam dari film pertama.',
    ),
    Review(
      id: 'rev2',
      userId: 'user456',
      movieId: '1', // ID dari film 'Dune: Part Two'
      rating: 10.0,
      comment: 'Salah satu film sci-fi terbaik dekade ini. Wajib tonton!',
    ),
  ];

  List<Review> get reviews => _reviews;

  List<Review> getReviewsForMovie(String movieId) {
    return _reviews.where((review) => review.movieId == movieId).toList();
  }

  List<Review> getReviewsByUser(String userId) {
    return _reviews.where((review) => review.userId == userId).toList();
  }

  // FUNGSI BARU: Menghitung rata-rata rating untuk sebuah film
  double getAverageRating(String movieId) {
    final movieReviews = getReviewsForMovie(movieId);
    if (movieReviews.isEmpty) {
      return 0.0; // Jika tidak ada review, ratingnya 0
    }
    // Menjumlahkan semua rating dan membaginya dengan jumlah review
    final totalRating = movieReviews.fold<double>(0.0, (sum, item) => sum + item.rating);
    return totalRating / movieReviews.length;
  }

  void addReview(Review review) {
    _reviews.add(review);
    notifyListeners();
  }

  void updateReview(Review updatedReview) {
    final index = _reviews.indexWhere((review) => review.id == updatedReview.id);
    if (index != -1) {
      _reviews[index] = updatedReview;
      notifyListeners();
    }
  }

  void deleteReview(String reviewId) {
    _reviews.removeWhere((review) => review.id == reviewId);
    notifyListeners();
  }
}
