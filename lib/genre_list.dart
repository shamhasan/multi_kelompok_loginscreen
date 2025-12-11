import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:multi_kelompok/providers/genre_provider.dart';
import 'package:multi_kelompok/movies_by_genres.dart' hide Genre;
import 'package:multi_kelompok/models/genre.dart';

// Halaman utama untuk menampilkan daftar genre (sekarang hanya View)
class GenreViewPage extends StatefulWidget {
  const GenreViewPage({super.key});

  @override
  State<GenreViewPage> createState() => _GenreViewPageState();
}

class _GenreViewPageState extends State<GenreViewPage> {
  // Konstanta Warna
  static const Color _primaryColor = Color(0xFF469756);
  static const Color _secondaryColor = Color(0xFF88D68A);
  static const Color _backgroundColor = Color(0xFFF0F8FF);

  @override
  void initState() {
    super.initState();
    // Memastikan pemanggilan fetchGenres dilakukan setelah widget tree selesai dibangun
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GenreProvider>(context, listen: false).fetchGenres(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Menggunakan context.watch untuk mendengarkan perubahan pada GenreProvider
    final provider = context.watch<GenreProvider>();
    final genres = provider.genres;
    final isLoading = provider.isLoading;

    return Theme(
      data: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _primaryColor,
          primary: _primaryColor,
          secondary: _secondaryColor,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: _primaryColor,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: _backgroundColor,
        appBar: AppBar(
          title: const Text('🎬 Movies By Genres'),
          centerTitle: true,
          actions: [
            // Tombol refresh untuk memuat ulang daftar genre
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: () => provider.fetchGenres(context),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: isLoading
              ? Center(child: CircularProgressIndicator(color: _primaryColor.withOpacity(0.7)))
              : genres.isEmpty
              ? _EmptyState(primaryColor: _primaryColor) // Tampilan saat tidak ada genre
              : ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemCount: genres.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, i) {
              final g = genres[i];
              return _GenreListItem(
                genre: g,
                primaryColor: _primaryColor,
              );
            },
          ),
        ),
        // FloatingActionButton dihapus karena tidak ada fungsi tambah genre
      ),
    );
  }
}

// Widget untuk menampilkan state kosong
class _EmptyState extends StatelessWidget {
  final Color primaryColor;

  const _EmptyState({required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.movie_filter_outlined, size: 100, color: primaryColor.withOpacity(0.4)),
          const SizedBox(height: 24),
          Text(
            'Belum ada genre yang tersedia.',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 4),
          Text(
            'Coba refresh atau cek koneksi Anda.',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}

// Item daftar genre yang sekarang hanya berfungsi untuk navigasi
class _GenreListItem extends StatelessWidget {
  final Genre genre;
  final Color primaryColor;

  const _GenreListItem({
    required this.genre,
    required this.primaryColor,
  });

  // Fungsi untuk navigasi ke halaman film berdasarkan genre
  void _navigateToMovies(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MoviesByGenrePage(
          genreId: genre.id,
          genreName: genre.name,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.zero,
      child: InkWell(
        // Logika onTap yang akan menavigasi ke MoviesByGenrePage
        onTap: () => _navigateToMovies(context),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: primaryColor.withOpacity(0.3), width: 1),
              ),
              child: Icon(Icons.movie_creation_outlined, color: primaryColor, size: 28),
            ),
            title: Text(
              genre.name,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  genre.description ?? 'Belum ada deskripsi.',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  'ID: ${genre.id}',
                  style: TextStyle(
                      fontSize: 12,
                      color: primaryColor.withOpacity(0.8),
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
            // Tombol opsi (PopupMenuButton) dihapus
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              color: primaryColor,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}