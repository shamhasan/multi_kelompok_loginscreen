import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// --- DEFINISI WARNA SENADA ---
const Color _primaryColor = Color(0xFF469756);
const Color _accentColor = Color(0xFF88D68A);

// Gunakan Supabase client yang sama
final supabase = Supabase.instance.client;

class AddGenreScreen extends StatefulWidget {
  const AddGenreScreen({super.key});

  @override
  State<AddGenreScreen> createState() => _AddGenreScreenState();
}

class _AddGenreScreenState extends State<AddGenreScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _genreController = TextEditingController();
  bool _isLoading = false;

  // Fungsi untuk menyimpan genre baru ke Supabase
  Future<void> _saveGenre() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final newGenre = _genreController.text.trim();

        await supabase
            .from('genres')
            .insert({'name': newGenre});

        if (mounted) { // PENTING: Cek apakah screen masih aktif
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Genre "$newGenre" berhasil ditambahkan!'),
              backgroundColor: _primaryColor,
            ),
          );
          // Navigator.pop dilakukan hanya jika widget masih mounted
          Navigator.pop(context, true);
        }
      } catch (e) {
        debugPrint('Error saving genre: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal menambahkan genre: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _genreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Genre Baru', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: _primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Masukkan nama kategori film yang unik.',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _genreController,
                decoration: InputDecoration(
                  labelText: 'Nama Genre',
                  hintText: 'Misalnya: Sci-Fi, Thriller, Documentary',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12), // Border lebih bulat
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: _primaryColor, width: 2), // Fokus menggunakan primary color
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  prefixIcon: const Icon(Icons.category_rounded, color: _primaryColor),
                  fillColor: Colors.white,
                  filled: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama genre wajib diisi.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _saveGenre,
                icon: _isLoading
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                )
                    : const Icon(Icons.cloud_upload_rounded, color: Colors.white),
                label: Text(
                  _isLoading ? 'Menyimpan Data...' : 'Simpan Genre Baru',
                  style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5, // Tambah shadow pada tombol
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}