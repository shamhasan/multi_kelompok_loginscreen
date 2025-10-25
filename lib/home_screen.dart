import 'package:flutter/material.dart';
import 'package:multi_kelompok/daftar_genre.dart';
import 'package:multi_kelompok/data/movie.dart'; // File data dummy Anda
import 'package:multi_kelompok/popular_movie_ui.dart';
import 'package:multi_kelompok/profile_ui.dart';
import 'package:multi_kelompok/watchlist.dart';
import 'package:multi_kelompok/watchlist_service.dart'; // Import service
import 'package:multi_kelompok/movie_detail.dart'; // Import detail page

// --- Fungsi Navigasi ke Detail Film ---
void navigateToMovieDetail(BuildContext context, int movieId, String title, String overview, String imageUrl) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => MovieDetailPage(
        movieId: movieId,
        title: title,
        overview: overview,
        imageUrl: imageUrl,
      ),
    ),
  );
}

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

// --- Ubah _HomeContent menjadi StatefulWidget ---
class _HomeContent extends StatefulWidget {
  const _HomeContent({Key? key}) : super(key: key);

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  final _watchlistService = WatchlistService();
  Future<List<Map<String, dynamic>>>? _watchlistPreviewFuture;

  @override
  void initState() {
    super.initState();
    // Ambil maksimal 6 item watchlist saat home dimuat
    _watchlistPreviewFuture = _fetchWatchlistPreview();
  }

  // Fungsi untuk mengambil data watchlist (limit 6)
  Future<List<Map<String, dynamic>>> _fetchWatchlistPreview() async {
    final fullList = await _watchlistService.getWatchlist();
    return fullList.take(6).toList();
  }

