import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'movies_by_genres.dart';

final supabase = Supabase.instance.client;

// --- Model ---
class Genre {
  final int id;
  String name;
  final DateTime createdAt;
  String? description; // 👈 1. TAMBAH PROPERTI BARU

  Genre({required this.id, required this.name, required this.createdAt, this.description}); // 👈 Tambah di Constructor
  factory Genre.fromMap(Map<String, dynamic> map) {
    return Genre(
      id: map['id'] as int,
      name: map['name'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      description: map['description'] as String?, // 👈 Ambil data dari DB
    );
  }
}

// --- Main Widget ---
class GenreAdminPage extends StatefulWidget {
  const GenreAdminPage({super.key});

  @override
  State<GenreAdminPage> createState() => _GenreAdminPageState();
}

class _GenreAdminPageState extends State<GenreAdminPage> {
  List<Genre> _genres = []; // 👈 PERUBAHAN: List kosong, akan diisi dari DB
  bool _isLoading = true;  // 👈 PERUBAHAN: State untuk indikator loading


  // Konstanta Warna untuk Tema yang Lebih Segar (Cerulean Blue)
  static const Color _primaryColor = Color(0xFF469756);
  static const Color _secondaryColor = Color(0xFF88D68A);
  static const Color _accentColor = Color(0xFF457346);
  static const Color _backgroundColor = Color(0xFFF0F8FF); // Light Blue Background

  @override
  void initState() {
    super.initState();
    _fetchGenres(); // 👈 PERUBAHAN: Panggil fungsi READ di sini
  }

  // --- 3. Logic Metode CRUD (Terintegrasi Supabase) ---

