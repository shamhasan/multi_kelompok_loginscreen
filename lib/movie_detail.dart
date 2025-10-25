import 'package:flutter/material.dart';
import 'watchlist_service.dart';

class MovieDetailPage extends StatefulWidget {
  final int movieId;
  final String title;
  final String overview;
  final String imageUrl;

  const MovieDetailPage({
    super.key,
    required this.movieId,
    required this.title,
    required this.overview,
    required this.imageUrl,
  });

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  final _service = WatchlistService();
  bool _isInWatchlist = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkWatchlistStatus();
  }

  Future<void> _checkWatchlistStatus() async {
    final status = await _service.isInWatchlist(widget.movieId);
    if(mounted) {
      setState(() {
        _isInWatchlist = status;
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleWatchlist() async {
    setState(() => _isLoading = true);
    try {
      if (_isInWatchlist) {
        // Hapus (Delete)
        final watchlistId = await _service.getWatchlistItemId(widget.movieId);
        if (watchlistId != null) {
          await _service.removeFromWatchlist(watchlistId);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Removed from Watchlist ➖')),
          );
        }
      } else {
        // Tambah (Create)
        await _service.addToWatchlist(widget.movieId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Added to Watchlist ✅')),
        );
      }
      await _checkWatchlistStatus(); // Muat ulang status
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
      if(mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  widget.imageUrl,
                  width: 200,
                  height: 300,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, size: 200),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(widget.overview, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 30),

            Row(
              children: [
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton.icon(
                    onPressed: _toggleWatchlist,
                    icon: Icon(
                      _isInWatchlist
                          ? Icons.bookmark_remove_outlined // Delete
                          : Icons.bookmark_add_outlined, // Create
                    ),
                    label: Text(
                      _isInWatchlist
                          ? "Remove from Watchlist"
                          : "Add to Watchlist",
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      _isInWatchlist ? Colors.red : Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}