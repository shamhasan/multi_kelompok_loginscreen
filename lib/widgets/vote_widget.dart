import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:multi_kelompok/providers/vote_provider.dart';

class VoteWidget extends StatefulWidget {
  final int movieId;

  const VoteWidget({super.key, required this.movieId});

  @override
  State<VoteWidget> createState() => _VoteWidgetState();
}

class _VoteWidgetState extends State<VoteWidget> {

  @override
  void initState() {
    super.initState();
    // Ambil data vote untuk film ini saat widget pertama kali dibuat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<VoteProvider>(context, listen: false).fetchVotes(widget.movieId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VoteProvider>(
      builder: (context, voteProvider, child) {
        // Ambil data dari provider
        final totalLikes = voteProvider.likes[widget.movieId] ?? 0;
        final totalDislikes = voteProvider.dislikes[widget.movieId] ?? 0;
        final userVote = voteProvider.userVotes[widget.movieId]; // bisa true, false, atau null

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Tombol Suka (Like)
            _buildVoteButton(
              context: context,
              count: totalLikes,
              icon: userVote == true ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
              color: userVote == true ? Colors.green : Colors.grey,
              onPressed: () => voteProvider.vote(widget.movieId, true),
            ),
            
            // Tombol Tidak Suka (Dislike)
            _buildVoteButton(
              context: context,
              count: totalDislikes,
              icon: userVote == false ? Icons.thumb_down : Icons.thumb_down_alt_outlined,
              color: userVote == false ? Colors.red : Colors.grey,
              onPressed: () => voteProvider.vote(widget.movieId, false),
            ),
          ],
        );
      },
    );
  }

  // Widget helper untuk membuat tombol vote
  Widget _buildVoteButton({
    required BuildContext context,
    required int count,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 8),
            Text(
              count.toString(),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
