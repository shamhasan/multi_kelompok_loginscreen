import 'package:flutter/material.dart';
import 'package:multi_kelompok/models/movie.dart';
import 'package:multi_kelompok/models/vote.dart';
import 'package:provider/provider.dart';
import 'package:multi_kelompok/providers/vote_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyVotesScreen extends StatefulWidget {
  const MyVotesScreen({super.key});

  @override
  State<MyVotesScreen> createState() => _MyVotesScreenState();
}

class _MyVotesScreenState extends State<MyVotesScreen> {
  late final Future<Map<String, dynamic>> _initialDataFuture;

  @override
  void initState() {
    super.initState();
    _initialDataFuture = _fetchInitialData();
  }

  // Mengambil semua data yang dibutuhkan (votes dan movies) dalam satu pemanggilan
  Future<Map<String, dynamic>> _fetchInitialData() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      // Jika user tidak login, kembalikan data kosong dengan error
      throw Exception('Pengguna tidak login.');
    }

    try {
      // Menggunakan Future.wait untuk menjalankan kedua future secara bersamaan
      final results = await Future.wait([
        Provider.of<VoteProvider>(context, listen: false).getVotesByUser(userId),
        _fetchAllMovies(),
      ]);

      return {
        'userVotes': results[0] as List<Vote>,
        'allMovies': results[1] as List<Movie>,
      };
    } catch (e) {
      // Jika ada error, lempar lagi untuk ditangkap oleh FutureBuilder
      rethrow;
    }
  }

  Future<List<Movie>> _fetchAllMovies() async {
    final response = await Supabase.instance.client.from('movies').select();
    return (response as List).map((data) => Movie.fromJson(data)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Votes'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _initialDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            // Menangani error spesifik jika pengguna tidak login
            if (snapshot.error.toString().contains('Pengguna tidak login')) {
              return const Center(
                child: Text(
                  'Silakan login untuk melihat riwayat vote Anda.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Tidak ada data tersedia.'));
          }

          final userVotes = snapshot.data!['userVotes'] as List<Vote>;
          final allMovies = snapshot.data!['allMovies'] as List<Movie>;

          if (userVotes.isEmpty) {
            return const Center(
              child: Text(
                'Anda belum pernah memberikan vote.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: userVotes.length,
            itemBuilder: (context, index) {
              final vote = userVotes[index];
              final movie = allMovies.firstWhere(
                (m) => m.id == vote.movieId,
                // Perbaikan di sini: tambahkan isNowPlaying
                orElse: () => Movie(id: vote.movieId, title: 'Unknown Movie', posterUrl: '', rating: 0, overview: '', genres: [], year: 0, duration: '', ageRating: '', isNowPlaying: false),
              );

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
                            fit: BoxFit.cover,
                            errorBuilder: (c, o, s) => const Icon(Icons.movie, size: 40),
                          )
                        : const Icon(Icons.movie, size: 40),
                  ),
                  title: Text(
                    movie.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Film ID: ${vote.movieId}'),
                  trailing: Icon(
                    vote.isLike ? Icons.thumb_up : Icons.thumb_down,
                    color: vote.isLike ? Colors.green : Colors.red,
                    size: 24,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
