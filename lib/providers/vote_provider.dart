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

  Future<void> fetchAllVoteCounts() async {
    try {
      final response = await _supabase.from('votes').select('movie_id, is_like');
      
      final Map<int, int> newLikes = {};
      final Map<int, int> newDislikes = {};

      for (var voteData in response as List) {
        final int movieId = voteData['movie_id'];
        final bool isLike = voteData['is_like'];

        if (isLike) {
          newLikes[movieId] = (newLikes[movieId] ?? 0) + 1;
        } else {
          newDislikes[movieId] = (newDislikes[movieId] ?? 0) + 1;
        }
      }

      _likes = newLikes;
      _dislikes = newDislikes;
      notifyListeners();

    } catch (e) {
      print('Error fetching all vote counts: $e');
    }
  }

  Future<void> fetchVotes(int movieId) async {
    try {
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
      print('Error fetching specific user vote: $e');
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

    await fetchAllVoteCounts();
    await fetchVotes(movieId);
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
