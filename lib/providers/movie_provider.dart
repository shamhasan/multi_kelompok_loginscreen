import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:multi_kelompok/data/movie.dart';
import 'package:multi_kelompok/models/movie.dart'; // Import yang diperlukan

class AddMovieScreen extends StatefulWidget {
  const AddMovieScreen({super.key});

  @override
  State<AddMovieScreen> createState() => _AddMovieScreenState();
}

class _AddMovieScreenState extends State<AddMovieScreen> {
  // Pindahkan inisialisasi ke initState agar lebih aman
  List<String> _ageRatings = [];
  late String _selectedAgeRating;

  final List _allGenres = genres.map((e) => e).toList();

  final List<String> _selectedGenres = [];

  @override
  void initState() {
    super.initState();
    // 1. Gabungkan semua movie dari data source
    final allMovies = [...popularMovies, ...watchlistitems];

    // 2. Ambil semua ageRating, hilangkan duplikat, dan jadikan list
    _ageRatings = allMovies.map((movie) => movie.ageRating).toSet().toList();

    // 3. Atur nilai awal dengan aman
    if (_ageRatings.isNotEmpty) {
      _selectedAgeRating = _ageRatings[0];
    } else {
      // Fallback jika tidak ada data rating sama sekali
      _selectedAgeRating = "NR";
      _ageRatings.add("NR");
    }
  }

  void _showGenreDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Pilih Genre"),
          content: Container(
            width: double.maxFinite,
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setStateDialog) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: _allGenres.length,
                  itemBuilder: (BuildContext context, int index) {
                    final genre = _allGenres[index];
                    final isSelected = _selectedGenres.contains(genre);
                    return CheckboxListTile(
                      title: Text(genre),
                      value: isSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            _selectedGenres.add(genre);
                          } else {
                            _selectedGenres.remove(genre);
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
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Selesai"),
            ),
          ],
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  onChanged: null,
                  decoration: InputDecoration(
                    labelText: 'Judul Film',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  onChanged: null,
                  decoration: InputDecoration(
                    labelText: 'Deskripsi Film',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  onChanged: null,
                  decoration: InputDecoration(
                    labelText: 'Tahun rilis',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                DropdownButtonFormField(
                  decoration: InputDecoration(
                    labelText: 'Age Rating',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  value: _selectedAgeRating, // Gunakan 'value' bukan 'initialValue'
                  onChanged: (newAgeRate) {
                    setState(() {
                      _selectedAgeRating = newAgeRate.toString();
                    });
                  },
                  isExpanded: true,
                  items: _ageRatings
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                        strokeAlign: BorderSide.strokeAlignCenter,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    height: 120,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.upload_sharp, color: Colors.blueAccent),
                        Text(
                          "Upload Poster",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Genre film: ",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    IconButton(
                      onPressed: _showGenreDialog,
                      icon: Icon(Icons.add_circle, color: Colors.blueAccent),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Wrap(
                  spacing: 8.0, // Jarak horizontal antar chip
                  runSpacing: 4.0, // Jarak vertikal antar baris
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
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlinedButton(
                    onPressed: () {},
                    child: Text(
                      "Tambah",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(Colors.blueAccent[100]!.value),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

