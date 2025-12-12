import 'package:flutter/foundation.dart';
import 'package:multi_kelompok/models/vote.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VoteProvider with ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Hanya menyimpan status vote dari pengguna saat ini
  Map<int, bool?> _userVotes = {};
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
      print('Error fetching user vote: $e');
      _userVotes[movieId] = null;
    }
    notifyListeners();
  }

  // Fungsi untuk melakukan vote (suka)
  Future<void> vote(int movieId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    final currentVote = _userVotes[movieId];

    if (currentVote == true) { // Jika sudah suka, batalkan
      await _supabase.from('votes').delete().match({'movie_id': movieId, 'user_id': userId});
      _userVotes[movieId] = null;
    } else { // Jika belum vote atau sudah dislike, ubah menjadi suka
      await _supabase.from('votes').upsert({
        'movie_id': movieId,
        'user_id': userId,
        'is_like': true,
      }, onConflict: 'id'); // Menggunakan id sebagai onConflict
      _userVotes[movieId] = true;
    }
    notifyListeners();
  }

  // Fungsi untuk melakukan dislike
  Future<void> dislike(int movieId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    final currentVote = _userVotes[movieId];

    if (currentVote == false) { // Jika sudah dislike, batalkan
      await _supabase.from('votes').delete().match({'movie_id': movieId, 'user_id': userId});
      _userVotes[movieId] = null;
    } else { // Jika belum vote atau sudah like, ubah menjadi dislike
      await _supabase.from('votes').upsert({
        'movie_id': movieId,
        'user_id': userId,
        'is_like': false,
      }, onConflict: 'id'); // Menggunakan id sebagai onConflict
      _userVotes[movieId] = false;
    }
    notifyListeners();
  }

  // --- FUNGSI YANG HILANG ---
  Future<List<Vote>> getVotesByUser(String userId) async {
    try {
      final response = await _supabase
          .from('votes')
          .select()
          .eq('user_id', userId);

      final List<Vote> votes = (response as List).map((data) => Vote.fromJson(data)).toList();
      return votes;
    } catch (e) {
      print('Error fetching user votes: $e');
      return [];
    }
  }
}
