import 'package:flutter/material.dart';
import 'package:multi_kelompok/models/age_rating_model.dart';
import 'package:multi_kelompok/models/movie_model.dart';
import 'package:multi_kelompok/models/genre.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MovieProvider extends ChangeNotifier {
  final SupabaseClient _client = Supabase.instance.client;

  // State untuk daftar film utama (digunakan di admin, dll)
  List<Movie> _movies = [];
  List<Movie> get movies => _movies;

  // State terpisah untuk film populer
  List<Movie> _popularMovies = [];
  List<Movie> get popularMovies => _popularMovies;
  bool _isPopularLoading = true;
  bool get isPopularLoading => _isPopularLoading;
  String _popularError = '';
  String get popularError => _popularError;

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
    fetchMovies();
  }

  void setFilterGenre(String? value) {
    _filterByGenre = value;
    fetchMovies();
  }

  // Fungsi untuk mengambil daftar film utama (untuk admin, dll)
  Future<void> fetchMovies() async {
    try {
      var query = _client.from("movies").select();

      if (_filterByGenre != null && _filterByGenre != 'All') {
        query = query.contains('genres', [filterByGenre!]);
      }

      PostgrestTransformBuilder finalQuery;

      if (_sortBy == 'likes_high') {
        finalQuery = query.order('likes', ascending: false);
      } else if (_sortBy == 'likes_low') {
        finalQuery = query.order('likes', ascending: true);
      } else if (_sortBy == 'title_az') {
        finalQuery = query.order('title', ascending: true);
      } else {
        finalQuery = query.order('created_at', ascending: false);
      }

      final response = await finalQuery;
      _movies = (response as List).map((item) => Movie.fromMap(item)).toList();
    } catch (e) {
      _errorMessage = "Terjadi kesalahan: $e";
      debugPrint("Error fetching movies: $e");
    } finally {
      notifyListeners();
    }
  }

  // fungsi untuk mengambil daftar film terpopuler
  Future<void> fetchPopularMovies() async {
    _isPopularLoading = true;
    _popularError = '';
    notifyListeners();

    try {
      final response = await _client
          .from('movies')
          .select()
          .order('likes', ascending: false);

      _popularMovies = (response as List).map((item) => Movie.fromMap(item)).toList();
    } catch (e) {
      _popularError = 'Gagal memuat film populer: $e';
      debugPrint(_popularError);
    } finally {
      _isPopularLoading = false;
      notifyListeners();
    }
  }


  Future<void> fetchGenres() async {
    try {
      final response = await _client.from("genres").select().order('name', ascending: true);
      _genres = (response as List).map((item) => Genre.fromMap(item)).toList();
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching genres: $e");
      notifyListeners();
    }
  }

  Future<void> fetchAgeRatings() async {
    try {
      final response = await _client.from("age_ratings").select().order('name', ascending: true);
      _ageRatings = (response as List).map((item) => AgeRating.fromMap(item)).toList();
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching age ratings: $e");
      notifyListeners();
    }
  }

  Future<bool> addMovie(Movie movie) async {
    try {
      await _client.from('movies').insert(movie.toMap());
      await fetchMovies();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> addGenre(Genre genre) async {
    try {
      await _client.from('genres').insert(genre.toMap());
      await fetchGenres();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> updateMovie(Movie movie) async {
    try {
      await _client.from('movies').update(movie.toMap()).eq('id', movie.id!);
      await fetchMovies();
    } catch (e) {
      debugPrint("Error updating movie: $e");
      rethrow;
    }
  }

  Future<void> deleteMovie(int movieId) async {
    try {
      await _client.from('movies').delete().eq('id', movieId);
      _movies.removeWhere((movie) => movie.id == movieId);
      notifyListeners();
    } catch (e) {
      debugPrint("Error deleting movie: $e");
      rethrow;
    }
  }
}