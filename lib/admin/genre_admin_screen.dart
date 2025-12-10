import 'package:flutter/material.dart';
import 'package:multi_kelompok/Providers/MovieProvider.dart';
import 'package:multi_kelompok/admin/add_genre_screen.dart';
import 'package:provider/provider.dart';

class GenreAdminScreen extends StatefulWidget {
  const GenreAdminScreen({super.key});

  @override
  State<GenreAdminScreen> createState() => _GenreAdminScreenState();
}

class _GenreAdminScreenState extends State<GenreAdminScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        Provider.of<MovieProvider>(context, listen: false).fetchGenres();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, MovieProvider provider, Widget? child) {
        final genres = provider.genres;

        if (genres.isEmpty) {
          return const Center(child: Text("Belum ada data genre."));
        }
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                itemCount: genres.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 columns by default
                  childAspectRatio:
                      3 / 1, // Aspect ratio of each grid item (width/height)
                  crossAxisSpacing: 8, // Spacing between columns
                  mainAxisSpacing: 8, // Spacing between rows
                ),
                itemBuilder: (context, index) {
                  final genreName = genres[index].name;
                  // Build each genre card
                  return _buildGenreCard(context, genreName);
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
      },
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
