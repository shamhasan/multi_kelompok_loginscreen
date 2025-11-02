import 'package:flutter/material.dart';
import 'package:multi_kelompok/admin/add_movie_screen.dart';
import 'package:multi_kelompok/data/movie.dart';

class MovieAdminScreen extends StatelessWidget {
  const MovieAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          itemCount: allMovies.length,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blueGrey[200],
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        allMovies[index]["posterUrl"]!,
                        height: 200,
                        width: 130,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            allMovies[index]["title"]!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            allMovies[index]['genres'].join(', '),
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            allMovies[index]["duration"]!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[900],
                            ),
                          ),
                          Text(
                            "⭐" + allMovies[index]["rating"]!.toString(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 100,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  FloatingActionButton(
                                    onPressed: () {},
                                    child: Icon(Icons.delete),
                                    mini: true,
                                    backgroundColor: Colors.redAccent[200],
                                  ),
                                  const SizedBox(width: 8),
                                  FloatingActionButton(
                                    onPressed: () {},
                                    child: Icon(Icons.edit),
                                    mini: true,
                                    backgroundColor: Colors.green[200],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        Container(
          alignment: Alignment.bottomRight,
          margin: const EdgeInsets.all(16),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddMovieScreen()),
              );
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
