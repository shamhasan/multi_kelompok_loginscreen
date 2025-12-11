import 'package:flutter/material.dart';
import 'package:multi_kelompok/data/movie.dart'; // Pastikan file ini ada
import 'package:multi_kelompok/genre_list.dart'; // GenreViewPage ada di sini
import 'package:multi_kelompok/popular_movie_ui.dart';
import 'package:multi_kelompok/profile_ui.dart';
import 'package:multi_kelompok/providers/review_provider.dart';
import 'package:multi_kelompok/screens/movie_detail_screen.dart';
import 'package:multi_kelompok/watchlist.dart';
import 'dart:math';
import 'package:provider/provider.dart';

// --- DEFINISI WARNA SENADA ---
const Color _primaryColor = Color(0xFF469756); // Hijau Tua
const Color _accentColor = Color(0xFF88D68A);  // Hijau Muda/Aksen
const Color _backgroundColor = Color(0xFFF0F8FF); // Background Cerah

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const _HomeContent(),
    const ProfileUi(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? '🎬 CineWatch' : '👤 Profile'),
        centerTitle: true,
        backgroundColor: _primaryColor,
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: Colors.white,
        ),
      ),
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: _primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({Key? key}) : super(key: key);

  // Widget Pembagi (Divider) Kustom
  Widget _buildSectionHeader(BuildContext context, String title, Widget? seeMoreAction) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Colors.black87,
            ),
          ),
          if (seeMoreAction != null)
            TextButton(
              onPressed: () {
                // Navigasi yang disederhanakan
                if (title == 'Genres') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const GenreViewPage()));
                } else if (title == 'Watchlist') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const WatchlistPage()));
                } else if (title == 'Popular Movies') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const PopularMoviesPage()));
                }
              },
              child: Text(
                'See More',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: _primaryColor,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Bagian Genres
          _buildSectionHeader(context, 'Genres', const Text('See More')),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: genres.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Chip(
                    label: Text(
                      genres[index],
                      style: TextStyle(
                        color: _primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    backgroundColor: _accentColor.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: _primaryColor.withOpacity(0.5)),
                    ),
                  ),
                );
              },
            ),
          ),

          // 2. Bagian Now Playing
          _buildSectionHeader(context, "Now Playing", null),
          SizedBox(
            height: 300,
            child: ListView.builder(
              itemCount: nowPlayingItems.length,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final item = nowPlayingItems[index % nowPlayingItems.length];
                return Padding(
                  padding: EdgeInsets.only(left: index == 0 ? 16.0 : 8.0, right: 8.0),
                  child: InkWell(
                    onTap: () {
                      // TODO: Navigasi ke MovieDetailScreen
                    },
                    child: SizedBox(
                      width: 150,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 220,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                              image: DecorationImage(
                                image: NetworkImage(item['imageurl']!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item['title']!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            item['genre']!,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),

          // 3. Bagian Watchlist (DIUBAH MENJADI HORIZONTAL LIST)
          _buildSectionHeader(context, "Watchlist", const Text('See More')),

          SizedBox(
            height: 220, // Ketinggian yang konsisten
            child: ListView.builder(
              itemCount: watchlistitems.length,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemBuilder: (context, index) {
                final movie = watchlistitems[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: InkWell(
                    onTap: () {
                      // TODO: Navigasi ke detail film
                    },
                    child: Container(
                      width: 140, // Lebar item
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        image: DecorationImage(
                          image: NetworkImage(movie.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Tambahkan gradient overlay
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.6)
                            ],
                          ),
                        ),
                        alignment: Alignment.bottomLeft,
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          // movie.title, // Asumsi model watchlistitems memiliki properti 'id' atau 'title'
                          'Movie ${movie.id}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),


          // 4. Bagian Popular Movie
          _buildSectionHeader(context, "Popular Movies", const Text('See More')),
          ListView.builder(
            itemCount: min(4, popularMovies.length),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final item = popularMovies[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailScreen(movie: item),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Poster
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          item.imageUrl,
                          width: 80,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                width: 80,
                                height: 120,
                                color: _accentColor.withOpacity(0.5),
                                child: Icon(
                                  Icons.movie,
                                  color: _primaryColor,
                                  size: 40,
                                ),
                              ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Detail
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.genres.join(', '),
                              style: TextStyle(
                                fontSize: 14,
                                color: _primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item.duration,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Consumer<ReviewProvider>(
                              builder: (context, reviewProvider, child) {
                                final averageRating = reviewProvider.getAverageRating(item.id);
                                return Row(
                                  children: [
                                    const Icon(Icons.star, color: Colors.amber, size: 20),
                                    const SizedBox(width: 4),
                                    Text(
                                      averageRating > 0
                                          ? averageRating.toStringAsFixed(1)
                                          : "N/A",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                );
                              },
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
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}