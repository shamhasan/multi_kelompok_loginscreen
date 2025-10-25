import 'package:flutter/material.dart';
import 'package:multi_kelompok/data/movie.dart';

class GenreListPage extends StatelessWidget {
  const GenreListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // The Scaffold provides the basic structure for the page (AppBar, body, etc.)
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Genre Film"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          // GridView.builder is efficient for lists/grids
          // It only builds the items that are visible on the screen.
          itemCount: genres.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            // Sets the number of columns in the grid
            crossAxisCount: 2, // 2 columns by default
            childAspectRatio: 3 / 1, // Aspect ratio of each grid item (width/height)
            crossAxisSpacing: 16, // Spacing between columns
            mainAxisSpacing: 16, // Spacing between rows
          ),
          itemBuilder: (context, index) {
            // Build each genre card
            return _buildGenreCard(context, genres[index]);
          },
        ),
      ),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.lightGreen[100],
        child: Center(
          child: Text(
            genreName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ),
      ),
    );
  }
}

