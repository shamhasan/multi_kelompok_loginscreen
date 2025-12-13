import 'package:flutter/material.dart';
import 'package:multi_kelompok/screen/admin/add_genre_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// --- DEFINISI WARNA SENADA ---
const Color _primaryColor = Color(0xFF469756);
const Color _accentColor = Color(0xFF88D68A);
const Color _lightGreen = Color(0xFFE8F5E9); // Background Card/Aksen

// Inisialisasi Supabase client (Asumsi ini sudah didefinisikan secara global)
final supabase = Supabase.instance.client;

class GenreAdminScreen extends StatefulWidget {
  const GenreAdminScreen({super.key});

  @override
  State<GenreAdminScreen> createState() => _GenreAdminScreenState();
}

class _GenreAdminScreenState extends State<GenreAdminScreen> {
  late Future<List<Map<String, dynamic>>> _genresFuture;

  @override
  void initState() {
    super.initState();
    _genresFuture = _fetchGenres();
  }

  // Fungsi untuk mengambil semua genre
  Future<List<Map<String, dynamic>>> _fetchGenres() async {
    try {
      final response = await supabase
          .from('genres')
          .select('*')
          .order('name', ascending: true);

      debugPrint('Berhasil mengambil ${response.length} genre.');
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error fetching genres: $e');
      throw Exception('Gagal memuat daftar genre.');
    }
  }

  // Fungsi untuk refresh data
  void _refreshGenres() {
    setState(() {
      _genresFuture = _fetchGenres();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Kategori Film', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: _primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _genresFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: _primaryColor),
                  const SizedBox(height: 10),
                  Text('Memuat data genre...', style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Gagal terhubung ke database. Cek koneksi Anda. (${snapshot.error.toString().split(':')[0]})',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.category_outlined, size: 80, color: _accentColor),
                  const SizedBox(height: 10),
                  const Text('Belum ada genre di sistem.', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 5),
                  Text('Silakan tambahkan genre pertama Anda.', style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            );
          }

          final genres = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: genres.length,
            itemBuilder: (context, index) {
              final genre = genres[index];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _lightGreen,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      genre['id'].toString(),
                      style: const TextStyle(
                        color: _primaryColor,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  title: Text(
                    genre['name'] ?? 'Nama Tidak Tersedia',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text(
                    'ID Kategori: ${genre['id']}',
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: _primaryColor),
                  onTap: () {
                    // TODO: Implementasi edit genre
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Mengedit Genre: ${genre['name']}'))
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddGenreScreen(),
            ),
          );
          if (result == true) {
            _refreshGenres();
          }
        },
        backgroundColor: _primaryColor,
        label: const Text('Tambah Baru', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        icon: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}