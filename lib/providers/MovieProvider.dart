import 'package:flutter/material.dart';
import 'package:multi_kelompok/models/age_rating_model.dart';
import 'package:multi_kelompok/models/movie_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/genre.dart';

class MovieProvider extends ChangeNotifier {
  final SupabaseClient _client = Supabase.instance.client;

  List<Movie> _movies = [];
  List<Movie> get movies => _movies;

  List<Genre> _genres = [];
  List<Genre> get genres => _genres;

  List<AgeRating> _ageRatings = [];
  List<AgeRating> get ageRatings => _ageRatings;

  String? _sortBy = "newest";
  String? get sortBy => _sortBy;

  String? _filterByGenre;
  String? get filterByGenre => _filterByGenre;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  void setSortBy(String value) {
    _sortBy = value;
    fetchMovies(); // Langsung refresh data setelah ganti filter
  }

  void setFilterGenre(String? value) {
    _filterByGenre = value;
    fetchMovies(); // Langsung refresh data setelah ganti filter
  }

  Future<void> fetchMovies() async {
    try {
      var query = _client.from("movies").select();

      if (_filterByGenre != null && _filterByGenre != 'All') {
        // .contains digunakan karena kolom 'genres' di DB adalah Array
        query = query.contains('genres', [filterByGenre!]);
      }

      PostgrestTransformBuilder finalQuery;

      if (_sortBy == 'rating_high') {
        finalQuery = query.order(
          'rating',
          ascending: false,
        ); // Rating Tertinggi
      } else if (_sortBy == 'rating_low') {
        finalQuery = query.order('rating', ascending: true); // Rating Terendah
      } else if (_sortBy == 'title_az') {
        finalQuery = query.order('title', ascending: true); // Abjad A-Z
      } else {
        // Default: created_at (Terbaru)
        finalQuery = query.order('created_at', ascending: false);
      }

      final response = await finalQuery;
      final List<dynamic> data = response as List<dynamic>;

      _movies = data.map((item) => Movie.fromMap(item)).toList();
    } catch (e) {
      _errorMessage = "Terjadi kesalahan: $e";
      debugPrint("Error fetching movies: $e");
    }
  }


  Future<void> fetchAgeRatings() async {
    try {
      final response = await _client
          .from("age_ratings")
          .select()
          .order('name', ascending: true);

      final List<dynamic> data = response as List<dynamic>;
      _ageRatings = data.map((item) => AgeRating.fromMap(item)).toList();
    } catch (e) {
      _errorMessage = "Terjadi kesalahan: $e";
      debugPrint("Error fetching age ratings: $e");
    }
  }

  Future<bool> addMovie(Movie movie) async {
    try {
      notifyListeners();

      await _client.from('movies').insert(movie.toMap()).select();

      await fetchMovies();
      notifyListeners();
      return true;
    } catch (e) {

      notifyListeners();
      _errorMessage = e.toString();
      return false; // Beritahu UI kalau GAGAL
    }
  }


  Future<void> updateMovie(Movie movie) async {
    try {
      notifyListeners();
      await _client.from('movies').update(movie.toMap()).eq('id', movie.id!);

      // Refresh data lokal
      await fetchMovies();

      notifyListeners();
    } catch (e) {
      debugPrint("Error updating movie: $e");
      rethrow;
    }
  }

  Future<void> deleteMovie(int movieId) async {
    try {
      notifyListeners();
      await _client.from('movies').delete().eq('id', movieId);

      // Refresh data lokal
      _movies.removeWhere((movie) => movie.id == movieId);
      notifyListeners();
    } catch (e) {
      debugPrint("Error deleting movie: $e");
      rethrow;
    }
  }
}
