import 'package:flutter/material.dart';
import 'dart:math';

import 'package:multi_kelompok/data/movie.dart';

class Movie {
  final String title;
  final String posterUrl;
  final double rating;
  final String overview;
  final List<String> genres;
  final int year;
  final String duration;
  final String ageRating;

  Movie({
    required this.title,
    required this.posterUrl,
    required this.rating,
    required this.overview,
    required this.genres,
    required this.year,
    required this.duration,
    required this.ageRating,
  });
}


class PopularMoviesPage extends StatefulWidget {
  const PopularMoviesPage({super.key});

  @override
  State<PopularMoviesPage> createState() => _PopularMoviesPageState();
}

class _PopularMoviesPageState extends State<PopularMoviesPage> {
  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Movie'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: popularMovies.length,
        itemBuilder: (context, index) {
          final movie = popularMovies[index];
          return _buildMovieListItem(context, movie, index);
        },
      ),
    );
  }

  Widget _buildMovieListItem(BuildContext context, Movie movie, int index) {
    final bool isExpanded = _expandedIndex == index;
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
            setState(() {
              _expandedIndex = isExpanded ? null : index;
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: posterWidth,
                      height: posterHeight,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset(
                          movie.posterUrl,
                          fit: BoxFit.cover,
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
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                                child: Icon(Icons.circle, size: 3, color: Colors.grey[500]),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade500),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: Text(movie.ageRating, style: TextStyle(color: Colors.grey[700], fontSize: detailSize - 1, fontWeight: FontWeight.w500)),
                              )
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
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: detailSize + 4),
                              const SizedBox(width: 4),
                              Text(
                                movie.rating > 0 ? movie.rating.toString() : "N/A",
                                style: TextStyle(fontSize: detailSize, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: Container(
                    child: isExpanded
                        ? Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Text(movie.overview, style: TextStyle(fontSize: detailSize, color: Colors.grey[700])),
                    )
                        : const SizedBox.shrink(),
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