import 'package:flutter/material.dart';
import 'package:multi_kelompok/providers/genre_provider.dart';
import 'package:provider/provider.dart';
import 'package:multi_kelompok/providers/MovieProvider.dart';
import 'package:multi_kelompok/models/movie_model.dart';

class EditMovieScreen extends StatefulWidget {
  final Movie movie;

  const EditMovieScreen({super.key, required this.movie});

  @override
  State<EditMovieScreen> createState() => _EditMovieScreenState();
}

class _EditMovieScreenState extends State<EditMovieScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _yearController = TextEditingController();
  final _durationController = TextEditingController();
  final _posterUrlController = TextEditingController();

  String _previewImage = "";
  String? _selectedAgeRating;
  List<String> _selectedGenres = [];
  bool _isNowPlaying = false;

  @override
  void initState() {
    super.initState();

    _titleController.text = widget.movie.title;
    _descController.text = widget.movie.overview;
    _yearController.text = widget.movie.year.toString();
    _durationController.text = widget.movie.duration;
    _posterUrlController.text = widget.movie.posterUrl;
    
    _previewImage = widget.movie.posterUrl;
    _selectedAgeRating = widget.movie.ageRating;
    _isNowPlaying = widget.movie.isNowPlaying;
    
    _selectedGenres = List.from(widget.movie.genres);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<MovieProvider>(context, listen: false);
      final providerG = Provider.of<GenreProvider>(context, listen: false);
      providerG.fetchGenres(context);
      provider.fetchAgeRatings();
    });

    _posterUrlController.addListener(() {
      setState(() {
        _previewImage = _posterUrlController.text;
      });
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _yearController.dispose();
    _durationController.dispose();
    _posterUrlController.dispose();
    super.dispose();
  }

  void _updateMovie() async {
    if (_titleController.text.isEmpty || 
        _descController.text.isEmpty || 
        _selectedAgeRating == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data tidak boleh kosong"), backgroundColor: Colors.red),
      );
      return;
    }

    final updatedMovie = Movie(
      id: widget.movie.id,
      title: _titleController.text,
      overview: _descController.text,
      posterUrl: _posterUrlController.text.isEmpty 
          ? "https://via.placeholder.com/150" 
          : _posterUrlController.text,
      isNowPlaying: _isNowPlaying,
      likes: widget.movie.likes,
      rating: widget.movie.rating,
      year: int.tryParse(_yearController.text) ?? 2024,
      duration: _durationController.text,
      ageRating: _selectedAgeRating!,
      genres: _selectedGenres,
    );

    try {
      await Provider.of<MovieProvider>(context, listen: false).updateMovie(updatedMovie);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Film berhasil diperbarui!"), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal update: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _showGenreDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer2<MovieProvider, GenreProvider>(
          builder: (context, movieProvider,genreProvider, child) {
            return AlertDialog(
              title: const Text("Pilih Genre"),
              content: SizedBox(
                width: double.maxFinite,
                child: StatefulBuilder(
                  builder: (context, setStateDialog) {
                    final allGenres = genreProvider.genres;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: allGenres.length,
                      itemBuilder: (context, index) {
                        final genreItem = allGenres[index];
                        final isSelected = _selectedGenres.contains(genreItem.name);
                        return CheckboxListTile(
                          title: Text(genreItem.name),
                          value: isSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                _selectedGenres.add(genreItem.name);
                              } else {
                                _selectedGenres.remove(genreItem.name);
                              }
                            });
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
        title: const Text('Edit Movie'),
        centerTitle: true,
        backgroundColor: Colors.green[200],
      ),      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Judul Film',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Deskripsi Film',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _yearController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Tahun Rilis',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _durationController,
                    decoration: InputDecoration(
                      labelText: 'Durasi',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Consumer<MovieProvider>(
              builder: (context, provider, child) {
                if (provider.ageRatings.isEmpty) return const LinearProgressIndicator();
                
                if (_selectedAgeRating != null && 
                    !provider.ageRatings.any((r) => r.name == _selectedAgeRating)) {
                }

                return DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Age Rating',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                  ),
                  value: _selectedAgeRating,
                  items: provider.ageRatings.map((e) {
                    return DropdownMenuItem(value: e.name, child: Text(e.name));
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedAgeRating = val),
                );
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _posterUrlController,
              decoration: InputDecoration(
                labelText: 'Link Poster URL',
                prefixIcon: const Icon(Icons.link),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 200,
              width: 140,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.grey[200],
              ),
              child: _previewImage.isEmpty
                  ? const Center(child: Icon(Icons.image, size: 40))
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(_previewImage, fit: BoxFit.cover,
                        errorBuilder: (ctx, _, __) => const Icon(Icons.broken_image)),
                    ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Genre film: ", style: TextStyle(fontWeight: FontWeight.bold)),
                ElevatedButton( 
                  onPressed: _showGenreDialog,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[50]),
                  child: const Text("Edit Genre"),
                ),
              ],
            ),
            Wrap(
              spacing: 8.0,
              children: _selectedGenres.map((genre) {
                return Chip(
                  label: Text(genre),
                  backgroundColor: Colors.blue[100],
                  onDeleted: () => setState(() => _selectedGenres.remove(genre)),
                );
              }).toList(),
            ),
            
            const Divider(height: 30),
            SwitchListTile(
              title: const Text("Sedang Tayang? (Now Playing)"),
              value: _isNowPlaying,
              onChanged: (val) => setState(() => _isNowPlaying = val),
            ),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _updateMovie,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, 
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text(
                  "UPDATE FILM",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
