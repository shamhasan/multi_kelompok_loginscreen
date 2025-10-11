import 'package:flutter/material.dart';
import 'package:multi_kelompok/data/movie.dart';

class WatchlistPage extends StatelessWidget {
  const WatchlistPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Watchlist Movie")),
      body: ListView.builder(
        itemCount: watchlistitems.length,
        itemBuilder: (context, index) {
          final item = watchlistitems[index];
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8,horizontal: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: Offset(0,3)
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item ['imageurl']!,
                    width: 80,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(width: 16),
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title']!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 7),
                        Text(
                          item['genre']!,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.bold
                          ),
                        ),

                        const SizedBox(height: 8),
                        Text(
                          item['duration']!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[900],
                          ),
                        ),
                      ],
                    ),
                ),
              ],
            )
          );
        },
      ),
    );
  }
}



