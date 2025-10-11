import 'package:multi_kelompok/popular_movie_ui.dart';

final List<Map<String, String>> nowPlayingItems = const [
    {
      'title': 'Breaking Bad',
      'duration': '5 Season',
      'genre': 'Genre: Action',
      'imageurl':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSfQnh9Q8lrQ1hNKN47ECCAtGDR-GNclcr57g&s',
    },
    {
      'title': 'Arcane',
      'duration': '2 Season',
      'genre': 'Genre: Action',
      'imageurl':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTMPqCv2EodaysWtgTw1XFckTFTZ_WjiN4z0emeh_KiLXmM6yaN0s8TIZAzM0LqBTbIOENae5mOEnop2re9FRzIl53hfvh2hBvI3TZfU0MB',
    },
    {
      'title': 'The Last of Us',
      'duration': '6 Season',
      'genre': 'Genre: Action',
      'imageurl':
          'https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcT-0IQBKt5Rp7z_z6U5sWMyxHtFqDdBPIFzHGYoQOoO1mJM7Flvap3y_fXcnxT6m1zwQ5PCvFBkqXucOc_bNwDErSbNaaogjiQXOkGahBVu',
    },
    {
      'title': 'Stranger Thing',
      'duration': '6 Season',
      'genre': 'Genre: Horror',
      'imageurl':
          'https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcSuQHP-yhfyQhH-YWnEDhtRqPZ6rQztuOvbdCnuKkpJLYJ762XsqDyVC7v3qIIBDazBe6ahyp9RBqaYyaOhWjtcj6GriHllfaoKHukdkH7s',
    },
    {
      'title': 'Girl from Nowhere',
      'duration': '2 Season',
      'genre': 'Genre: Action',
      'imageurl':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRlyLkyQDi8X9EUr6JkZIbVP73Lqz5ALwELIrUJdr6emfUmzS44n_zVRo9XqPYKFCLlnRvxlpIbJ94HbAkK6nBUOJAN1uYKksf7Guv3I7VACw',
    },
    {
      'title': 'The Gifted',
      'duration': '2 Season',
      'genre': 'Genre: Action',
      'imageurl':
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSFDG1z755aH0D7LKDJvHwgdCNxf2yZcEUhrCXc59KWJvj6hBq',
    },
  ];

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
    title: 'Wednesday',
    posterUrl: 'https://m.media-amazon.com/images/M/MV5BMjllNDU5YjYtOGM2Zi00YTMxLWI2MWItMjM4MDA5ZmI0ODc0XkEyXkFqcGdeQXVyMTU5OTA4NTIz._V1_QL75_UX380_CR0,0,380,562_.jpg',
    rating: 8.1,
    overview: 'A sleuthing, supernaturally infused mystery charting Wednesday Addams\' years as a student at Nevermore Academy, where she attempts to master her emerging psychic ability and solve a monstrous killing spree.',
    genres: ['Comedy', 'Crime', 'Fantasy'],
    year: 2022,
    duration: '8 Episodes',
    ageRating: 'TV-14',
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
];

final List<String> genres = const [
    "Action",
    "Comedy",
    "Horror",
    "Sci-Fi",
    "Thriller",
    "Drama",
    "Romance",
    "Fantasy",
    "Documentary",
  ];
