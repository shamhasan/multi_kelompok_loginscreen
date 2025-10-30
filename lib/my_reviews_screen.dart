import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:multi_kelompok/providers/review_provider.dart';

class MyReviewsScreen extends StatelessWidget {
  const MyReviewsScreen({super.key});

  // Ganti dengan ID pengguna yang sedang login sesungguhnya
  final String _currentUserId = 'user123';

  @override
  Widget build(BuildContext context) {
    // Mengambil data review dari provider
    final reviewProvider = Provider.of<ReviewProvider>(context);
    final userReviews = reviewProvider.getReviewsByUser(_currentUserId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Reviews'),
        backgroundColor: Colors.green,
      ),
      body: userReviews.isEmpty
          ? const Center(
              child: Text(
                'Anda belum pernah memberikan review.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: userReviews.length,
              itemBuilder: (context, index) {
                final review = userReviews[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(
                      'Review untuk Film ID: ${review.movieId}', // Nantinya bisa diganti judul film
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        '\"${review.comment}\"',
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
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
                    // Tambahkan tombol edit/delete di sini jika diperlukan
                  ),
                );
              },
            ),
    );
  }
}
