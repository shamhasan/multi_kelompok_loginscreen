import 'package:flutter/material.dart';
import 'dart:math';

import 'package:multi_kelompok/data/movie.dart';
import 'package:multi_kelompok/models/movie.dart';
import 'package:multi_kelompok/providers/review_provider.dart';
import 'package:multi_kelompok/screens/movie_detail_screen.dart';
import 'package:provider/provider.dart';

class PopularMoviesPage extends StatelessWidget {
  const PopularMoviesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Film Populer'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: popularMovies.length,
        itemBuilder: (context, index) {
          final movie = popularMovies[index];
          return _buildMovieListItem(context, movie);
        },
      ),
    );
  }

  Widget _buildMovieListItem(BuildContext context, Movie movie) {
    final screenWidth = MediaQuery.of(context).size.width;

    const double maxPosterWidth = 200.0;
    final double posterWidth = min(screenWidth * 0.3, maxPosterWidth);
    final double posterHeight = posterWidth * 1.5;
    final double titleSize = screenWidth > 720 ? 18 : 16;
    final double detailSize = screenWidth > 720 ? 14 : 12;
    final double chipTextSize = screenWidth > 720 ? 12 : 11;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MovieDetailScreen(movie: movie),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: posterWidth,
                  height: posterHeight,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      movie.posterUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) =>
                      progress == null ? child : const Center(child: CircularProgressIndicator()),
                      errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.movie, color: Colors.grey, size: 40),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(movie.year.toString(), style: TextStyle(color: Colors.grey[600], fontSize: detailSize)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6.0),
                            child: Icon(Icons.circle, size: 3, color: Colors.grey[500]),
                          ),
                          Text(movie.duration, style: TextStyle(color: Colors.grey[600], fontSize: detailSize)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6.0,
                        runSpacing: 4.0,
                        children: movie.genres.map((genre) {
                          return Chip(
                            label: Text(genre),
                            backgroundColor: Colors.green.shade100,
                            labelStyle: TextStyle(color: Colors.green.shade900, fontSize: chipTextSize),
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 8),
                      Consumer<ReviewProvider>(
                        builder: (context, reviewProvider, child) {
                          final averageRating = reviewProvider.getAverageRating(movie.id);
                          return Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: detailSize + 4),
                              const SizedBox(width: 4),
                              Text(
                                averageRating > 0 ? averageRating.toStringAsFixed(1) : "N/A",
                                style: TextStyle(fontSize: detailSize, fontWeight: FontWeight.bold),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      Text(
                        movie.overview,
                        style: TextStyle(fontSize: detailSize, color: Colors.grey[700]),
                        maxLines: 3, 
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
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
