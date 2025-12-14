import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:multi_kelompok/Providers/MovieProvider.dart';
import 'package:multi_kelompok/providers/genre_provider.dart';
import 'package:multi_kelompok/screen/daftar_genre.dart';
import 'package:multi_kelompok/screen/movie_detail_screen.dart';
import 'package:multi_kelompok/screen/profile_ui.dart';
import 'package:multi_kelompok/screen/watchlist.dart';

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
      Provider.of<GenreProvider>(context, listen: false).fetchGenres(context);
      Provider.of<MovieProvider>(context, listen: false).fetchMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? 'App Movies 🎥' : 'Profile'),
        centerTitle: true,
        backgroundColor: Colors.lightGreen[200],
      ),
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        onTap: _onItemTapped,
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // PERBAIKAN: Gunakan Consumer2 (MovieProvider + GenreProvider)
    return Consumer2<MovieProvider, GenreProvider>(
      builder: (context, movieProvider, genreProvider, child) {
        
        // 1. Ambil Movies dari MovieProvider
        final movies = movieProvider.movies;
        
        // 2. Ambil Genres dari GenreProvider (INI YANG PENTING)
        final genres = genreProvider.genres; 

        // Filter Now Playing
        final nowPlayingMovies = movies.where((m) => m.isNowPlaying).toList();
        final nowPlayingItems = nowPlayingMovies.isNotEmpty 
            ? nowPlayingMovies 
            : movies.take(5).toList();

        // LOGIC LOADING:
        // Cek isLoading dari provider (jika sudah kamu tambahkan variable isLoading di provider)
        // Atau cek isEmpty seperti logic awal kamu, tapi sekarang sumber datanya sudah benar.
      

        if (genres.isEmpty || movies.isEmpty) {
          // Opsi: Tetap tampilkan loading jika data kosong tapi provider tidak error
          // Atau tampilkan pesan kosong
          return const Center(child: Text("Data kosong / Loading..."));
        }
        
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- GENRES SECTION ---
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Genres',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const GenreAdminPage()),
                        );
                      },
                      child: const Text('See More', style: TextStyle(color: Colors.blue)),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: genres.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      child: Chip(
                        label: Text(genres[index].name),
                        backgroundColor: Colors.deepOrange.shade100,
                      ),
                    );
                  },
                ),
              ),

              // ... (Sisa kode ke bawah SAMA PERSIS dengan punya kamu) ...
              
              // --- NOW PLAYING SECTION ---
              Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.grey[200],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Now Playing", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(
                      height: 280, 
                      child: ListView.builder(
                        itemCount: nowPlayingItems.length,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final movie = nowPlayingItems[index];
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MovieDetailScreen(movie: movie),
                                ),
                              );
                            },
                            child: Container(
                              width: 150,
                              margin: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      movie.posterUrl,
                                      height: 200,
                                      width: 150,
                                      fit: BoxFit.cover,
                                      errorBuilder: (ctx, err, stack) => Container(
                                        height: 200, color: Colors.grey, child: const Icon(Icons.broken_image)
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    movie.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
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
              ),

              // --- POPULAR / ALL MOVIES SECTION ---
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("All Movies", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const WatchlistPage()),
                            );
                          },
                          child: const Text('See More', style: TextStyle(color: Colors.blue)),
                        ),
                      ],
                    ),
                    GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.55, 
                      ),
                      itemCount: min(6, movies.length),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final movieItem = movies[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MovieDetailScreen(movie: movieItem),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blueGrey[50],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                                    child: Image.network(
                                      movieItem.posterUrl,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        movieItem.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}