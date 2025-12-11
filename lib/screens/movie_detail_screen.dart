import 'package:flutter/material.dart';
import 'package:multi_kelompok/models/movie.dart';
import 'package:multi_kelompok/widgets/vote_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MovieDetailScreen extends StatefulWidget {
  final int movieId; // Diubah untuk menerima movieId

  const MovieDetailScreen({super.key, required this.movieId});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  Movie? _movie;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchMovie();
  }

  // Fungsi untuk mengambil data film dari Supabase
  Future<void> _fetchMovie() async {
    // Tambahkan try-catch untuk menangani kemungkinan eror jaringan atau lainnya
    try {
      final response = await Supabase.instance.client
          .from('movies')
          .select()
          .eq('id', widget.movieId)
          .single(); // Mengambil satu baris data
      
      setState(() {
        _movie = Movie.fromJson(response);
        _isLoading = false;
      });

    } catch (e) {
      // Jika terjadi eror, catat dan tampilkan pesan
      setState(() {
        _error = 'Gagal memuat detail film: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tampilkan UI berdasarkan state saat ini (loading, error, atau success)

    // 1. Saat sedang loading
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(backgroundColor: Colors.green, foregroundColor: Colors.white, elevation: 0),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // 2. Jika ada eror
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error'), backgroundColor: Colors.green, foregroundColor: Colors.white),
        body: Center(child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(_error!),
        )),
      );
    }
    
    // 3. Jika film tidak ditemukan setelah loading selesai
    if (_movie == null) {
       return Scaffold(
        appBar: AppBar(title: const Text('Error'), backgroundColor: Colors.green, foregroundColor: Colors.white),
        body: const Center(child: Text('Film tidak ditemukan.')),
      );
    }

    // 4. Jika sukses, bangun UI utama
    final movie = _movie!;

    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    movie.posterUrl,
                    width: 120,
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.movie_creation_outlined, size: 120, color: Colors.grey),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${movie.year} • ${movie.duration}',
                        style: const TextStyle(
                            fontSize: 16, color: Colors.black54),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6.0,
                        runSpacing: 4.0,
                        children: movie.genres
                            .map((genre) => Chip(
                                  label: Text(genre.trim()),
                                  backgroundColor:
                                      Colors.lightGreen.shade100,
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              movie.overview,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 24),
            const Divider(thickness: 1),
            const SizedBox(height: 16),
            const Text(
              'Berikan Penilaian Anda',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            VoteWidget(movieId: movie.id), // Sekarang movie.id adalah int, jadi tidak akan ada eror
          ],
        ),
      ),
    );
  }
}