  // Fungsi untuk refresh data saat kembali dari halaman lain
  void _refreshWatchlistPreview() {
    setState(() {
      _watchlistPreviewFuture = _fetchWatchlistPreview();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ... BAGIAN GENRES (tidak ada perubahan)
          // ...

          // --- BAGIAN NOW PLAYING (Diperbaiki: Tambah GestureDetector) ---
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 300,
                  child: ListView.builder(
                    itemCount: nowPlayingItems.length,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final item = nowPlayingItems[index % nowPlayingItems.length];

                      return GestureDetector(
                        onTap: () async {
                          // Anda perlu memastikan data dummy Anda memiliki ID dan overview
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MovieDetailPage(
                                movieId: int.tryParse(item['id'] ?? '0') ?? 0,
                                title: item['title']!,
                                overview: item['overview'] ?? 'No sinopsis tersedia.',
                                imageUrl: item['imageurl']!,
                              ),
                            ),
                          );
                          // Refresh watchlist preview setelah kembali
                          _refreshWatchlistPreview();
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ... UI film
                            // ...
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // --- BAGIAN WATCHLIST PREVIEW (Diperbaiki: Gunakan Supabase data) ---
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
                        "Watchlist",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WatchlistPage(),
                          ),
                        );
                        // Refresh watchlist preview setelah kembali dari halaman Watchlist
                        _refreshWatchlistPreview();
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

                // Gunakan FutureBuilder untuk Watchlist Preview
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: _watchlistPreviewFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ));
                    }

                    final items = snapshot.data ?? [];

                    if (items.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: Center(
                          child: Text("Belum ada film di watchlist.", style: TextStyle(color: Colors.grey)),
                        ),
                      );
                    }

                    return GridView.count(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: items.map((watchItem) {
                        final movie = watchItem['movies'];
                        if (movie == null) return Container();

                        return GestureDetector(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MovieDetailPage(
                                    movieId: movie['id'],
                                    title: movie['title'],
                                    overview: movie['overview'] ?? '',
                                    imageUrl: movie['poster_url'] ?? ''
                                ),
                              ),
                            );
                            _refreshWatchlistPreview();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(movie['poster_url'] ?? ''),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),

          // --- BAGIAN POPULAR MOVIE (Diperbaiki: Tambah GestureDetector) ---
          Container(
            color: Colors.grey[200],
            child: Column(
              // ... (header dan list film)
              children: [
                // ... (Row Popular Movie header)
                ListView.builder(
                  itemCount: 4,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final item = popularMovies[index];
                    return GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieDetailPage(
                              movieId: item.id,
                              title: item.title,
                              overview: item.overview,
                              imageUrl: item.posterUrl,
                            ),
                          ),
                        );
                        _refreshWatchlistPreview();
                      },
                      child: Container(
                        // ... (sisa UI item film)
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
  }
}


// import 'package:flutter/material.dart';
// import 'package:multi_kelompok/daftar_genre.dart';
// import 'package:multi_kelompok/data/movie.dart';
// import 'package:multi_kelompok/popular_movie_ui.dart';
// import 'package:multi_kelompok/profile_ui.dart';
// import 'package:multi_kelompok/watchlist.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   int _selectedIndex = 0;
//
//   static final List<Widget> _widgetOptions = <Widget>[
//     const _HomeContent(),
//     const ProfileUi(),
//   ];
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_selectedIndex == 0 ? 'App Movies 🎥' : 'Profile'),
//         centerTitle: true,
//         backgroundColor: Colors.lightGreen[200],
//       ),
//       body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.green,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }
//
// class _HomeContent extends StatelessWidget {
//  const _HomeContent({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Genres',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const GenreListPage(),
//                       ),
//                     );
//                   },
//                   child: Text(
//                     'See More',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.normal,
//                       color: Colors.blue,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             height: 50, // Tinggi tetap untuk ListView horizontal
//             child: ListView.builder(
//               // Mengubah arah gulir menjadi horizontal
//               scrollDirection: Axis.horizontal,
//               itemCount: genres.length,
//               itemBuilder: (context, index) {
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 6.0),
//                   child: Chip(
//                     label: Text(genres[index]),
//                     backgroundColor: Colors.deepOrange.shade100,
//                   ),
//                 );
//               },
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.all(8.0),
//             color: Colors.grey[200],
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(
//                     "Now Playing",
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 Container(
//                   height: 300,
//                   child: ListView.builder(
//                     itemCount: nowPlayingItems.length,
//                     scrollDirection: Axis.horizontal,
//                     shrinkWrap: true,
//                     itemBuilder: (context, index) {
//                       return Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                             height: 220,
//                             width: 150,
//                             margin: const EdgeInsets.all(8.0),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               image: DecorationImage(
//                                 image: NetworkImage(
//                                   nowPlayingItems[index %
//                                       nowPlayingItems.length]['imageurl']!,
//                                 ),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.fromLTRB(
//                               16.0,
//                               0,
//                               16.0,
//                               0,
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   nowPlayingItems[index %
//                                       nowPlayingItems.length]['title']!,
//                                 ),
//                                 Text(
//                                   nowPlayingItems[index %
//                                       nowPlayingItems.length]['genre']!,
//                                   style: TextStyle(
//                                     fontSize: 10,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             color: Colors.white12,
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                         "Watchlist",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const WatchlistPage(),
//                           ),
//                         );
//                       },
//                       child: Text(
//                         'See More',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.normal,
//                           color: Colors.blue,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 GridView.count(
//                   crossAxisCount: 3,
//                   crossAxisSpacing: 10,
//                   mainAxisSpacing: 10,
//                   physics: const NeverScrollableScrollPhysics(),
//                   shrinkWrap: true,
//                   children: List.generate(6, (index) {
//                     return Container(
//                       decoration: BoxDecoration(
//                         image: DecorationImage(
//                           image: NetworkImage(
//                             watchlistitems[index]['imageurl']!,
//                           ),
//                           fit: BoxFit.cover,
//                         ),
//                         borderRadius: BorderRadius.circular(15.0),
//                       ),
//                     );
//                   }),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             color: Colors.grey[200],
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Text(
//                         "Popular Movie",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => PopularMoviesPage(),
//                           ),
//                         );
//                       },
//                       child: Text(
//                         'See More',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.normal,
//                           color: Colors.blue,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 ListView.builder(
//                   itemCount: 4,
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemBuilder: (context, index) {
//                     final item = popularMovies[index];
//                     return Container(
//                       margin: const EdgeInsets.symmetric(
//                         vertical: 8,
//                         horizontal: 16,
//                       ),
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: Colors.blueGrey[200],
//                         borderRadius: BorderRadius.circular(10),
//                         boxShadow: const [
//                           BoxShadow(
//                             color: Colors.black12,
//                             blurRadius: 5,
//                             offset: Offset(0, 3),
//                           ),
//                         ],
//                       ),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(8),
//                             child: Image.network(
//                               item.posterUrl,
//                               width: 80,
//                               height: 120,
//                               fit: BoxFit.cover,
//                               errorBuilder: (context, error, stackTrace) =>
//                                   Container(
//                                     width: 80,
//                                     height: 120,
//                                     color: Colors.grey[200],
//                                     child: const Icon(
//                                       Icons.movie,
//                                       color: Colors.blue,
//                                       size: 40,
//                                     ),
//                                   ),
//                             ),
//                           ),
//
//                           const SizedBox(width: 16),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   item.title,
//                                   style: const TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//
//                                 const SizedBox(height: 7),
//                                 Text(
//                                   item.genres.join(', '),
//                                   style: TextStyle(
//                                     fontSize: 15,
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//
//                                 const SizedBox(height: 8),
//                                 Text(
//                                   item.duration,
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     color: Colors.grey[900],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
