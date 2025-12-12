import 'package:flutter/material.dart';
import 'package:multi_kelompok/data/movie.dart';
import 'package:multi_kelompok/models/movie.dart';
import 'package:multi_kelompok/screens/movie_detail_screen.dart';

class WatchlistPage extends StatelessWidget {
  const WatchlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Watchlist Movie")),
      body: ListView.builder(
        itemCount: watchlistitems.length,
        itemBuilder: (context, index) {
          // Langsung gunakan objek Movie karena watchlistitems sudah List<Movie>
          final Movie movie = watchlistitems[index];
          return InkWell(
            onTap: () {
              // Tidak perlu lagi mencari, langsung navigasi dengan objek movie
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDetailScreen(movie: movie),
                ),
              );
            },
            child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12, blurRadius: 5, offset: Offset(0, 3)),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        movie.imageUrl, // Langsung pakai atribut dari objek Movie
                        width: 80,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 80,
                            height: 120,
                            color: Colors.grey[200],
                            child: const Icon(Icons.movie_creation_outlined, color: Colors.grey, size: 40),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie.title, // Langsung pakai atribut dari objek Movie
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            movie.genres.join(', '), // Gabungkan genre menjadi satu string
                            style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            movie.duration, // Langsung pakai atribut dari objek Movie
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[900],
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Penambahan Atribut Rating
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 20),
                              const SizedBox(width: 4),
                              Text(
                                movie.rating.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          );
        },
      ),
    );
  }
}
