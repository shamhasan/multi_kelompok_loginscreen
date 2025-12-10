import 'package:flutter/foundation.dart';
import 'package:multi_kelompok/models/vote.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VoteProvider with ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  Map<int, int> _likes = {};
  Map<int, int> _dislikes = {};
  Map<int, bool?> _userVotes = {};

  Map<int, int> get likes => _likes;
  Map<int, int> get dislikes => _dislikes;
  Map<int, bool?> get userVotes => _userVotes;

  Future<void> fetchVotes(int movieId) async {
    try {
      final response = await _supabase
          .from('votes')
          .select()
          .eq('movie_id', movieId);

      final List<Vote> votes = (response as List).map((data) => Vote.fromJson(data)).toList();
      _likes[movieId] = votes.where((v) => v.isLike).length;
      _dislikes[movieId] = votes.where((v) => !v.isLike).length;
      
      final userId = _supabase.auth.currentUser?.id;
      if (userId != null) {
        final userVoteResponse = await _supabase
            .from('votes')
            .select('is_like')
            .eq('movie_id', movieId)
            .eq('user_id', userId)
            .maybeSingle();

        if (userVoteResponse != null) {
          _userVotes[movieId] = userVoteResponse['is_like'];
        } else {
          _userVotes[movieId] = null;
        }
      }

    } catch (e) {
      print('Error fetching votes: $e');
      _likes[movieId] = 0;
      _dislikes[movieId] = 0;
    }
    notifyListeners();
  }

  Future<void> vote(int movieId, bool isLike) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    final currentVote = _userVotes[movieId];

    if (currentVote == isLike) {
      await _supabase
        .from('votes')
        .delete()
        .match({'movie_id': movieId, 'user_id': userId});
       _userVotes[movieId] = null;
    } else {
       await _supabase.from('votes').upsert({
        'movie_id': movieId,
        'user_id': userId,
        'is_like': isLike,
      }, onConflict: 'movie_id, user_id');
      _userVotes[movieId] = isLike;
    }

    await fetchVotes(movieId);
  }

  // Fungsi baru untuk mengambil riwayat vote pengguna
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
