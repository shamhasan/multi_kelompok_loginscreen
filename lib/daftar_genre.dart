import 'package:flutter/material.dart';

// --- Model ---
class Genre {
  final int id;
  String name; // Dibuat non-final agar bisa diubah di _editGenre

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
  ];
  int _nextId = 4;

  // --- Logic Metode CRUD ---

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

  // --- Dialog Tambah/Edit ---

  Future<void> _showAddEditDialog({Genre? genre}) async {
    final controller = TextEditingController(text: genre?.name ?? '');
    final isNew = genre == null;
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (context) => Dialog(
        // Peningkatan: Menggunakan Material 3 style Dialog
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isNew ? 'Tambah Genre Baru' : 'Edit Genre',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor, // Menggunakan warna primary
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField( // Peningkatan: Menggunakan TextFormField untuk validasi
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
                      prefixIcon: const Icon(Icons.movie_filter_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Batal'),
                      ),
                      const SizedBox(width: 12),
                      FilledButton( // Peningkatan: Menggunakan FilledButton
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
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
                        child: Text(
                          isNew ? 'Tambah' : 'Simpan',
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

  // --- Dialog Konfirmasi Hapus ---

  Future<void> _confirmDelete(Genre g) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        // Peningkatan: Styling AlertDialog
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 8),
            Text('Konfirmasi Hapus', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text('Anda yakin ingin menghapus genre "${g.name}" (ID: ${g.id})? Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
    // Peningkatan: Menggunakan Theme untuk konsistensi warna
    final primaryColor = Colors.teal[700]!;

    return Theme(
      data: Theme.of(context).copyWith(
        primaryColor: primaryColor,
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
      ),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: primaryColor, // Warna AppBar lebih tegas
          title: const Text(
            'Manajemen Genre',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: _genres.isEmpty
              ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.auto_stories_outlined, size: 80, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  'Belum ada genre yang ditambahkan.',
                  style: TextStyle(fontSize: 18, color: Colors.grey[500]),
                ),
              ],
            ),
          )
              : ListView.separated(
            physics: const BouncingScrollPhysics(), // Efek scroll yang lebih halus
            itemCount: _genres.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final g = _genres[i];
              return _GenreListItem(
                genre: g,
                onEdit: () => _showAddEditDialog(genre: g),
                onDelete: () => _confirmDelete(g),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showAddEditDialog(),
          backgroundColor: primaryColor,
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          label: const Row(
            children: [
              Icon(Icons.add, color: Colors.white),
              SizedBox(width: 8),
              Text('Tambah Genre',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Widget Kustom untuk Item Daftar ---

class _GenreListItem extends StatelessWidget {
  final Genre genre;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _GenreListItem({
    required this.genre,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card( // Peningkatan: Menggunakan Card untuk tampilan modern
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onEdit, // Klik pada item langsung membuka Edit
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.movie_outlined, color: Colors.teal),
            ),
            title: Text(
              genre.name,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
            ),
            subtitle: Text(
              'ID: ${genre.id}',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            trailing: PopupMenuButton<String>(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              onSelected: (v) {
                if (v == 'edit') onEdit();
                if (v == 'delete') onDelete();
              },
              itemBuilder: (_) => [
                const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 20),
                        SizedBox(width: 10),
                        Text('Edit'),
                      ],
                    )),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, color: Colors.red, size: 20),
                      SizedBox(width: 10),
                      Text('Hapus', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
              icon: const Icon(Icons.more_vert, color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }
}