import 'package:flutter/material.dart';
import 'package:multi_kelompok/models/movie_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WatchlistProvider with ChangeNotifier {
  // Instance Supabase
  final SupabaseClient _supabase = Supabase.instance.client;

  List<Movie> _watchlistMovies = [];
  final Set<int> _watchlistIds = {};
  bool _isLoading = false;

  List<Movie> get watchlist => _watchlistMovies;
  bool get isLoading => _isLoading;

  // --- PERBAIKAN UTAMA DI SINI ---
  // Kita buat getter pintar. Setiap kali dipanggil, dia langsung tanya Supabase:
  // "Siapa user yang lagi login sekarang?"
  String? get currentUserId {
    return _supabase.auth.currentUser?.id;
  }

  // --- 1. LOAD DATA ---
  Future<void> loadWatchlist() async {
    final userId = currentUserId; // Ambil ID langsung dari Supabase

    // Debugging: Biar kita tau di console apa yang terjadi
    print("DEBUG LOAD: User ID saat ini adalah: $userId");

    if (userId == null) {
      _watchlistMovies = [];
      _watchlistIds.clear();
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _supabase
          .from('watchlist')
          .select('movie_id, movies(*)')
          .eq('user_id', userId) // Pakai userId yang baru didapat
          .order('created_at', ascending: false);

      _watchlistMovies = [];
      _watchlistIds.clear();

      for (var item in response) {
        final movieData = item['movies'];
        final movieIdFromDb = item['movie_id'];

        if (movieData != null) {
          _watchlistMovies.add(Movie.fromMap(movieData));
        }
        if (movieIdFromDb != null) {
          _watchlistIds.add(movieIdFromDb as int);
        }
      }
    } catch (e) {
      debugPrint('Error fetching watchlist: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --- 2. CEK STATUS (Dipakai tombol Bookmark) ---
  bool isMovieInWatchlist(String movieIdString) {
    final int? id = int.tryParse(movieIdString);
    if (id == null) return false;
    return _watchlistIds.contains(id);
  }

  // --- 3. TOGGLE (TAMBAH/HAPUS) ---
  Future<void> toggleWatchlist(String movieIdString, BuildContext context) async {
    final userId = currentUserId; // Ambil ID langsung dari Supabase

    // DEBUGGING PENTING
    print("DEBUG TOGGLE: Mencoba akses watchlist dengan User ID: $userId");

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan login terlebih dahulu (Sesi Tidak Ditemukan)')),
      );
      return;
    }

    final int? movieId = int.tryParse(movieIdString);
    if (movieId == null) return;

    final isAlreadyIn = _watchlistIds.contains(movieId);

    try {
      if (isAlreadyIn) {
        // --- HAPUS ---
        // Optimistic UI Update (Update tampilan dulu biar cepet)
        _watchlistIds.remove(movieId);
        _watchlistMovies.removeWhere((m) => m.id.toString() == movieIdString);
        notifyListeners();

        await _supabase
            .from('watchlist')
            .delete()
            .eq('user_id', userId)
            .eq('movie_id', movieId);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dihapus dari Watchlist')),
        );
      } else {
        // --- TAMBAH ---
        await _supabase.from('watchlist').insert({
          'user_id': userId,
          'movie_id': movieId,
        });

        // Ambil ulang data biar sinkron
        await loadWatchlist();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ditambahkan ke Watchlist')),
        );
      }
    } catch (e) {
      debugPrint('Error toggling watchlist: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal: $e')),
      );
      // Kalau gagal, load ulang biar data balik ke kondisi asli
      await loadWatchlist();
    }
  }
}