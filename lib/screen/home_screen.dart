import 'package:flutter/material.dart';
import 'package:multi_kelompok/models/movie_model.dart'; // DIUBAH
import 'package:multi_kelompok/screen/popular_movie_ui.dart';
import 'package:multi_kelompok/screen/profile_ui.dart';
import 'package:multi_kelompok/screens/movie_detail_screen.dart';
import 'package:multi_kelompok/screen/watchlist.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  @override
  void initState() {
    super.initState();
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

class _HomeContent extends StatefulWidget {
  const _HomeContent();

  @override
  State<_HomeContent> createState() => __HomeContentState();
}

class __HomeContentState extends State<_HomeContent> {
  bool _isLoading = true;
  String? _error;
  List<Movie> _allMovies = [];
  List<Movie> _nowPlayingMovies = [];

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  Future<void> _fetchMovies() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final response = await Supabase.instance.client.from('movies')
          .select().order('likes', ascending: false);
      if (mounted) {
        final allMovies = (response as List).map((data) => Movie.fromMap(data)).toList(); // DIUBAH
        setState(() {
          _allMovies = allMovies;
          _nowPlayingMovies = allMovies.where((m) => m.isNowPlaying).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = "Gagal memuat data: $e";
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [IconButton(onPressed: _fetchMovies, icon: const Icon(Icons.refresh))],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(_error!, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _fetchMovies, child: const Text('Coba Lagi'))
        ]),
      );
    }
    return RefreshIndicator(
      onRefresh: _fetchMovies,
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _buildSectionHeader("Now Playing", () {}),
          _buildNowPlayingList(),
          const SizedBox(height: 16),
          _buildSectionHeader("Popular Movies", () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const PopularMoviesPage()));
          }),
          _buildPopularMoviesList(),
        ]),
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onSeeMore) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        TextButton(onPressed: onSeeMore, child: const Text('See More')),
      ]),
    );
  }

  Widget _buildNowPlayingList() {
    return SizedBox(
      height: 250,
      child: _nowPlayingMovies.isEmpty
          ? const Center(child: Text("Tidak ada film yang sedang tayang."))
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _nowPlayingMovies.length,
              itemBuilder: (context, index) {
                final movie = _nowPlayingMovies[index];
                return GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MovieDetailScreen(movieId: movie.id!))).then((_) => _fetchMovies()),
                  child: Container(
                    width: 150,
                    margin: EdgeInsets.only(left: 16, right: index == _nowPlayingMovies.length - 1 ? 16 : 0),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(movie.posterUrl, fit: BoxFit.cover, width: double.infinity, errorBuilder: (c, e, s) => const Icon(Icons.movie, size: 50, color: Colors.grey)),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(movie.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
                    ]),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildPopularMoviesList() {
    final popularMoviesToShow = _allMovies.take(4).toList();
    return ListView.builder(
      itemCount: popularMoviesToShow.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final movie = popularMoviesToShow[index];
        return InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MovieDetailScreen(movieId: movie.id!))).then((_) => _fetchMovies()),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 2, blurRadius: 5)],
            ),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(movie.posterUrl, width: 80, height: 120, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(width: 80, height: 120, color: Colors.grey[200], child: const Icon(Icons.movie, color: Colors.grey, size: 40))),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(movie.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(movie.genres.join(', '), style: const TextStyle(color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  Row(children: [
                    const Icon(Icons.thumb_up, color: Colors.green, size: 16),
                    const SizedBox(width: 4),
                    Text(movie.likes.toString()),
                  ]),
                ]),
              ),
            ]),
          ),
        );
      },
    return Consumer2<MovieProvider, GenreProvider>(
      builder: (context, movieProvider, genreProvider, child) {
        final genres = genreProvider.genres;
        final movies = movieProvider.movies;
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Genres',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GenreAdminPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'See More',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.blue,
                        ),
                      ),
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
              Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.grey[200],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Now Playing",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 300,
                      child: ListView.builder(
                        itemCount: nowPlayingItems.length,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 220,
                                width: 150,
                                margin: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      nowPlayingItems[index %
                                          nowPlayingItems.length]['imageurl']!,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  16.0,
                                  0,
                                  16.0,
                                  0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      nowPlayingItems[index %
                                          nowPlayingItems.length]['title']!,
                                    ),
                                    Text(
                                      nowPlayingItems[index %
                                          nowPlayingItems.length]['genre']!,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // Updated Watchlist Section
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
                          child: Text(
                            "My Watchlist",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const WatchlistPage(),
                              ),
                            );
                          },
                          child: const Text(
                            'See More',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.blue,
                            ),
                          ),
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
                            child: const Text(
                              "Watchlist masih kosong.",
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
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
                                        child: Text(
                                          movie.title,
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
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
                          child: Text(
                            "Popular Movie",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PopularMoviesPage(),
                              ),
                            );
                          },
                          child: const Text(
                            'See More',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                    ListView.builder(
                      itemCount: movies.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final movieItem = movies[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MovieDetailScreen(movie: movieItem),
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
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                              width: 80,
                                              height: 120,
                                              color: Colors.grey[200],
                                              child: const Icon(
                                                Icons.movie,
                                                color: Colors.blue,
                                                size: 40,
                                              ),
                                            ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        movieItem.title,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 7),
                                      Text(
                                        movieItem.genres.join(', '),
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        movieItem.duration,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[900],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Text(
                                            movieItem.rating.toString(),
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Icon(
                                            Icons.star,
                                            color: Colors.amber[600],
                                            size: 16,
                                          ),
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
