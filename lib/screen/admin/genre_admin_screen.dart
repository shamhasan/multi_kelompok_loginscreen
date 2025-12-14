import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:multi_kelompok/screen/admin/add_genre_screen.dart';
import 'package:multi_kelompok/screen/movies_by_genres.dart';

// --- DEFINISI WARNA SENADA ---
const Color _primaryColor = Color(0xFF469756);
const Color _accentColor = Color(0xFF88D68A);
const Color _lightGreen = Color(0xFFE8F5E9); // Background Card/Aksen

// Inisialisasi Supabase client
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

  // --- LOGIKA DATA (CRUD - READ) ---
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
      if (e is PostgrestException) {
        throw Exception(e.message);
      }
      throw Exception('Gagal memuat daftar genre.');
    }
  }

  // --- LOGIKA DATA (CRUD - UPDATE) ---
  Future<void> _updateGenre(int id, String newName, String? newDescription) async {
    try {
      // Pastikan deskripsi dikirim sebagai null jika string kosong
      final Map<String, dynamic> updateData = {
        'name': newName,
        'description': (newDescription?.isEmpty ?? true) ? null : newDescription,
      };

      await supabase
          .from('genres')
          .update(updateData)
          .eq('id', id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Genre "$newName" berhasil diperbarui.'),
            backgroundColor: _primaryColor,
          ),
        );
      }
      _refreshGenres();
    } catch (e) {
      debugPrint('Error updating genre: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal mengupdate genre.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // --- LOGIKA DATA (CRUD - DELETE) ---
  Future<void> _deleteGenre(int id, String name) async {
    try {
      await supabase
          .from('genres')
          .delete()
          .eq('id', id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Genre "$name" berhasil dihapus.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      _refreshGenres();
    } catch (e) {
      debugPrint('Error deleting genre: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal menghapus genre.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Fungsi untuk refresh data
  void _refreshGenres() {
    setState(() {
      _genresFuture = _fetchGenres();
    });
  }

  // --- UI & LOGIKA BUILD ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Kategori Film',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: _primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshGenres,
          ),
        ],
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
                child: Text('Gagal terhubung ke database: ${snapshot.error.toString()}',
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
              return _GenreListItem(
                genre: genre,
                onEdit: () => _showEditDialog(genre),
                onDelete: () => _confirmDeleteDialog(genre),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // Navigasi ke AddGenreScreen
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

  // --- LOGIKA DIALOG EDIT GENRE (CRUD - UPDATE) ---
  Future<void> _showEditDialog(Map<String, dynamic> genre) async {
    final TextEditingController nameController = TextEditingController(text: genre['name']);
    final TextEditingController descController = TextEditingController(text: genre['description']);
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 10,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _lightGreen.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // JUDUL DIALOG
                    Text(
                      'Edit Genre',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: _primaryColor,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // FIELD NAMA GENRE
                    Text(
                      'Nama Genre',
                      style: TextStyle(color: Colors.grey[700], fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: nameController,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: _primaryColor, width: 2),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama genre tidak boleh kosong.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // FIELD DESKRIPSI GENRE
                    Text(
                      'Deskripsi Singkat (Opsional)',
                      style: TextStyle(color: Colors.grey[700], fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    TextFormField(
                      controller: descController,
                      maxLines: 2,
                      maxLength: 100,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                        hintText: 'Maks. 100 karakter',
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: _primaryColor, width: 2),
                        ),
                        counterText: '${descController.text.length}/100',
                      ),
                      onChanged: (text) {
                        // Tidak perlu setState di sini karena dialog akan me-rebuild saat dipanggil lagi.
                      },
                    ),
                    const SizedBox(height: 20),

                    // ACTIONS (TOMBOL)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.grey[600],
                          ),
                          child: const Text('Batal', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              Navigator.pop(context); // Tutup dialog
                              await _updateGenre(
                                genre['id'] as int,
                                nameController.text,
                                descController.text,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primaryColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                          child: const Text('Simpan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // --- DIALOG KONFIRMASI HAPUS (Tidak Berubah) ---
  Future<void> _confirmDeleteDialog(Map<String, dynamic> genre) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text('Anda yakin ingin menghapus genre "${genre['name']}" (ID: ${genre['id']})?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: _primaryColor)),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context); // Tutup dialog
                await _deleteGenre(genre['id'] as int, genre['name'] as String);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Hapus', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}

// --- WIDGET UNTUK SETIAP ITEM DAFTAR GENRE (ID BOX UKURAN TETAP) ---
class _GenreListItem extends StatelessWidget {
  final Map<String, dynamic> genre;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _GenreListItem({
    required this.genre,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final String description = genre['description'] ?? 'Deskripsi belum tersedia.';
    final String genreName = genre['name'] as String? ?? 'Kategori Tidak Dikenal';

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
          // MODIFIKASI: Menggunakan SizedBox untuk mengatur lebar tetap
          child: SizedBox(
            width: 32.0, // Tentukan lebar tetap di sini
            child: Text(
              genre['id'].toString(),
              textAlign: TextAlign.center, // Pusatkan teks ID
              style: const TextStyle(
                color: _primaryColor,
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
            ),
          ),
        ),
        title: Text(
          genreName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Text(
          description,
          style: TextStyle(color: Colors.grey[700], fontSize: 13),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        // --- Pop-up Menu untuk Edit & Delete ---
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              onEdit();
            } else if (value == 'delete') {
              onDelete();
            } else if (value == 'view') {
              // Navigasi ke MoviesByGenrePage
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MoviesByGenrePage(
                    genreId: genre['id'] as int,
                    genreName: genreName,
                  ),
                ),
              );
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'view',
              child: Row(
                children: [
                  Icon(Icons.movie_filter_outlined, color: Colors.blueAccent),
                  SizedBox(width: 8),
                  Text('Lihat Film'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, color: Colors.orange),
                  SizedBox(width: 8),
                  Text('Edit Genre'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete_sweep_outlined, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Hapus Genre'),
                ],
              ),
            ),
          ],
          icon: const Icon(Icons.more_vert, color: _primaryColor),
        ),
        onTap: () {
          // Aksi default ketika item diklik: Navigasi ke Lihat Film
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MoviesByGenrePage(
                genreId: genre['id'] as int,
                genreName: genreName,
              ),
            ),
          );
        },
      ),
    );
  }
}
