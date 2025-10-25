import 'package:flutter/material.dart';
import 'watchlist_service.dart';
import 'movie_detail.dart';

class WatchlistPage extends StatefulWidget {
  const WatchlistPage({super.key});

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
  final _service = WatchlistService();
  late Future<List<Map<String, dynamic>>> _watchlistFuture;

  @override
  void initState() {
    super.initState();
    _watchlistFuture = _service.getWatchlist();
  }

  Future<void> _refresh() async {
    setState(() {
      _watchlistFuture = _service.getWatchlist();
    });
  }

  // Fungsi untuk mengubah status (Update)
  Future<void> _toggleStatus(int watchlistId, String currentStatus) async {
    final newStatus = currentStatus == 'watched' ? 'unwatched' : 'watched';
    try {
      await _service.updateStatus(watchlistId, newStatus);
      _refresh();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Status diubah menjadi $newStatus')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal update status: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Watchlist")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _watchlistFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Tampilkan error (termasuk jika user belum login, dicek di service)
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(child: Text("Watchlist kosong"));
          }

          final items = snapshot.data!;
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final watch = items[index];
                final movie = watch['movies']; // Relasi JOIN dari Supabase

                return ListTile(
                  leading: movie != null && movie['poster_url'] != null
                      ? Image.network(movie['poster_url'], width: 60, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported))
                      : const Icon(Icons.image_not_supported),

                  title: Text(movie != null ? movie['title'] : "Movie Deleted"),
                  subtitle: Text('Status: ${watch['status']}'),

                  // Tombol Update Status dan Delete
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Tombol Update Status (Inovasi)
                      IconButton(
                        icon: Icon(
                          watch['status'] == 'watched'
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: watch['status'] == 'watched' ? Colors.green : Colors.grey,
                        ),
                        onPressed: () => _toggleStatus(watch['id'], watch['status']),
                        tooltip: watch['status'] == 'watched' ? 'Mark as Unwatched' : 'Mark as Watched',
                      ),

                      // Tombol Delete (Remove from Watchlist)
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await _service.removeFromWatchlist(watch['id']);
                          _refresh();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Film dihapus dari watchlist 🗑️')),
                          );
                        },
                        tooltip: 'Remove from Watchlist',
                      ),
                    ],
                  ),

                  // Navigasi ke Detail Film (Detail - Aturan #4)
                  onTap: () {
                    if (movie != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetailPage(
                            movieId: movie['id'],
                            title: movie['title'],
                            overview: movie['overview'],
                            imageUrl: movie['poster_url'] ?? '',
                          ),
                        ),
                      ).then((_) => _refresh()); // Muat ulang saat kembali dari Detail
                    }
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:multi_kelompok/data/movie.dart';
//
// class WatchlistPage extends StatelessWidget {
//   const WatchlistPage({super.key});
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           title: const Text("Watchlist Movie")),
//       body: ListView.builder(
//         itemCount: watchlistitems.length,
//         itemBuilder: (context, index) {
//           final item = watchlistitems[index];
//           return Container(
//             margin: const EdgeInsets.symmetric(vertical: 8,horizontal: 16),
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.grey[300],
//               borderRadius: BorderRadius.circular(10),
//               boxShadow: const [
//                 BoxShadow(
//                   color: Colors.black12,
//                   blurRadius: 5,
//                   offset: Offset(0,3)
//                 ),
//               ],
//             ),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(8),
//                   child: Image.network(
//                     item ['imageurl']!,
//                     width: 80,
//                     height: 120,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//
//                 const SizedBox(width: 16),
//                 Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           item['title']!,
//                           style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//
//                         const SizedBox(height: 7),
//                         Text(
//                           item['genre']!,
//                           style: TextStyle(
//                             fontSize: 15,
//                             color: Colors.black,
//                             fontWeight: FontWeight.bold
//                           ),
//                         ),
//
//                         const SizedBox(height: 8),
//                         Text(
//                           item['duration']!,
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: Colors.grey[900],
//                           ),
//                         ),
//                       ],
//                     ),
//                 ),
//               ],
//             )
//           );
//         },
//       ),
//     );
//   }
// }
//
//
//
