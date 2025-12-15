import 'package:flutter/material.dart';
import 'package:multi_kelompok/models/movie_model.dart';
import 'package:multi_kelompok/screen/movie_detail_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyVotesScreen extends StatefulWidget {
  const MyVotesScreen({super.key});

  @override
  State<MyVotesScreen> createState() => _MyVotesScreenState();
}

class _MyVotesScreenState extends State<MyVotesScreen> {
  late Future<List<Map<String, dynamic>>> _votedMoviesFuture;

  @override
  void initState() {
    super.initState();
    _votedMoviesFuture = _fetchVotedMovies();
  }

  Future<List<Map<String, dynamic>>> _fetchVotedMovies() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('Pengguna tidak login.');
    }

    try {
      final response = await Supabase.instance.client
          .from('votes')
          .select('is_like, movies(*)')
          .eq('user_id', userId);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Votes'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _votedMoviesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            if (snapshot.error.toString().contains('Pengguna tidak login')) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Silakan login untuk melihat riwayat vote Anda.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              );
            }
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Anda belum pernah memberikan vote.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final votedMovies = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: votedMovies.length,
            itemBuilder: (context, index) {
              final voteData = votedMovies[index];
              final movie = Movie.fromMap(voteData['movies'] as Map<String, dynamic>); // DIUBAH
              final isLike = voteData['is_like'] as bool;

              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: movie.posterUrl.isNotEmpty
                        ? Image.network(
                            movie.posterUrl,
                            width: 50,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (c, o, s) => const Icon(Icons.movie, size: 40),
                          )
                        : const Icon(Icons.movie, size: 40),
                  ),
                  title: Text(
                    movie.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(movie.year.toString()),
                  trailing: Icon(
                    isLike ? Icons.thumb_up : Icons.thumb_down,
                    color: isLike ? Colors.green : Colors.red,
                    size: 24,
                  ),
                   onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MovieDetailScreen(movieId: movie.id!)),
                    ).then((_) {
                      setState(() {
                        _votedMoviesFuture = _fetchVotedMovies();
                      });
                    });
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
