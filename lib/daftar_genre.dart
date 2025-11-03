import 'package:flutter/material.dart';
class Genre {
  int id;
  String name;

  Genre({required this.id, required this.name});
}

class GenreAdminPage extends StatefulWidget {
  const GenreAdminPage({super.key});

  @override
  State<GenreAdminPage> createState() => _GenreAdminPageState();
}

class _GenreAdminPageState extends State<GenreAdminPage> {
  final List<Genre> _genres = [
    Genre(id: 1, name: 'Action'),
    Genre(id: 2, name: 'Comedy'),
    Genre(id: 3, name: 'Horror'),
  ];

  int _nextId = 4;

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


  Future<void> _showAddEditDialog({Genre? genre}) async {
    final controller = TextEditingController(text: genre?.name ?? '');
    final isNew = genre == null;

    await showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isNew ? 'Tambah Genre Baru' : 'Edit Genre',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Masukkan nama genre...',
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Batal'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal[600],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                    onPressed: () {
                      final name = controller.text.trim();
                      if (name.isEmpty) return;
                      if (isNew) _addGenre(name);
                      else _editGenre(genre!.id, name);
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Simpan',
                      style:
                      TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }


  Future<void> _confirmDelete(Genre g) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Genre',
            style: TextStyle(fontWeight: FontWeight.w600)),
        content: Text('Yakin ingin menghapus genre "${g.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[400],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus',
                style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );

    if (ok == true) _deleteGenre(g.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.teal[600],
        elevation: 6,
        shadowColor: Colors.tealAccent,
        title: const Text(
          'Manajemen Genre',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _genres.isEmpty
            ? Center(
          child: Text(
            'Belum ada genre.',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        )
            : ListView.separated(
          itemCount: _genres.length,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (context, i) {
            final g = _genres[i];
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.teal.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.teal[100],
                  child: const Icon(Icons.category, color: Colors.teal),
                ),
                title: Text(
                  g.name,
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w500),
                ),
                trailing: PopupMenuButton<String>(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  onSelected: (v) {
                    if (v == 'edit') _showAddEditDialog(genre: g);
                    if (v == 'delete') _confirmDelete(g);
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(value: 'edit', child: Text('Edit')),
                    const PopupMenuItem(value: 'delete', child: Text('Hapus')),
                  ],
                  icon: const Icon(Icons.more_vert),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditDialog(),
        backgroundColor: Colors.teal[600],
        label: const Row(
          children: [
            Icon(Icons.add, color: Colors.white),
            SizedBox(width: 6),
            Text('Tambah Genre',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
