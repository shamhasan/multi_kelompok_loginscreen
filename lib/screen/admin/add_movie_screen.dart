import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:multi_kelompok/Providers/MovieProvider.dart'; // Sesuaikan path ini
import 'package:multi_kelompok/models/movie_model.dart'; // Sesuaikan path ini

class AddMovieScreen extends StatefulWidget {
  const AddMovieScreen({super.key});

  @override
  State<AddMovieScreen> createState() => _AddMovieScreenState();
}

class _AddMovieScreenState extends State<AddMovieScreen> {
  // 1. Inisialisasi Controllers (TUGAS: Menangani Input Teks)
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _yearController = TextEditingController();
  final _durationController = TextEditingController();
  final _posterUrlController = TextEditingController();

  // 2. State Variables
  String _previewImage = ""; // Untuk menampung link gambar preview
  String? _selectedAgeRating;
  final List<String> _selectedGenres = [];
  bool _isNowPlaying = false; // Default: Tidak sedang tayang

  @override
  void initState() {
    super.initState();

    // Fetch data Genre & Age Rating saat halaman dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<MovieProvider>(context, listen: false);
      provider.fetchGenres();
      provider.fetchAgeRatings();
    });

    // LISTENER: Update preview gambar setiap kali text di kolom URL berubah
    _posterUrlController.addListener(() {
      setState(() {
        _previewImage = _posterUrlController.text;
      });
    });
  }

  @override
  void dispose() {
    // Wajib dispose controller agar tidak membebani memori
    _titleController.dispose();
    _descController.dispose();
    _yearController.dispose();
    _durationController.dispose();
    _posterUrlController.dispose();
    super.dispose();
  }

  // --- LOGIKA SUBMIT DATA ---
  void _submitMovie() async {
    // Validasi Input Kosong
    if (_titleController.text.isEmpty ||
        _descController.text.isEmpty ||
        _selectedAgeRating == null ||
        _selectedGenres.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Mohon lengkapi Judul, Deskripsi, Rating, dan Genre"),
            backgroundColor: Colors.red),
      );
      return;
    }

    // Buat Object Movie
    final newMovie = Movie(
      // ID null karena auto-increment di database
      title: _titleController.text,
      overview: _descController.text,
      // Jika poster kosong, pakai gambar placeholder
      posterUrl: _posterUrlController.text.isEmpty
          ? "https://via.placeholder.com/150"
          : _posterUrlController.text,
      isNowPlaying: _isNowPlaying,
      voteCount: 0,
      rating: 0.0,
      // Parse tahun ke integer (default 2024 jika error/kosong)
      year: int.tryParse(_yearController.text) ?? 2024,
      duration: _durationController.text, // Simpan sebagai text (e.g. "2h 15m")
      ageRating: _selectedAgeRating!,
      genres: _selectedGenres,
    );

    try {
      // Panggil Provider untuk kirim ke Supabase
      await Provider.of<MovieProvider>(context, listen: false)
          .addMovie(newMovie);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Berhasil menyimpan film!"),
              backgroundColor: Colors.green),
        );
        Navigator.pop(context); // Kembali ke halaman sebelumnya
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal menyimpan: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  // --- LOGIKA DIALOG GENRE ---
  void _showGenreDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<MovieProvider>(
          builder: (context, provider, child) {
            return AlertDialog(
              title: const Text("Pilih Genre"),
              // Menggunakan SizedBox agar lebar dialog proporsional
              content: SizedBox(
                width: double.maxFinite,
                child: StatefulBuilder(
                  builder: (context, setStateDialog) {
                    final allGenres = provider.genres;
                    
                    if (allGenres.isEmpty) {
                       return const Center(child: Text("Memuat genre..."));
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: allGenres.length,
                      itemBuilder: (context, index) {
                        final genreItem = allGenres[index];
                        final isSelected =
                            _selectedGenres.contains(genreItem.name);

                        return CheckboxListTile(
                          title: Text(genreItem.name),
                          value: isSelected,
                          onChanged: (bool? value) {
                            // 1. Update List di Parent Widget
                            setState(() {
                              if (value == true) {
                                _selectedGenres.add(genreItem.name);
                              } else {
                                _selectedGenres.remove(genreItem.name);
                              }
                            });
                            // 2. Update Tampilan Checkbox di Dialog
                            setStateDialog(() {});
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Selesai"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Movie'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent[100],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 1. INPUT JUDUL
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Judul Film',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 2. INPUT DESKRIPSI
            TextFormField(
              controller: _descController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Deskripsi Film',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 3. ROW: TAHUN & DURASI
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _yearController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Tahun Rilis',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _durationController,
                    decoration: InputDecoration(
                      labelText: 'Durasi (misal: 2h 30m)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 4. DROPDOWN AGE RATING
            Consumer<MovieProvider>(
              builder: (context, provider, child) {
                if (provider.ageRatings.isEmpty) {
                  return const LinearProgressIndicator();
                }
                
                // Validasi value dropdown
                if (_selectedAgeRating != null) {
                   bool exists = provider.ageRatings.any((r) => r.name == _selectedAgeRating);
                   if (!exists) _selectedAgeRating = null;
                }

                return DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Age Rating',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  value: _selectedAgeRating,
                  items: provider.ageRatings.map((e) {
                    return DropdownMenuItem(value: e.name, child: Text(e.name));
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedAgeRating = val;
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 16),

            // 5. INPUT LINK POSTER + PREVIEW
            TextFormField(
              controller: _posterUrlController,
              decoration: InputDecoration(
                labelText: 'Link Poster URL (https://...)',
                prefixIcon: const Icon(Icons.link),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 12),
            
            // Container Preview Gambar
            Container(
              height: 200,
              width: 140,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.grey[200],
              ),
              child: _previewImage.isEmpty
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image_search, size: 40, color: Colors.grey),
                        Text("Preview Poster", style: TextStyle(color: Colors.grey))
                      ],
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        _previewImage,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, stack) => const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.broken_image, color: Colors.red),
                            Text("Link Error", style: TextStyle(fontSize: 12)),
                          ],
                        ),
                        loadingBuilder: (ctx, child, progress) {
                          if (progress == null) return child;
                          return const Center(child: CircularProgressIndicator());
                        },
                      ),
                    ),
            ),
            const SizedBox(height: 16),

            // 6. GENRE SELECTOR
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Genre film: ",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                IconButton(
                  onPressed: _showGenreDialog,
                  icon: const Icon(Icons.add_circle, color: Colors.blueAccent),
                ),
              ],
            ),
            Wrap(
              spacing: 8.0,
              children: _selectedGenres.map((genre) {
                return Chip(
                  label: Text(genre),
                  backgroundColor: Colors.blue[100],
                  deleteIconColor: Colors.red[400],
                  onDeleted: () {
                    setState(() {
                      _selectedGenres.remove(genre);
                    });
                  },
                );
              }).toList(),
            ),
            
            const Divider(height: 30),

            // 7. SWITCH NOW PLAYING (Tambahan)
            SwitchListTile(
              title: const Text("Sedang Tayang? (Now Playing)"),
              value: _isNowPlaying,
              onChanged: (val) => setState(() => _isNowPlaying = val),
            ),

            const SizedBox(height: 24),

            // 8. TOMBOL SIMPAN
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _submitMovie,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  "SIMPAN FILM",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}