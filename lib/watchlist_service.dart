import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class WatchlistService {
  // --- CEK STATUS ---

  // Ambil ID watchlist berdasarkan movie ID (berguna untuk Delete)
  Future<int?> getWatchlistItemId(int movieId) async {
    final userId = supabase.auth.currentUser?.id; // Ambil userId secara lokal
    if (userId == null) return null;

    try {
      final response = await supabase
          .from('watchlist')
          .select('id')
          .eq('user_id', userId)
          .eq('movie_id', movieId)
          .single();
      return response['id'] as int?;
    } on PostgrestException catch (e) {
      // Baris tidak ditemukan (PostgrestException 406)
      if (e.code == '406') return null;
      rethrow;
    }
  }

  // Cek apakah film sudah ada di watchlist user
  Future<bool> isInWatchlist(int movieId) async {
    return (await getWatchlistItemId(movieId)) != null;
  }

  // --- CRUD OPERATIONS ---

  // CREATE (Tambah ke Watchlist)
  Future<void> addToWatchlist(int movieId) async {
    final userId = supabase.auth.currentUser?.id; // Ambil userId secara lokal
    if (userId == null) throw Exception("User not logged in");

    await supabase.from('watchlist').insert({
      'movie_id': movieId,
      'status': 'unwatched',
      'user_id': userId, // Gunakan userId
    });
  }

  // READ (Ambil Watchlist)
  Future<List<Map<String, dynamic>>> getWatchlist() async {
    final userId = supabase.auth.currentUser?.id; // Ambil userId secara lokal
    if (userId == null) return [];

    final response = await supabase
        .from('watchlist')
        .select('*, movies(*)')
        .eq('user_id', userId); // Filter berdasarkan userId

    return List<Map<String, dynamic>>.from(response);
  }

  // UPDATE (Ubah Status)
  Future<void> updateStatus(int watchlistId, String newStatus) async {
    await supabase
        .from('watchlist')
        .update({'status': newStatus})
        .eq('id', watchlistId);
  }

  // DELETE (Hapus dari Watchlist)
  Future<void> removeFromWatchlist(int watchlistId) async {
    await supabase.from('watchlist').delete().eq('id', watchlistId);
  }
}