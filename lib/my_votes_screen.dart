import 'package:flutter/material.dart';
import 'package:multi_kelompok/data/movie.dart';
import 'package:multi_kelompok/models/movie.dart';
import 'package:multi_kelompok/models/vote.dart';
import 'package:provider/provider.dart';
import 'package:multi_kelompok/providers/vote_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Mengganti nama kelas menjadi MyVotesScreen
class MyVotesScreen extends StatelessWidget {
  const MyVotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengambil ID pengguna yang sedang login dari Supabase
    final userId = Supabase.instance.client.auth.currentUser?.id;

    if (userId == null) {
      // Jika tidak ada pengguna yang login, tampilkan pesan
      return Scaffold(
        appBar: AppBar(
          title: const Text('My Votes'),
          backgroundColor: Colors.green,
        ),
        body: const Center(
          child: Text(
            'Silakan login untuk melihat riwayat vote Anda.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Votes'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      // Menggunakan FutureBuilder untuk mengambil data vote secara asynchronous
      body: FutureBuilder<List<Vote>>(
        future: Provider.of<VoteProvider>(context, listen: false).getVotesByUser(userId),
        builder: (context, snapshot) {
          // Menampilkan loading indicator saat data sedang diambil
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Menampilkan pesan error jika terjadi kesalahan
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // Menampilkan pesan jika pengguna belum pernah vote
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Anda belum pernah memberikan vote.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          // Jika data berhasil diambil, tampilkan dalam ListView
          final userVotes = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: userVotes.length,
            itemBuilder: (context, index) {
              final vote = userVotes[index];
              // Mencari detail film dari daftar film dummy berdasarkan movieId
              final movie = popularMovies.firstWhere(
                (m) => m.id == vote.movieId,
                // Jika film tidak ditemukan, buat objek Movie sementara
                orElse: () => Movie(id: vote.movieId, title: 'Unknown Movie', posterUrl: '', rating: 0, overview: '', genres: [], year: 0, duration: '', ageRating: ''),
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
                  subtitle: Text('ID Film: ${vote.movieId}'),
                  // Menampilkan ikon suka atau tidak suka berdasarkan nilai vote
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
