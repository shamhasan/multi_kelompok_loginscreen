import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: Watchlist()));
}

class Watchlist extends StatelessWidget {
  const Watchlist ({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: WatchlistPage(),
    );
  }
}

class WatchlistPage extends StatelessWidget {
  const WatchlistPage({super.key});

  final List<Map<String, String>> watchlistitems =const [
    {
      'title':'Breaking Bad',
      'duration':'5 Season',
      'genre':'Genre: Action',
      'imageurl':'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSfQnh9Q8lrQ1hNKN47ECCAtGDR-GNclcr57g&s'
    },
    {
      'title': 'Arcane',
      'duration':'2 Season',
      'genre':'Genre: Action',
      'imageurl':'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTMPqCv2EodaysWtgTw1XFckTFTZ_WjiN4z0emeh_KiLXmM6yaN0s8TIZAzM0LqBTbIOENae5mOEnop2re9FRzIl53hfvh2hBvI3TZfU0MB'
    },
    {
      'title':'The Last of Us',
      'duration':'6 Season',
      'genre':'Genre: Action',
      'imageurl':'https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcT-0IQBKt5Rp7z_z6U5sWMyxHtFqDdBPIFzHGYoQOoO1mJM7Flvap3y_fXcnxT6m1zwQ5PCvFBkqXucOc_bNwDErSbNaaogjiQXOkGahBVu'
    },
    {
      'title':'Stranger Thing',
      'duration':'6 Season',
      'genre':'Genre: Horror',
      'imageurl':'https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcSuQHP-yhfyQhH-YWnEDhtRqPZ6rQztuOvbdCnuKkpJLYJ762XsqDyVC7v3qIIBDazBe6ahyp9RBqaYyaOhWjtcj6GriHllfaoKHukdkH7s'
    },
    {
      'title':'Girl from Nowhere',
      'duration':'2 Season',
      'genre':'Genre: Action',
      'imageurl':'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRlyLkyQDi8X9EUr6JkZIbVP73Lqz5ALwELIrUJdr6emfUmzS44n_zVRo9XqPYKFCLlnRvxlpIbJ94HbAkK6nBUOJAN1uYKksf7Guv3I7VACw'
    },
    {
      'title':'The Gifted',
      'duration':'2 Season',
      'genre':'Genre: Action',
      'imageurl':'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSFDG1z755aH0D7LKDJvHwgdCNxf2yZcEUhrCXc59KWJvj6hBq'
    }
  ];

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



