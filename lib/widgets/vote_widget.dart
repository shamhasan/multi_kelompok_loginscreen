import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:multi_kelompok/providers/vote_provider.dart';

class VoteWidget extends StatefulWidget {
  final int movieId;
  // 1. Menambahkan callback untuk memberi sinyal setelah vote
  final VoidCallback onVoted;

  const VoteWidget({super.key, required this.movieId, required this.onVoted});

  @override
  State<VoteWidget> createState() => _VoteWidgetState();
}

class _VoteWidgetState extends State<VoteWidget> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<VoteProvider>(context, listen: false).fetchUserVote(widget.movieId);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Gunakan "context.watch" agar widget ini rebuild saat state vote pengguna berubah
    final voteProvider = context.watch<VoteProvider>();
    final userVote = voteProvider.userVotes[widget.movieId];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Tombol Like
        IconButton(
          icon: Icon(
            userVote == true ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
            color: userVote == true ? Colors.green : Colors.grey,
            size: 32,
          ),
          // 2. Mengubah onPressed menjadi async dan memanggil callback
          onPressed: () async {
            await voteProvider.vote(widget.movieId);
            widget.onVoted(); // Memberi sinyal ke parent untuk refresh
          },
        ),
        
        // Tombol Dislike
        IconButton(
          icon: Icon(
            userVote == false ? Icons.thumb_down : Icons.thumb_down_alt_outlined,
            color: userVote == false ? Colors.red : Colors.grey,
            size: 32,
          ),
          onPressed: () async {
            await voteProvider.dislike(widget.movieId);
            widget.onVoted(); // Memberi sinyal ke parent untuk refresh
          },
        ),
      ],
    );
  }
}
