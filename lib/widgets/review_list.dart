import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:multi_kelompok/providers/review_provider.dart';

class ReviewList extends StatelessWidget {
  final String movieId;

  const ReviewList({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    // Mengambil data dari provider
    final reviewProvider = Provider.of<ReviewProvider>(context);
    final reviews = reviewProvider.getReviewsForMovie(movieId);

    // Karena widget ini akan berada di dalam SingleChildScrollView, 
    // kita gunakan shrinkWrap dan NeverScrollableScrollPhysics
    return reviews.isEmpty
        ? const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Center(
              child: Text(
                'Jadilah yang pertama memberikan review!',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
          )
        : ListView.builder(
            shrinkWrap: true, // Membuat ListView mengambil ruang sesuai isinya
            physics: const NeverScrollableScrollPhysics(), // Menonaktifkan scroll internal
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];
              return Card(
                elevation: 1,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'User: ${review.userId}', // Ganti dengan username asli nanti
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 20),
                              const SizedBox(width: 4),
                              Text(
                                review.rating.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(review.comment),
                    ],
                  ),
                ),
              );
            },
          );
  }
}
