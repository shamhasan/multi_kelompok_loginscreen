import 'package:flutter/foundation.dart';
import 'package:multi_kelompok/models/vote.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VoteProvider with ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Menyimpan status vote dari pengguna saat ini
  final Map<int, bool?> _userVotes = {};
  Map<int, bool?> get userVotes => _userVotes;

  // Mengambil status vote pengguna untuk film tertentu
  Future<void> fetchUserVote(int movieId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      _userVotes[movieId] = null;
      notifyListeners();
      return;
    }

    try {
      final response = await _supabase
          .from('votes')
          .select('is_like')
          .eq('movie_id', movieId)
          .eq('user_id', userId)
          .maybeSingle();

      if (response != null) {
        _userVotes[movieId] = response['is_like'];
      } else {
        _userVotes[movieId] = null;
      }
    } catch (e) {
      debugPrint('Error fetching user vote: $e');
      _userVotes[movieId] = null;
    }
    notifyListeners();
  }

  // FUNGSI BARU: Menggunakan RPC untuk menangani semua logika vote
  Future<void> handleVote(int movieId, bool isLike) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    // 1. Optimistic UI Update: Langsung ubah state lokal untuk UI responsif
    final currentVote = _userVotes[movieId];
    if (currentVote == isLike) {
      // Jika vote dibatalkan (klik tombol yang sama lagi)
      _userVotes[movieId] = null;
    } else {
      // Jika vote baru atau ganti vote
      _userVotes[movieId] = isLike;
    }
    notifyListeners();

    try {
      // 2. Panggil fungsi RPC di Supabase
      await _supabase.rpc('handle_vote', params: {
        'movie_id_param': movieId,
        'is_like_param': isLike,
      });
    } catch (e) {
      // 3. Rollback: Jika ada error, kembalikan state UI ke semula
      debugPrint('Error handling vote: $e');
      _userVotes[movieId] = currentVote; // Kembalikan ke state sebelum diubah
      notifyListeners();
      // Opsional: Tampilkan pesan error ke pengguna
    }
  }

  // --- FUNGSI YANG HILANG (bisa dihapus jika tidak digunakan di tempat lain) ---
  Future<List<Vote>> getVotesByUser(String userId) async {
    try {
      final response = await _supabase
          .from('votes')
          .select()
          .eq('user_id', userId);

      final List<Vote> votes = (response as List).map((data) => Vote.fromJson(data)).toList();
      return votes;
    } catch (e) {
      debugPrint('Error fetching user votes: $e');
      return [];
    }
  }
}
