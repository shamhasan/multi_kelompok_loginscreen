import 'package:flutter/material.dart';
import 'package:multi_kelompok/models/genre.dart';
import 'package:provider/provider.dart';
import 'package:multi_kelompok/providers/genre_provider.dart';
import 'package:multi_kelompok/screen/movies_by_genres.dart';
// import 'package:multi_kelompok/models/genre.dart' as app_genre;

// Halaman utama untuk menampilkan Daftar Genre (Read-only)
class GenrePage extends StatefulWidget {
  const GenrePage({super.key});

  @override
  State<GenrePage> createState() => _GenrePageState();
}

class _GenrePageState extends State<GenrePage> {
  // --- KONSTANTA WARNA ---
  static const Color _primaryColor = Color(0xFF469756); // Hijau Primer
  static const Color _secondaryColor = Color(0xFF88D68A); // Hijau Sekunder
  static const Color _backgroundColor = Color(0xFFF0F8FF); // Latar Belakang

  @override
  void initState() {
    super.initState();
    // Memuat data genre saat inisialisasi
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GenreProvider>(context, listen: false).fetchGenres(context);
    });
  }

  @override
  Widget build(BuildContext context) {
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
          // Judul diubah agar lebih sesuai untuk tampilan daftar
          title: const Text('🎬 Daftar Genre Film'),
          centerTitle: true,
          actions: [
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
              ? const _EmptyStateWidget()
              : ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemCount: genres.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, i) {
              final g = genres[i];
              // Menggunakan widget daftar read-only
              return _GenreListItemReadOnly(
                genre: g,
                primaryColor: _primaryColor,
              );
            },
          ),
        ),
        // FloatingActionButton dihilangkan karena tidak ada fungsi 'Tambah'
        // floatingActionButton: FloatingActionButton.extended(...)
      ),
    );
  }
}

// ====================================================================
// --- WIDGET BARU (READ-ONLY) DAN WIDGET LAMA YANG DIHAPUS ---
// ====================================================================

// Widget untuk Tampilan State Kosong (TIDAK BERUBAH)
class _EmptyStateWidget extends StatelessWidget {
  const _EmptyStateWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.movie_filter_outlined, size: 100, color: Colors.grey[400]),
          const SizedBox(height: 24),
          Text(
            'Belum ada genre yang tersedia.',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 4),
          Text(
            'Silakan refresh untuk memuat ulang data.',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}


// Widget untuk Setiap Item Genre di Daftar (Dihapus fungsi edit/delete)
class _GenreListItemReadOnly extends StatelessWidget {
  final Genre genre;
  final Color primaryColor;

  const _GenreListItemReadOnly({
    required this.genre,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () {
          // Navigasi ke halaman film berdasarkan genre (Fungsi READ tetap ada)
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MoviesByGenrePage(
                genreId: genre.id,
                genreName: genre.name,
              ),
            ),
          );
        },
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
                // Opsional: ID genre dihilangkan untuk tampilan user yang lebih bersih
                // Text(
                //   'ID: ${genre.id}',
                //   style: TextStyle(
                //       fontSize: 12,
                //       color: primaryColor.withOpacity(0.8),
                //       fontWeight: FontWeight.w700),
                // ),
              ],
            ),
            // PopupMenuButton dihilangkan
            // trailing: PopupMenuButton<String>(...)
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------
// CATATAN:
// Logika _showAddEditDialog, _AddEditGenreDialog, dan _confirmDelete
// telah dihapus dari file ini karena tidak lagi digunakan.
// ---------------------------------------------------------------------
