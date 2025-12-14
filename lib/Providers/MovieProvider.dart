import 'package:flutter/material.dart';
import 'package:multi_kelompok/models/age_rating_model.dart';
import 'package:multi_kelompok/models/genre_model.dart';
import 'package:multi_kelompok/models/movie_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
        query = query.contains('genres', [filterByGenre!]);
      }

      PostgrestTransformBuilder finalQuery;

      // PERBAIKAN: Hapus 'rating' dan ganti dengan 'likes'
      if (_sortBy == 'likes_high') {
        finalQuery = query.order('likes', ascending: false);
      } else if (_sortBy == 'likes_low') {
        finalQuery = query.order('likes', ascending: true);
      } else if (_sortBy == 'title_az') {
        finalQuery = query.order('title', ascending: true);
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

  Future<void> fetchGenres() async {
    try {
      final response = await _client
          .from("genres")
          .select()
          .order('name', ascending: true);

      final List<dynamic> data = response as List<dynamic>;
      _genres = data.map((item) => Genre.fromMap(item)).toList();
    } catch (e) {
      _errorMessage = "Terjadi kesalahan: $e";
      debugPrint("Error fetching genres: $e");
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

      await _client.from('movies').insert(movie.toMap());

      await fetchMovies();
      notifyListeners();
      return true;
    } catch (e) {
      notifyListeners();
      _errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> addGenre(Genre genre) async {
    try {
      notifyListeners();

      await _client.from('genres').insert(genre.toMap());

      await fetchGenres();
      notifyListeners();
      return true;
    } catch (e) {
      notifyListeners();
      _errorMessage = e.toString();
      return false;
    }
  }

  Future<void> updateMovie(Movie movie) async {
    try {
      notifyListeners();
      await _client.from('movies').update(movie.toMap()).eq('id', movie.id!);

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

      _movies.removeWhere((movie) => movie.id == movieId);
      notifyListeners();
    } catch (e) {
      debugPrint("Error deleting movie: $e");
      rethrow;
    }
  }
}
