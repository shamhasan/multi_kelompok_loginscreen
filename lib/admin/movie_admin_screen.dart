import 'package:flutter/material.dart';
import 'package:multi_kelompok/admin/add_movie_screen.dart';
import 'package:multi_kelompok/data/movie.dart';
import 'package:multi_kelompok/models/movie.dart'; // Import model Movie

class MovieAdminScreen extends StatelessWidget {
  const MovieAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Gabungkan kedua list menjadi satu
    final List<Movie> allMovies = [...popularMovies, ...watchlistitems];

    return Stack(
      children: [
        ListView.builder(
          itemCount: allMovies.length,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            // Buat variabel lokal untuk akses yang lebih mudah
            final movie = allMovies[index];

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                        movie.imageUrl,
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
                            movie.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            movie.genres.join(', '),
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            movie.duration,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[900],
                            ),
                          ),
                          Text(
                            "⭐" + movie.rating.toString(),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 100,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  FloatingActionButton(
                                    onPressed: () {},
                                    child: Icon(Icons.delete),
                                    mini: true,
                                    backgroundColor: Colors.redAccent[200],
                                  ),
                                  const SizedBox(width: 8),
                                  FloatingActionButton(
                                    onPressed: () {},
                                    child: Icon(Icons.edit),
                                    mini: true,
                                    backgroundColor: Colors.green[200],
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
        Container(
          alignment: Alignment.bottomRight,
          margin: const EdgeInsets.all(16),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddMovieScreen()),
              );
            },
            child: const Icon(Icons.add),
            backgroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}