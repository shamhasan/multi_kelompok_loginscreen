import 'package:flutter/foundation.dart';
import 'package:multi_kelompok/models/review.dart';

// Kelas ini akan menjadi pusat data dan logika untuk review
class ReviewProvider with ChangeNotifier {

  // List privat untuk menyimpan data review (saat ini masih data dummy)
  final List<Review> _reviews = [
    // Reviews for Movie ID '1' (Dune: Part Two)
    Review(
      id: 'rev1',
      userId: 'user123',
      movieId: '1', 
      rating: 9.0,
      comment: 'Sinematografinya luar biasa! Ceritanya juga lebih dalam dari film pertama.',
    ),
    Review(
      id: 'rev2',
      userId: 'user456',
      movieId: '1', 
      rating: 10.0,
      comment: 'Salah satu film sci-fi terbaik dekade ini. Wajib tonton!',
    ),
    Review(
      id: 'rev3',
      userId: 'user789',
      movieId: '1',
      rating: 8.5,
      comment: 'Sound design-nya menggelegar di bioskop. Pengalaman yang imersif.',
    ),
    Review(
      id: 'rev10',
      userId: 'movieFanatic',
      movieId: '1',
      rating: 9.5,
      comment: 'Visualnya breathtaking! Salah satu sekuel terbaik.',
    ),
    Review(
      id: 'rev11',
      userId: 'cinemaLover',
      movieId: '1',
      rating: 8.0,
      comment: 'Ceritanya agak lambat di awal, tapi akhirnya epik.',
    ),

    // Reviews for Movie ID '2' (Wednesday)
    Review(
      id: 'rev4',
      userId: 'user101',
      movieId: '2',
      rating: 9.0,
      comment: 'Jenna Ortega IS Wednesday Addams. Serial yang sempurna.',
    ),
    Review(
      id: 'rev5',
      userId: 'user112',
      movieId: '2',
      rating: 8.0,
      comment: 'Misterinya seru untuk diikuti, dan gayanya sangat ikonik. Suka sekali!',
    ),
    Review(
      id: 'rev12',
      userId: 'gothicHeart',
      movieId: '2',
      rating: 9.5,
      comment: 'Tim Burton\'s magic is back! Jenna Ortega is amazing.',
    ),
    Review(
      id: 'rev13',
      userId: 'seriesWatcher',
      movieId: '2',
      rating: 8.5,
      comment: 'Humor gelapnya pas banget. Gak sabar nunggu season 2.',
    ),

    // Reviews for Movie ID '3' (Furiosa: A Mad Max Saga)
    Review(
      id: 'rev6',
      userId: 'user131',
      movieId: '3',
      rating: 9.5,
      comment: 'Anya Taylor-Joy tampil memukau. Penuh aksi dari awal sampai akhir!',
    ),
     Review(
      id: 'rev7',
      userId: 'user415',
      movieId: '3',
      rating: 8.5,
      comment: 'Visual dunianya Mad Max tidak pernah mengecewakan. Brutal dan indah.',
    ),
    Review(
      id: 'rev14',
      userId: 'actionJunkie',
      movieId: '3',
      rating: 10.0,
      comment: 'Aksi tanpa henti! Gila, keren, dan brutal. George Miller is a master.',
    ),
     Review(
      id: 'rev15',
      userId: 'wastelander',
      movieId: '3',
      rating: 8.0,
      comment: 'Dementus adalah villain yang menarik. Chris Hemsworth tampil beda.',
    ),

    // Reviews for Movie ID '4' (Inside Out 2)
    Review(
      id: 'rev8',
      userId: 'user161',
      movieId: '4',
      rating: 9.0,
      comment: 'Sangat relevan untuk yang sedang beranjak dewasa. Emosi-emosi barunya lucu dan cerdas.',
    ),
    Review(
      id: 'rev9',
      userId: 'user718',
      movieId: '4',
      rating: 8.5,
      comment: 'Menyentuh dan juga lucu. Ansietas jadi karakter favorit baru saya.',
    ),
    Review(
      id: 'rev16',
      userId: 'animationFan',
      movieId: '4',
      rating: 10.0,
      comment: 'Nangis dan ketawa di saat yang bersamaan. Pixar melakukannya lagi!',
    ),
    Review(
      id: 'rev17',
      userId: 'anxietyAlly',
      movieId: '4',
      rating: 9.5,
      comment: 'Semua orang perlu nonton ini. Penggambaran Anxiety sangat akurat.',
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
