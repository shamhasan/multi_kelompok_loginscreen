// lib/admin/genre_admin_screen.dart (Nama file dari folder structure Anda)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// 👈 Import Provider dari folder providers
import '../providers/genre_provider.dart';
// 👈 Import model dari folder models
import '../models/genre.dart';
// Asumsi 'movies_by_genres.dart' ada di folder yang dapat diakses, mungkin di 'lib/widgets' atau 'lib/screens'

// Jika movies_by_genres.dart ada di lib/screens/movies_by_genres.dart
// import '../screens/movies_by_genres.dart'; 
// Jika movies_by_genres.dart ada di lib/movies_by_genres.dart (seperti di kode awal Anda)
import '../movies_by_genres.dart' hide Genre; // Sesuaikan path ini jika perlu

// ... (Sisa kode GenreAdminPage dan _GenreListItem sama persis dengan yang ada di Langkah 2, 
//       hanya memastikan semua import dan pemanggilan provider sudah benar) ...

// --- Main Widget ---
class GenreAdminScreen extends StatefulWidget { // Ganti nama kelas dari Page ke Screen
  const GenreAdminScreen({super.key});

  @override
  State<GenreAdminScreen> createState() => _GenreAdminScreenState();
}

class _GenreAdminScreenState extends State<GenreAdminScreen> {
  // ... (Sisa kode initState, _showAddEditDialog, _confirmDelete, dan build) ...

  static const Color _primaryColor = Color(0xFF469756);
  static const Color _secondaryColor = Color(0xFF88D68A);
  static const Color _accentColor = Color(0xFF457346);
  static const Color _backgroundColor = Color(0xFFF0F8FF);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GenreProvider>(context, listen: false).fetchGenres(context);
    });
  }

  // Logika _showAddEditDialog dan _confirmDelete tetap sama seperti di Langkah 2.
  // Pastikan menggunakan:
  // final provider = context.read<GenreProvider>();
  // untuk memanggil fungsi.

  // Logika build tetap sama seperti di Langkah 2.
  // Pastikan menggunakan:
  // final provider = context.watch<GenreProvider>();
  // final genres = provider.genres;
  // final isLoading = provider.isLoading;

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
          title: const Text('🚀 Manajemen Genre Film'),
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
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.movie_filter_outlined, size: 100, color: Colors.grey[400]),
                const SizedBox(height: 24),
                Text(
                  'Belum ada genre yang ditambahkan.',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tekan tombol "+" untuk memulai.',
                  style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                ),
              ],
            ),
          )
              : ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemCount: genres.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, i) {
              final g = genres[i];
              return _GenreListItem(
                genre: g,
                primaryColor: _primaryColor,
                onEdit: () => _showAddEditDialog(genre: g),
                onDelete: () async {
                  final ok = await _confirmDelete(g);
                  if (ok == true) {
                    provider.deleteGenre(context, g.id, g.name);
                  }
                },
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showAddEditDialog(),
          backgroundColor: _primaryColor,
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          label: const Row(
            children: [
              Icon(Icons.add_circle_outline, color: Colors.white),
              SizedBox(width: 10),
              Text('Tambah Genre',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }

  // Masukkan implementasi _showAddEditDialog dan _confirmDelete di sini
  // ...
  Future<void> _showAddEditDialog({Genre? genre}) async {
    final nameController = TextEditingController(text: genre?.name ?? '');
    final descController = TextEditingController(text: genre?.description ?? '');
    final isNew = genre == null;
    final formKey = GlobalKey<FormState>();
    bool isSaving = false;

    final provider = context.read<GenreProvider>();

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateSB) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            elevation: 10,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isNew ? 'Tambah Genre Baru' : 'Edit Genre',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: _primaryColor,
                        ),
                      ),
                      const SizedBox(height: 28),
                      TextFormField(
                        controller: nameController,
                        autofocus: true,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Nama genre tidak boleh kosong.';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Nama Genre',
                          hintText: '',
                          prefixIcon: const Icon(Icons.category_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: _primaryColor, width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: descController,
                        maxLines: 2,
                        maxLength: 100,
                        decoration: InputDecoration(
                          labelText: 'Deskripsi Singkat',
                          hintText: 'Misalnya: Film yang bergenre aksi penuh ledakan.',
                          prefixIcon: const Icon(Icons.short_text_rounded),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(color: _primaryColor, width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                                foregroundColor: Colors.grey[600]),
                            child: const Text('Batal'),
                          ),
                          const SizedBox(width: 12),
                          FilledButton.icon(
                            icon: isSaving
                                ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                : Icon(isNew ? Icons.add : Icons.save),
                            onPressed: isSaving
                                ? null
                                : () async {
                              if (formKey.currentState!.validate()) {
                                setStateSB(() => isSaving = true);
                                final name = nameController.text.trim();
                                final description = descController.text.trim();

                                bool success;
                                if (isNew) {
                                  success = await provider.addGenre(context, name, description);
                                } else {
                                  success = await provider.editGenre(context, genre!.id, name, description);
                                }

                                setStateSB(() => isSaving = false);

                                if (mounted && success) Navigator.pop(context);
                              }
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: _primaryColor,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                            ),
                            label: Text(
                              isSaving ? 'Menyimpan...' : (isNew ? 'Tambahkan' : 'Simpan Perubahan'),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<bool?> _confirmDelete(Genre g) async {
    return await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: const Icon(Icons.delete_forever_rounded, color: Colors.red, size: 40),
        title: const Text('Hapus Genre?', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('Anda yakin ingin menghapus genre "${g.name}"? Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal', style: TextStyle(color: _primaryColor)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red[600],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}

class _GenreListItem extends StatelessWidget {
  final Genre genre;
  final Color primaryColor;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _GenreListItem({
    required this.genre,
    required this.primaryColor,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MoviesByGenrePage( // Pastikan MoviesByGenrePage menerima parameter ini
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
                Text(
                  'ID: ${genre.id}',
                  style: TextStyle(
                      fontSize: 12,
                      color: primaryColor.withOpacity(0.8),
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
            trailing: PopupMenuButton<String>(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              onSelected: (v) {
                if (v == 'edit') onEdit();
                if (v == 'delete') onDelete();
              },
              itemBuilder: (_) => [
                const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, size: 22, color: Colors.green),
                        SizedBox(width: 12),
                        Text('Edit Genre'),
                      ],
                    )),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_sweep_outlined, color: Colors.red, size: 22),
                      SizedBox(width: 12),
                      Text('Hapus Genre', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
              icon: Icon(Icons.more_horiz, color: Colors.grey[700], size: 28),
            ),
          ),
        ),
      ),
    );
  }
}
