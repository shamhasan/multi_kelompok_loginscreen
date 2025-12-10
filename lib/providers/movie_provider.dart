import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../data/movie.dart'; // <-- Import data dummy yang baru

class MovieProvider with ChangeNotifier {
  List<Movie> _moviesByGenre = [];
  bool _isLoading = false;

  List<Movie> get moviesByGenre => _moviesByGenre;
  bool get isLoading => _isLoading;

  // Fungsi untuk mengambil film berdasarkan Nama Genre
  // (Asumsi di sini, MovieProvider memfilter berdasarkan nama genre)
  Future<void> fetchMoviesByGenre(BuildContext context, String genreName) async {
    _isLoading = true;
    _moviesByGenre = []; // Kosongkan list sebelumnya
    notifyListeners();

    try {
      // Simulasi jeda API call
      await Future.delayed(const Duration(milliseconds: 500));

      // Logika pemfilteran film berdasarkan nama genre
      _moviesByGenre = allMovies.where((movie) {
        // Cek apakah list genres milik film mengandung nama genre yang dicari
        return movie.genres.contains(genreName);
      }).toList();

    } catch (e) {
      print("Error fetching movies by genre: $e");
      // Di sini Anda bisa menambahkan logika notifikasi error
    }

    _isLoading = false;
    notifyListeners();
  }
}