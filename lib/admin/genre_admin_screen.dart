import 'package:flutter/material.dart';
import 'package:multi_kelompok/admin/add_genre_screen.dart';
import 'package:multi_kelompok/admin/movie_admin_screen.dart';
import 'package:multi_kelompok/data/movie.dart';

class GenreAdminScreen extends StatelessWidget {
  const GenreAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            // GridView.builder is efficient for lists/grids
            // It only builds the items that are visible on the screen.
            itemCount: genres.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              // Sets the number of columns in the grid
              crossAxisCount: 2, // 2 columns by default
              childAspectRatio:
                  3 / 1, // Aspect ratio of each grid item (width/height)
              crossAxisSpacing: 8, // Spacing between columns
              mainAxisSpacing: 8, // Spacing between rows
            ),
            itemBuilder: (context, index) {
              // Build each genre card
              return _buildGenreCard(context, genres[index]);
            },
          ),
        ),
        Container(
          alignment: Alignment.bottomRight,
          margin: const EdgeInsets.all(16),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddGenreScreen()),
              );
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  // Helper method to create the visual card for a single genre
  Widget _buildGenreCard(BuildContext context, String genreName) {
    return InkWell(
      onTap: () {
        // Handle genre tap (e.g., navigate to a list of movies in that genre)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Melihat film genre: $genreName")),
        );
      },
      child: Card(
        // Card is a material design container with rounded corners and elevation
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: const Color.fromARGB(255, 185, 229, 249),
        child: Center(
          child: Text(
            genreName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
        ),
      ),
    );
  }
}
