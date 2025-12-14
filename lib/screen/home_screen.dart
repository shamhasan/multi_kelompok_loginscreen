import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:multi_kelompok/models/movie_model.dart';
import 'package:multi_kelompok/providers/MovieProvider.dart';
import 'package:multi_kelompok/providers/genre_provider.dart';
import 'package:multi_kelompok/providers/watchlist_provider.dart';
import 'package:multi_kelompok/screen/movie_detail_screen.dart'; // DIUBAH
import 'package:multi_kelompok/screen/popular_movie_ui.dart';
import 'package:multi_kelompok/screen/profile_ui.dart';
import 'package:multi_kelompok/screen/user_genre_page.dart';
import 'package:multi_kelompok/screen/watchlist.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Hanya ada dua halaman utama: Home dan Profile
  static final List<Widget> _widgetOptions = <Widget>[
    const _HomeContent(), // Konten utama halaman Home
    const ProfileUi(),
  ];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }
    // Mengambil semua data yang dibutuhkan saat aplikasi pertama kali dimuat
  void _fetchData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GenreProvider>(context, listen: false).fetchGenres(context);
      Provider.of<MovieProvider>(context, listen: false).fetchMovies();
      Provider.of<WatchlistProvider>(context, listen: false).loadWatchlist();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
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
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

// Widget _HomeContent sekarang menjadi pusat dari UI branch 'main'
class _HomeContent extends StatelessWidget {
  const _HomeContent();

  // Fungsi helper untuk navigasi dan refresh data
  void _navigateToDetailAndRefresh(BuildContext context, int movieId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MovieDetailScreen(movieId: movieId)),
    ).then((_) {
      // Setelah kembali dari halaman detail, muat ulang semua data relevan
      Provider.of<MovieProvider>(context, listen: false).fetchMovies();
      Provider.of<WatchlistProvider>(context, listen: false).loadWatchlist();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Menggunakan Consumer untuk mendengarkan perubahan dari beberapa provider sekaligus
    return Consumer3<MovieProvider, GenreProvider, WatchlistProvider>(
      builder: (context, movieProvider, genreProvider, watchlistProvider, child) {
        // Ambil data dari masing-masing provider
        final genres = genreProvider.genres;
        final movies = movieProvider.movies;
        final nowPlayingItems = movies.where((m) => m.isNowPlaying).toList();
        final popularMovies = List<Movie>.from(movies);
        popularMovies.sort((a, b) => b.likes.compareTo(a.likes));
        final popularMoviesToShow = popularMovies.take(4).toList(); // ambil 4 film teratas

        if (genres.isEmpty || movies.isEmpty) {
          // Opsi: Tetap tampilkan loading jika data kosong tapi provider tidak error
          // Atau tampilkan pesan kosong
          return const Center(child: Text("Data kosong / Loading..."));
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bagian Genre
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Genres', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    TextButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const GenrePage())),
                      child: const Text('See More', style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.blue)),
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

              // Bagian Now Playing
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
                      height: 300,
                      child: ListView.builder(
                        itemCount: nowPlayingItems.length,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final movie = nowPlayingItems[index];
                          return GestureDetector(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MovieDetailScreen(movieId: movie.id!))),
                            child: Container(
                              height: 220,
                              width: 150,
                              margin: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(movie.posterUrl, fit: BoxFit.cover, width: double.infinity, errorBuilder: (c, e, s) => const Icon(Icons.movie, size: 50, color: Colors.grey)),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                                    child: Text(movie.title, maxLines: 2, overflow: TextOverflow.ellipsis),
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

              // Bagian Watchlist
              Container(
                color: Colors.white12,
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("My Watchlist", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                        TextButton(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const WatchlistPage())),
                          child: const Text('See More', style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.blue)),
                        ),
                      ],
                    ),
                    Consumer<WatchlistProvider>(
                      builder: (context, watchlistProvider, child) {
                        if (watchlistProvider.isLoading) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (watchlistProvider.watchlist.isEmpty) {
                          return Container(
                            height: 100,
                            alignment: Alignment.center,
                            child: const Text("Watchlist masih kosong.", style: TextStyle(fontSize: 16, color: Colors.grey)),
                          );
                        }

                        return SizedBox(
                          height: 220,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: watchlistProvider.watchlist.length,
                            itemBuilder: (context, index) {
                              final Movie movie = watchlistProvider.watchlist[index];
                              return GestureDetector(
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MovieDetailScreen(movieId: movie.id!))),
                                child: Container(
                                  width: 150,
                                  margin: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Image.network(
                                            movie.posterUrl,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            errorBuilder: (context, error, stackTrace) =>
                                                const Center(child: Icon(Icons.movie, color: Colors.grey, size: 40)),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0, left: 4.0, right: 4.0),
                                        child: Text(movie.title, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Bagian Popular Movie
              Container(
                color: Colors.grey[200],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Popular Movie", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                        TextButton(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PopularMoviesPage())),
                          child: const Text('See More', style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.blue)),
                        ),
                      ],
                    ),
                    ListView.builder(
                      itemCount: popularMoviesToShow.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final movieItem = popularMovies[index];
                        return InkWell(
                          onTap: () => _navigateToDetailAndRefresh(context, movieItem.id!),
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blueGrey[200],
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3))],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    movieItem.posterUrl,
                                    width: 80,
                                    height: 120,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        Container(
                                          width: 80, height: 120, color: Colors.grey[200],
                                          child: const Icon(Icons.movie, color: Colors.blue, size: 40),
                                        ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(movieItem.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 7),
                                      Text(movieItem.genres.join(', '), style: const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 8),
                                      Text(movieItem.duration, style: TextStyle(fontSize: 14, color: Colors.grey[900])),
                                      const SizedBox(height: 8),
                                      // PERBAIKAN: Menggunakan 'likes' bukan 'rating'
                                      Row(
                                        children: [
                                          Icon(Icons.thumb_up, color: Colors.green, size: 16),
                                          const SizedBox(width: 4),
                                          Text(movieItem.likes.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                                        ],
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