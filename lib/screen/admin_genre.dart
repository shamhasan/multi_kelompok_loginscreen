import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:multi_kelompok/models/genre.dart';
import 'package:multi_kelompok/providers/genre_provider.dart';
import 'package:multi_kelompok/screen/movies_by_genres.dart';

// Halaman utama untuk manajemen Genre (CRUD)
class GenreAdminPage extends StatefulWidget {
  const GenreAdminPage({super.key});

  @override
  State<GenreAdminPage> createState() => _GenreAdminPageState();
}

class _GenreAdminPageState extends State<GenreAdminPage> {
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
          title: const Text('🎬 Cinema Genre'),
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
              return _GenreListItem(
                genre: g,
                primaryColor: _primaryColor,
                onEdit: () => _showAddEditDialog(genre: g),
                onDelete: () async {
                  final ok = await _confirmDelete(g);
                  if (ok == true) {
                    // Memanggil deleteGenre dari provider
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

  // --- LOGIKA DIALOG TAMBAH/EDIT GENRE ---
  Future<void> _showAddEditDialog({Genre? genre}) async {
    await showDialog(
      context: context,
      builder: (context) => _AddEditGenreDialog(
        genre: genre,
        primaryColor: _primaryColor,
      ),
    ).then((result) {
      // Memastikan genre list di-refresh jika ada perubahan dari dialog
      if (result == true) {
        context.read<GenreProvider>().fetchGenres(context);
      }
    });
  }

  // --- LOGIKA DIALOG KONFIRMASI HAPUS ---
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

// ====================================================================
// --- WIDGET BARU UNTUK MERAPIKAN KODE ---
// ====================================================================

// Widget untuk Tampilan State Kosong
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
    );
  }
}


// Widget untuk Dialog Tambah/Edit Genre
class _AddEditGenreDialog extends StatefulWidget {
  final Genre? genre;
  final Color primaryColor;

  const _AddEditGenreDialog({this.genre, required this.primaryColor});

  @override
  State<_AddEditGenreDialog> createState() => __AddEditGenreDialogState();
}

class __AddEditGenreDialogState extends State<_AddEditGenreDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _descController;
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;
  late final bool _isNew;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.genre?.name ?? '');
    _descController = TextEditingController(text: widget.genre?.description ?? '');
    _isNew = widget.genre == null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final provider = context.read<GenreProvider>();
    final name = _nameController.text.trim();
    final description = _descController.text.trim();
    bool success;

    if (_isNew) {
      success = await provider.addGenre(context, name, description);
    } else {
      success = await provider.editGenre(context, widget.genre!.id, name, description);
    }

    if (mounted) {
      // Menggunakan pop dengan true untuk memberi tahu halaman utama agar refresh
      Navigator.pop(context, success);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 10,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isNew ? 'Tambah Genre Baru' : 'Edit Genre',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: widget.primaryColor,
                  ),
                ),
                const SizedBox(height: 28),
                TextFormField(
                  controller: _nameController,
                  autofocus: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama genre tidak boleh kosong.';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Nama Genre',
                    prefixIcon: const Icon(Icons.category_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: widget.primaryColor, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descController,
                  maxLines: 2,
                  maxLength: 100,
                  decoration: InputDecoration(
                    labelText: 'Deskripsi Singkat',
                    hintText: 'Misalnya: Film yang bergenre aksi penuh ledakan.',
                    prefixIcon: const Icon(Icons.short_text_rounded),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: widget.primaryColor, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(foregroundColor: Colors.grey[600]),
                      child: const Text('Batal'),
                    ),
                    const SizedBox(width: 12),
                    FilledButton.icon(
                      icon: _isSaving
                          ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Icon(_isNew ? Icons.add : Icons.save),
                      onPressed: _isSaving ? null : _handleSave,
                      style: FilledButton.styleFrom(
                        backgroundColor: widget.primaryColor,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      label: Text(
                        _isSaving ? 'Menyimpan...' : (_isNew ? 'Tambahkan' : 'Simpan Perubahan'),
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
  }
}


// Widget untuk Setiap Item Genre di Daftar
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
          // Navigasi ke halaman film berdasarkan genre
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