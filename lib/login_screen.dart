import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MaterialApp(home: LoginScreen()));
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isDesktop = screenWidth > 960; // Deteksi jika perangkat adalah Desktop

    return Scaffold(
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            bool isPortrait = orientation == Orientation.portrait;

            return Center(
              child: LayoutBuilder(
                builder: (context, builder) {
                  return Container(
                    width: isDesktop
                        ? 960
                        : (isPortrait ? screenWidth * 0.9 : screenWidth * 0.65),
                    padding: EdgeInsets.all(16),
                    height: screenHeight,
                    child: isDesktop
                        ? _buildDesktop(screenWidth)
                        : (isPortrait
                              ? _buildPortrait(screenWidth)
                              : _buildLandscape(screenWidth)),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  // Widget untuk tampilan lanskap
  Widget _buildLandscape(double screenWidth) {
    return Container(
      // color: Colors.blueGrey[50],
      child: Row(
        children: [
          // welcome text
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.only(right: screenWidth * 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  Text(
                    "Masuk Di sini",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Selamat Datang\nKembali!",
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),

          // form login
          Expanded(
            flex: 3,
            child: Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // email
                      TextField(
                        decoration: InputDecoration(
                          hintText: "Email",
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // password
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Kata sandi",
                          suffixIcon: const Icon(Icons.visibility_off),
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),

                      // lupa sandi
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Lupa Kata Sandi?",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),

                      // tombol masuk
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {},
                          child: const Text("Masuk"),
                        ),
                      ),
                      const SizedBox(height: 5),

                      // daftar
                      TextButton(
                        onPressed: () {},
                        child: const Text("Daftar"),
                      ),

                      const SizedBox(height: 5),
                      const Text("Lanjutkan dengan"),

                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.g_mobiledata,
                                size: 28, color: Colors.red),
                          ),
                          SizedBox(width: 16),
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.facebook,
                                size: 28, color: Colors.blue),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  // Widget untuk tampilan potret
  Widget _buildPortrait(double screenWidth) {
    return Container(
      color: Colors.teal[50],
      child: Center(
        child: Text(
          "Portrait UI",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildDesktop(double screenWidth) {
    return Container(
      color: Colors.amber[50],
      child: Center(
        child: Text(
          "Desktop UI",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class Movie {
  final String title;
  final String posterUrl;
  final double rating;
  final String overview;
  final List<String> genres;
  final int year;
  final String duration;
  final String ageRating;

  Movie({
    required this.title,
    required this.posterUrl,
    required this.rating,
    required this.overview,
    required this.genres,
    required this.year,
    required this.duration,
    required this.ageRating,
  });
}

final List<Movie> popularMovies = [
  Movie(
    title: 'Dune: Part Two',
    posterUrl: 'https://m.media-amazon.com/images/M/MV5BN2QyZGU4ZDctOWMzMy00NTc5LThlOGQtMzg4NTI3ZDNlM2MyXkEyXkFqcGdeQXVyMTM112GNyCoordinate@._V1_QL75_UX380_CR0,0,380,562_.jpg',
    rating: 8.6,
    overview: 'Paul Atreides unites with Chani and the Fremen while on a warpath of revenge against the conspirators who destroyed his family. Faced with a choice between the love of his life and the fate of the universe, he endeavors to prevent a terrible future that only he can foresee.',
    genres: ['Sci-Fi', 'Adventure', 'Action'],
    year: 2024,
    duration: '2h 46m',
    ageRating: 'PG-13',
  ),
  Movie(
    title: 'Furiosa: A Mad Max Saga',
    posterUrl: 'https://m.media-amazon.com/images/M/MV5BMmU1NjY3MTYtM2M5MS00MDFlLTg2MWYtNjI2NmMwZTM4OLI@._V1_QL75_UX380_CR0,0,380,562_.jpg',
    rating: 7.8,
    overview: 'The origin story of renegade warrior Furiosa before she teamed up with Mad Max. Snatched from the Green Place of Many Mothers, young Furiosa is captured by a great Biker Horde led by the Warlord Dementus. As two tyrants war for dominance, Furiosa must survive many trials while piecing together the means to find her way home.',
    genres: ['Action', 'Adventure', 'Sci-Fi'],
    year: 2024,
    duration: '2h 28m',
    ageRating: 'R',
  ),
  Movie(
    title: 'Inside Out 2',
    posterUrl: 'https://m.media-amazon.com/images/M/MV5BYWJkY2Q4NmYtOGRlMi00YTg5LWE2ZmQtY2U5NzNlZGMyZjY3XkEyXkFqcGdeQXVyMTY3ODkyNDkz._V1_QL75_UX380_CR0,0,380,562_.jpg',
    rating: 7.9,
    overview: 'Follows Riley in her teenage years, where she encounters the complexities of high school and friendships. The existing emotions—Joy, Sadness, Anger, Fear, and Disgust—are suddenly thrown into chaos with the arrival of new, more complex emotions like Anxiety, Envy, and Embarrassment.',
    genres: ['Animation', 'Adventure', 'Comedy'],
    year: 2024,
    duration: '1h 36m',
    ageRating: 'PG',
  ),
  Movie(
    title: 'Wednesday',
    posterUrl: 'https://m.media-amazon.com/images/M/MV5BMjllNDU5YjYtOGM2Zi00YTMxLWI2MWItMjM4MDA5ZmI0ODc0XkEyXkFqcGdeQXVyMTU5OTA4NTIz._V1_QL75_UX380_CR0,0,380,562_.jpg',
    rating: 8.1,
    overview: 'A sleuthing, supernaturally infused mystery charting Wednesday Addams\' years as a student at Nevermore Academy, where she attempts to master her emerging psychic ability and solve a monstrous killing spree.',
    genres: ['Comedy', 'Crime', 'Fantasy'],
    year: 2022,
    duration: '8 Episodes',
    ageRating: 'TV-14',
  ),
];


class PopularMoviesPage extends StatefulWidget {
  const PopularMoviesPage({super.key});

  @override
  State<PopularMoviesPage> createState() => _PopularMoviesPageState();
}

class _PopularMoviesPageState extends State<PopularMoviesPage> {
  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Film Populer'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: popularMovies.length,
        itemBuilder: (context, index) {
          final movie = popularMovies[index];
          return _buildMovieListItem(context, movie, index);
        },
      ),
    );
  }

  Widget _buildMovieListItem(BuildContext context, Movie movie, int index) {
    final bool isExpanded = _expandedIndex == index;
    final screenWidth = MediaQuery.of(context).size.width;

    const double maxPosterWidth = 200.0;
    final double posterWidth = min(screenWidth * 0.3, maxPosterWidth);
    final double posterHeight = posterWidth * 1.5;
    final double titleSize = screenWidth > 720 ? 18 : 16;
    final double detailSize = screenWidth > 720 ? 14 : 12;
    final double chipTextSize = screenWidth > 720 ? 12 : 11;


    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            setState(() {
              _expandedIndex = isExpanded ? null : index;
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: posterWidth,
                      height: posterHeight,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          movie.posterUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) =>
                          progress == null ? child : const Center(child: CircularProgressIndicator()),
                          errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.movie, color: Colors.grey, size: 40),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie.title,
                            style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(movie.year.toString(), style: TextStyle(color: Colors.grey[600], fontSize: detailSize)),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                                child: Icon(Icons.circle, size: 3, color: Colors.grey[500]),
                              ),
                              Text(movie.duration, style: TextStyle(color: Colors.grey[600], fontSize: detailSize)),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                                child: Icon(Icons.circle, size: 3, color: Colors.grey[500]),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade500),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: Text(movie.ageRating, style: TextStyle(color: Colors.grey[700], fontSize: detailSize - 1, fontWeight: FontWeight.w500)),
                              )
                            ],
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 6.0,
                            runSpacing: 4.0,
                            children: movie.genres.map((genre) {
                              return Chip(
                                label: Text(genre),
                                backgroundColor: Colors.green.shade100,
                                labelStyle: TextStyle(color: Colors.green.shade900, fontSize: chipTextSize),
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: detailSize + 4),
                              const SizedBox(width: 4),
                              Text(
                                movie.rating > 0 ? movie.rating.toString() : "N/A",
                                style: TextStyle(fontSize: detailSize, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: Container(
                    child: isExpanded
                        ? Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Text(movie.overview, style: TextStyle(fontSize: detailSize, color: Colors.grey[700])),
                    )
                        : const SizedBox.shrink(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}