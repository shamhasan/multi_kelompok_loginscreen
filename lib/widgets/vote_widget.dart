import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:multi_kelompok/providers/vote_provider.dart';

class VoteWidget extends StatelessWidget {
  final int movieId; // Diubah dari String ke int

  const VoteWidget({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    // Fetch votes when the widget is built
    Provider.of<VoteProvider>(context, listen: false).fetchVotes(movieId);

    return Consumer<VoteProvider>(
      builder: (context, voteProvider, child) {
        final likes = voteProvider.likes[movieId] ?? 0;
        final dislikes = voteProvider.dislikes[movieId] ?? 0;
        final userVote = voteProvider.userVotes[movieId];

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    userVote == true ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
                    color: userVote == true ? Colors.green : Colors.grey,
                  ),
                  onPressed: () {
                    voteProvider.vote(movieId, true);
                  },
                ),
                Text('$likes'),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    userVote == false ? Icons.thumb_down : Icons.thumb_down_alt_outlined,
                    color: userVote == false ? Colors.red : Colors.grey,
                  ),
                  onPressed: () {
                    voteProvider.vote(movieId, false);
                  },
                ),
                Text('$dislikes'),
              ],
            ),
          ],
        );
      },
    );
  }
}
