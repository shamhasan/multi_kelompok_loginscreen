import 'package:flutter/material.dart';

// --- Model ---
class Genre {
  final int id;
  String name;

  Genre({required this.id, required this.name});
}

// --- Main Widget ---
class GenreAdminPage extends StatefulWidget {
  const GenreAdminPage({super.key});

  @override
  State<GenreAdminPage> createState() => _GenreAdminPageState();
}

class _GenreAdminPageState extends State<GenreAdminPage> {
  // Data State
  final List<Genre> _genres = [
    Genre(id: 1, name: 'Action'),
    Genre(id: 2, name: 'Comedy'),
    Genre(id: 3, name: 'Horror'),
    Genre(id: 4, name: 'Sci-Fi'),
    Genre(id: 5, name: 'Thriller'),
  ];
  int _nextId = 6;

  // Konstanta Warna untuk Tema yang Lebih Segar (Cerulean Blue)
  static const Color _primaryColor = Color(0xFF0077B6);
  static const Color _secondaryColor = Color(0xFF90E0EF);
  static const Color _accentColor = Color(0xFF48CAE4);
  static const Color _backgroundColor = Color(0xFFF0F8FF); // Light Blue Background

  // --- Logic Metode CRUD (Tetap sama) ---

  void _addGenre(String name) {
    setState(() {
      _genres.add(Genre(id: _nextId++, name: name.trim()));
    });
  }

  void _editGenre(int id, String newName) {
    setState(() {
      final i = _genres.indexWhere((g) => g.id == id);
      if (i != -1) _genres[i].name = newName.trim();
    });
  }

  void _deleteGenre(int id) {
    setState(() {
      _genres.removeWhere((g) => g.id == id);
    });
  }

  // --- Dialog Tambah/Edit (Peningkatan Desain) ---

  Future<void> _showAddEditDialog({Genre? genre}) async {
    final controller = TextEditingController(text: genre?.name ?? '');
    final isNew = genre == null;
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)), // Radius lebih besar
        elevation: 10,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32), // Padding lebih besar
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isNew ? 'Tambah Genre Baru' : 'Edit Genre',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: _primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isNew ? 'Masukkan nama genre film yang unik.' : 'Perbarui nama genre film.',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 28),
                  TextFormField(
                    controller: controller,
                    autofocus: true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Nama genre tidak boleh kosong.';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Nama Genre',
                      hintText: 'Misalnya: Fantasi',
                      prefixIcon: const Icon(Icons.category_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16), // Radius lebih besar
                      ),
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
                        icon: Icon(isNew ? Icons.add : Icons.save),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            final name = controller.text.trim();
                            if (isNew) {
                              _addGenre(name);
                            } else {
                              _editGenre(genre!.id, name);
                            }
                            Navigator.pop(context);
                          }
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: _primaryColor,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        label: Text(
                          isNew ? 'Tambahkan' : 'Simpan Perubahan',
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
      ),
    );
  }

  // --- Dialog Konfirmasi Hapus (Peningkatan Desain) ---

  Future<void> _confirmDelete(Genre g) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: const Icon(Icons.delete_forever_rounded, color: Colors.red, size: 40),
        title: const Text('Hapus Genre?', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('Anda yakin ingin menghapus genre **"${g.name}"**? Tindakan ini tidak dapat dibatalkan.'),
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

    if (ok == true) _deleteGenre(g.id);
  }

  // --- Widget Build ---

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: _backgroundColor, // Menggunakan warna latar belakang yang cerah
        appBar: AppBar(
          title: const Text('🚀 Manajemen Genre Film'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: _genres.isEmpty
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
            itemCount: _genres.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16), // Jarak antar item lebih besar
            itemBuilder: (context, i) {
              final g = _genres[i];
              return _GenreListItem(
                genre: g,
                primaryColor: _primaryColor, // Kirim primary color
                onEdit: () => _showAddEditDialog(genre: g),
                onDelete: () => _confirmDelete(g),
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
}

// --- Widget Kustom untuk Item Daftar (Peningkatan Desain) ---

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
      elevation: 6, // Elevasi lebih tinggi
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), // Radius lebih besar
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onEdit,
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
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Chip( // Menggunakan Chip untuk ID
                label: Text('ID: ${genre.id}', style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600)),
                backgroundColor: primaryColor.withOpacity(0.1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
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
                        Icon(Icons.edit_outlined, size: 22, color: Colors.blue),
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