  // 1. ⚙️ READ: Mengambil semua genre
  Future<void> _fetchGenres() async {
    // Memeriksa apakah widget masih terpasang
    if (!mounted) return;

    // Mulai loading, tampilkan CircularProgressIndicator
    setState(() => _isLoading = true);

    try {
      // Panggil Supabase: SELECT data dari tabel 'genres', ambil 3 kolom, lalu urutkan
      final List<Map<String, dynamic>> response = await supabase
          .from('genres') // Target tabel: genres
          .select('id, name, created_at, description')
          .order('id', ascending: true);

      // Konversi hasil respons Map ke List<Genre> menggunakan Genre.fromMap
      final fetchedGenres = response
          .map((item) => Genre.fromMap(item))
          .toList();

      // Perbarui state lokal dengan data yang baru diambil
      setState(() {
        _genres = fetchedGenres;
      });
    } catch (e) {
      // Tampilkan error jika gagal mengambil data
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error Read Data: ${e.toString()}')));
      }
    } finally {
      // Selalu hentikan loading, baik sukses maupun gagal
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // 2. ➕ CREATE: Menambah genre baru
  Future<void> _addGenre(String name, String description) async {
    try {
      // INSERT data ke Supabase dan KUNCI: gunakan .select() untuk mendapatkan ID dan created_at
      final List<Map<String, dynamic>> response = await supabase
          .from('genres')
          .insert({'name': name.trim(), 'description': description.trim()})
          .select();

      if (response.isNotEmpty) {
        // Konversi data balikan (row baru) ke objek Genre
        final newGenre = Genre.fromMap(response.first);

        // Perbarui state lokal (tambahkan ke list yang ada)
        setState(() => _genres.add(newGenre));

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(
                  'Genre "${newGenre.name}" berhasil ditambahkan!')));
        }
      }
    } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menambah genre: ${e.toString()}')));
    }
  }
  }


  // 3. ✍️ UPDATE: Mengedit nama genre
  Future<void> _editGenre(int id, String newName, String newDescription) async {
    try {
      await supabase
          .from('genres')
          .update({'name': newName.trim(), 'description': newDescription.trim()}) // 👈 KIRIM DATA BARU
          .eq('id', id);

      // Perbarui state lokal (cari index dan ubah namanya)
      setState(() {
        final i = _genres.indexWhere((g) => g.id == id);
        if (i != -1) {
          _genres[i].name = newName.trim();
          _genres[i].description = newDescription.trim();
        }
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Genre berhasil diperbarui!')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal mengedit genre: ${e.toString()}')));
      }
    }
  }

  // 4. ❌ DELETE: Menghapus genre
  Future<void> _deleteGenre(int id, String name) async {
    try {
      await supabase
          .from('movie_genres')
          .delete()
          .eq('genre_id', id);
      // DELETE data: FILTER dengan .eq('id', id)
      await supabase
          .from('genres')
          .delete()
          .eq('id', id);

      // Hapus dari state lokal
      setState(() {
        _genres.removeWhere((g) => g.id == id);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Genre "$name" berhasil dihapus!')));
      }
    } catch (e) {
      if (mounted) {
        // Penanganan error FK Constraint (jika genre masih terhubung ke tabel movie_genres)
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menghapus genre. Mungkin genre masih terhubung ke Film (Tabel movie_genres). Detail: ${e.toString()}')));
      }
    }
  }

  // --- Dialog Tambah/Edit (Peningkatan Desain) ---

  Future<void> _showAddEditDialog({Genre? genre}) async {
    final nameController = TextEditingController(text: genre?.name ?? ''); // Ubah nama controller
    final descController = TextEditingController(text: genre?.description ?? ''); // 👈 3. CONTROLLER BARU
    final isNew = genre == null;
    final formKey = GlobalKey<FormState>();
    bool isSaving = false;

    await showDialog(
      context: context,
        builder: (context) => StatefulBuilder( // 👈 GUNAKAN INI
            builder: (context, setStateSB) { // setStateSB adalah fungsi setState khusus dialog
              return Dialog(
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
                    isNew ? 'Masukkan nama genre film.' : 'Perbarui nama genre film.',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
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
                        borderRadius: BorderRadius.circular(16), // Radius lebih besar
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
                        maxLength: 100, // Batasi panjang deskripsi
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
                      const SizedBox(width: 12),FilledButton.icon(
                        icon: isSaving
                            ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) // 👈 Tampilkan Spinner
                            : Icon(isNew ? Icons.add : Icons.save),
                        onPressed: isSaving
                            ? null // Disable tombol saat isSaving = true
                            : () async {
                          if (formKey.currentState!.validate()) {
                            setStateSB(() => isSaving = true); // 👈 1. Mulai loading di dialog
                            final name = nameController.text.trim();
                            final description = descController.text.trim();

                            if (isNew) {
                              await _addGenre(name, description); // 👈 await di sini
                            } else {
                              await _editGenre(genre!.id, name, description); // 👈 await di sini
                            }

                            setStateSB(() => isSaving = false); // 3. Hentikan loading

                            // 4. Tutup dialog hanya jika proses CRUD selesai
                            if (mounted) Navigator.pop(context);
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
    }
     )     );
  }

  // --- Dialog Konfirmasi Hapus (Peningkatan Desain) ---

  Future<void> _confirmDelete(Genre g) async {
    final ok = await showDialog<bool>(
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
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: _fetchGenres, // 👈 Panggil fungsi READ di sini
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: _isLoading // 👈 Gunakan Ternary Operator
              ? Center(child: CircularProgressIndicator(color: _primaryColor.withOpacity(0.7))) // KONDISI TRUE: Tampilkan Loading
              : _genres.isEmpty
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
        onTap: () {
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
            subtitle: Column( // 👈 Gunakan Column untuk menampung 2 baris informasi
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                // --- Kolom Deskripsi Singkat ---
                Text(
                  genre.description ?? 'Belum ada deskripsi.', // 👈 Tampilkan Deskripsi
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                // --- Kolom ID (Baru) ---
                Text(
                  'ID: ${genre.id}',
                  style: TextStyle(
                      fontSize: 12,
                      color: primaryColor.withOpacity(0.8),
                      fontWeight: FontWeight.w700
                  ),
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
