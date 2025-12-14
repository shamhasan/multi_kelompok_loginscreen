import 'package:flutter/material.dart';
import 'package:multi_kelompok/providers/MovieProvider.dart';
import 'package:multi_kelompok/providers/genre_provider.dart';
import 'package:multi_kelompok/screen/admin/add_movie_screen.dart';
import 'package:multi_kelompok/screen/admin/edit_movie_screen.dart';
import 'package:provider/provider.dart';

class MovieAdminScreen extends StatefulWidget {
  const MovieAdminScreen({super.key});

  @override
  State<MovieAdminScreen> createState() => _MovieAdminScreenState();
}

class _MovieAdminScreenState extends State<MovieAdminScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        Provider.of<MovieProvider>(context, listen: false).fetchMovies();
        Provider.of<GenreProvider>(context, listen: false).fetchGenres(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<MovieProvider, GenreProvider>(
      builder: (BuildContext context, MovieProvider provider,GenreProvider providerG, Widget? child) {
        return Stack(
          children: [
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: provider.sortBy,
                              isExpanded: true,
                              icon: const Icon(Icons.sort),
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'newest',
                                  child: Text("Terbaru"),
                                ),
                                DropdownMenuItem(
                                  value: 'likes_high',
                                  child: Text("Likes Tertinggi"),
                                ),
                                DropdownMenuItem(
                                  value: 'likes_low',
                                  child: Text("Likes Terendah"),
                                ),
                                DropdownMenuItem(
                                  value: 'title_az',
                                  child: Text("Judul A-Z"),
                                ),
                              ],
                              onChanged: (val) {
                                if (val != null) provider.setSortBy(val);
                              },
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: provider
                                  .filterByGenre, // Sesuai nama getter di provider
                              hint: const Text(
                                "Semua Genre",
                                style: TextStyle(fontSize: 13),
                              ),
                              isExpanded: true,
                              icon: const Icon(Icons.filter_list),
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                              items: [
                                // Opsi Default "All"
                                const DropdownMenuItem(
                                  value: null,
                                  child: Text(
                                    "Semua Genre",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                // Looping Genre dari Provider
                                ...providerG.genres
                                    .map((g) => (g.name))
                                    .toSet()
                                    .map((name) {
                                      return DropdownMenuItem(
                                        value: name.toString(),
                                        child: Text(name.toString()),
                                      );
                                    }),
                              ],
                              onChanged: (val) {
                                provider.setFilterGenre(val);
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: provider.movies.length,
                    shrinkWrap: true,
                    physics: provider.movies.length < 2
                        ? const NeverScrollableScrollPhysics() // Tidak bisa scroll jika item dikit
                        : const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (provider.movies.isEmpty) {
                        return const Center(
                          child: Text("Belum ada data film."),
                        );
                      }
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey[200],
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  provider.movies[index].posterUrl ??
                                      "https://via.placeholder.com/150",
                                  height: 200,
                                  width: 130,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      provider.movies[index].title,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      provider.movies[index].genres.join(', '),
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      provider.movies[index].duration,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[900],
                                      ),
                                    ),
                                    // PERBAIKAN: Tampilkan likes, bukan rating
                                    Row(
                                      children: [
                                        Icon(Icons.thumb_up, color: Colors.green, size: 16),
                                        const SizedBox(width: 4),
                                        Text(provider.movies[index].likes.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 100,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            FloatingActionButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) => AlertDialog(
                                                    title: const Text(
                                                      "Hapus Film?",
                                                    ),
                                                    content: Text(
                                                      "Yakin ingin menghapus '${provider.movies[index].title}'?",
                                                    ),
                                                    actions: [
                                                      // Tombol Batal
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                              context,
                                                            ),
                                                        child: const Text(
                                                          "Batal",
                                                        ),
                                                      ),
                                                      // Tombol Hapus
                                                      TextButton(
                                                        onPressed: () async {
                                                          Navigator.pop(
                                                            context,
                                                          ); // Tutup dialog dulu

                                                          try {
                                                            // Panggil fungsi delete di Provider
                                                            await Provider.of<
                                                                  MovieProvider
                                                                >(
                                                                  context,
                                                                  listen: false,
                                                                )
                                                                .deleteMovie(
                                                                  provider
                                                                      .movies[index]
                                                                      .id!,
                                                                );

                                                            // Tampilkan pesan sukses
                                                            if (context
                                                                .mounted) {
                                                              ScaffoldMessenger.of(
                                                                context,
                                                              ).showSnackBar(
                                                                const SnackBar(
                                                                  content: Text(
                                                                    "Film berhasil dihapus",
                                                                  ),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .green,
                                                                ),
                                                              );
                                                            }
                                                          } catch (e) {
                                                            // Tampilkan pesan error
                                                            if (context
                                                                .mounted) {
                                                              ScaffoldMessenger.of(
                                                                context,
                                                              ).showSnackBar(
                                                                SnackBar(
                                                                  content: Text(
                                                                    "Gagal: $e",
                                                                  ),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                ),
                                                              );
                                                            }
                                                          }
                                                        },
                                                        child: const Text(
                                                          "Hapus",
                                                          style: TextStyle(
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                              child: Icon(Icons.delete),
                                              mini: true,
                                              backgroundColor:
                                                  Colors.redAccent[200],
                                            ),
                                            const SizedBox(width: 8),
                                            FloatingActionButton(
                                              onPressed: () {
                                                final movieToEdit =
                                                    provider.movies[index];

                                                // 2. Navigasi ke Edit Screen & kirim datanya
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditMovieScreen(
                                                          movie: movieToEdit,
                                                        ),
                                                  ),
                                                ).then((_) {
                                                  Provider.of<MovieProvider>(
                                                    context,
                                                    listen: false,
                                                  ).fetchMovies();
                                                });
                                              },
                                              child: Icon(Icons.edit),
                                              mini: true,
                                              backgroundColor:
                                                  Colors.green[200],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.bottomRight,
              margin: const EdgeInsets.all(16),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddMovieScreen()),
                  );
                },
                child: Icon(Icons.add),
                backgroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }
}
