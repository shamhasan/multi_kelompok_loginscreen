import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:multi_kelompok/models/review.dart';
import 'package:multi_kelompok/providers/review_provider.dart';

class AddReviewForm extends StatefulWidget {
  final String movieId;

  const AddReviewForm({super.key, required this.movieId});

  @override
  State<AddReviewForm> createState() => _AddReviewFormState();
}

class _AddReviewFormState extends State<AddReviewForm> {
  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();
  double _rating = 1.0; // Nilai awal untuk rating

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitReview() {
    // Validasi form sebelum submit
    if (_formKey.currentState!.validate()) {
      // Membuat objek Review baru dari input pengguna
      final newReview = Review(
        id: DateTime.now().toString(), // ID unik sementara, ganti dengan dari database
        userId: 'user123', // Ganti dengan ID pengguna yang login
        movieId: widget.movieId,
        rating: _rating,
        comment: _commentController.text,
      );

      // Memanggil method addReview dari provider
      Provider.of<ReviewProvider>(context, listen: false).addReview(newReview);

      // Reset form setelah submit
      _commentController.clear();
      setState(() {
        _rating = 1.0;
      });

      // Tampilkan notifikasi
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Review Anda telah ditambahkan!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Beri Rating ( $_rating / 10.0 )', style: const TextStyle(fontWeight: FontWeight.bold)),
          Slider(
            value: _rating,
            min: 1.0,
            max: 10.0,
            divisions: 9,
            label: _rating.toString(),
            activeColor: Colors.amber,
            onChanged: (value) {
              setState(() {
                _rating = value;
              });
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _commentController,
            decoration: const InputDecoration(
              labelText: 'Tulis komentar Anda',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Komentar tidak boleh kosong.';
              }
              return null;
            },
            maxLines: 4,
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submitReview,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Kirim Review', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
