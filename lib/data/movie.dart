import 'package:multi_kelompok/models/movie_model.dart';
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

final List<Map<String, String>> watchlistitems = const [
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

final List<Movie> popularMovies = [
  Movie(
    title: 'Dune: Part Two',
    posterUrl: 'assets/images/poster_duneparttwo.png',
    rating: 8.6,
    overview:
        'Paul Atreides unites with Chani and the Fremen while on a warpath of revenge against the conspirators who destroyed his family. Faced with a choice between the love of his life and the fate of the universe, he endeavors to prevent a terrible future that only he can foresee.',
    genres: ['Sci-Fi', 'Adventure', 'Action'],
    year: 2024,
    duration: '2h 46m',
    ageRating: 'PG-13',
    isNowPlaying: true,
    voteCount: 9,
  ),
  Movie(
    title: 'Wednesday',
    posterUrl: 'assets/images/poster_wednesday.png',
    rating: 8.1,
    overview:
        'A sleuthing, supernaturally infused mystery charting Wednesday Addams\' years as a student at Nevermore Academy, where she attempts to master her emerging psychic ability and solve a monstrous killing spree.',
    genres: ['Comedy', 'Crime', 'Fantasy'],
    year: 2022,
    duration: '8 Episodes',
    ageRating: 'TV-14',
    isNowPlaying: true,
    voteCount: 9,
  ),
  Movie(
    title: 'Furiosa: A Mad Max Saga',
    posterUrl: 'assets/images/poster_furiosa.png',
    rating: 7.8,
    overview:
        'The origin story of renegade warrior Furiosa before she teamed up with Mad Max. Snatched from the Green Place of Many Mothers, young Furiosa is captured by a great Biker Horde led by the Warlord Dementus. As two tyrants war for dominance, Furiosa must survive many trials while piecing together the means to find her way home.',
    genres: ['Action', 'Adventure', 'Sci-Fi'],
    year: 2024,
    duration: '2h 28m',
    ageRating: 'R',
    isNowPlaying: true,
    voteCount: 9,
  ),
  Movie(
    title: 'Inside Out 2',
    posterUrl: 'assets/images/poster_insideout.png',
    rating: 7.9,
    overview:
        'Follows Riley in her teenage years, where she encounters the complexities of high school and friendships. The existing emotions—Joy, Sadness, Anger, Fear, and Disgust—are suddenly thrown into chaos with the arrival of new, more complex emotions like Anxiety, Envy, and Embarrassment.',
    genres: ['Animation', 'Adventure', 'Comedy'],
    year: 2024,
    duration: '1h 36m',
    ageRating: 'PG',
    isNowPlaying: true,
    voteCount: 9,
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

  final List<Map> allMovies = [
    {
      "title": "Breaking Bad",
      "posterUrl":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSfQnh9Q8lrQ1hNKN47ECCAtGDR-GNclcr57g&s",
      "rating": 9.5,
      "overview":
          "A high school chemistry teacher diagnosed with inoperable lung cancer turns to manufacturing and selling methamphetamine in order to secure his family's future.",
      "genres": ["Crime", "Drama", "Thriller"],
      "year": 2008,
      "duration": "5 Season",
      "ageRating": "TV-MA",
    },
    {
      "title": "Arcane",
      "posterUrl":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTMPqCv2EodaysWtgTw1XFckTFTZ_WjiN4z0emeh_KiLXmM6yaN0s8TIZAzM0LqBTbIOENae5mOEnop2re9FRzIl53hfvh2hBvI3TZfU0MB",
      "rating": 9.0,
      "overview":
          "Set in the utopian city of Piltover and the oppressed underground city of Zaun, the story follows the origins of two iconic League of Legends champions: sisters Vi and Jinx.",
      "genres": ["Animation", "Action", "Sci-Fi"],
      "year": 2021,
      "duration": "2 Season",
      "ageRating": "TV-14",
    },
    {
      "title": "The Last of Us",
      "posterUrl":
          "https://www.movieposters.com/cdn/shop/files/lastofus.136725.jpg?v=1747946961&width=1680",
      "rating": 8.7,
      "overview":
          "After a global pandemic destroys civilization, a hardened survivor takes charge of a 14-year-old girl who may be humanity's last hope.",
      "genres": ["Action", "Drama", "Horror"],
      "year": 2023,
      "duration": "1 Season",
      "ageRating": "TV-MA",
    },
    {
      "title": "Stranger Things",
      "posterUrl":
          "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcSuQHP-yhfyQhH-YWnEDhtRqPZ6rQztuOvbdCnuKkpJLYJ762XsqDyVC7v3qIIBDazBe6ahyp9RBqaYyaOhWjtcj6GriHllfaoKHukdkH7s",
      "rating": 8.7,
      "overview":
          "When a young boy vanishes, a small town uncovers a mystery involving secret experiments, terrifying supernatural forces and one strange little girl.",
      "genres": ["Horror", "Drama", "Sci-Fi"],
      "year": 2016,
      "duration": "4 Season",
      "ageRating": "TV-14",
    },
    {
      "title": "Girl from Nowhere",
      "posterUrl":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRlyLkyQDi8X9EUr6JkZIbVP73Lqz5ALwELIrUJdr6emfUmzS44n_zVRo9XqPYKFCLlnRvxlpIbJ94HbAkK6nBUOJAN1uYKksf7Guv3I7VACw",
      "rating": 7.6,
      "overview":
          "A mysterious, clever girl named Nanno transfers to different schools, exposing the lies and misdeeds of the students and faculty at every turn.",
      "genres": ["Mystery", "Thriller", "Drama"],
      "year": 2018,
      "duration": "2 Season",
      "ageRating": "TV-MA",
    },
    {
      "title": "The Gifted",
      "posterUrl":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSFDG1z755aH0D7LKDJvHwgdCNxf2yZcEUhrCXc59KWJvj6hBq",
      "rating": 7.5,
      "overview":
          "In a world where mutated humans are treated with distrust and fear, an institute for mutants battles to achieve peaceful co-existence with humanity.",
      "genres": ["Action", "Fantasy", "Sci-Fi"],
      "year": 2017,
      "duration": "2 Season",
      "ageRating": "TV-14",
    },
    {
      "title": "Dune: Part Two",
      "posterUrl":
          "https://www.movieposters.com/cdn/shop/files/dune-part-two_f8d4tx9o.jpg?v=1745867995&width=1680",
      "rating": 8.6,
      "overview":
          "Paul Atreides unites with Chani and the Fremen while on a warpath of revenge against the conspirators who destroyed his family. Faced with a choice between the love of his life and the fate of the universe, he endeavors to prevent a terrible future that only he can foresee.",
      "genres": ["Sci-Fi", "Adventure", "Action"],
      "year": 2024,
      "duration": "2h 46m",
      "ageRating": "PG-13",
    },
    {
      "title": "Wednesday",
      "posterUrl":
          "https://www.movieposters.com/cdn/shop/files/wednesday.tv.jpg?v=1689352362&width=1680",
      "rating": 8.1,
      "overview":
          "A sleuthing, supernaturally infused mystery charting Wednesday Addams' years as a student at Nevermore Academy, where she attempts to master her emerging psychic ability and solve a monstrous killing spree.",
      "genres": ["Comedy", "Crime", "Fantasy"],
      "year": 2022,
      "duration": "8 Episodes",
      "ageRating": "TV-14",
    },
    {
      "title": "Furiosa: A Mad Max Saga",
      "posterUrl":
          "https://www.movieposters.com/cdn/shop/files/furiosa-a-mad-max-saga_8mwswrhb-_1.jpg?v=1707785008&width=1680",
      "rating": 7.8,
      "overview":
          "The origin story of renegade warrior Furiosa before she teamed up with Mad Max. Snatched from the Green Place of Many Mothers, young Furiosa is captured by a great Biker Horde led by the Warlord Dementus. As two tyrants war for dominance, Furiosa must survive many trials while piecing together the means to find her way home.",
      "genres": ["Action", "Adventure", "Sci-Fi"],
      "year": 2024,
      "duration": "2h 28m",
      "ageRating": "R",
    },
    {
      "title": "Inside Out 2",
      "posterUrl":
          "https://www.movieposters.com/cdn/shop/files/inside_out_two_ver2.jpg?v=1711998871&width=1680",
      "rating": 7.9,
      "overview":
          "Follows Riley in her teenage years, where she encounters the complexities of high school and friendships. The existing emotions—Joy, Sadness, Anger, Fear, and Disgust—are suddenly thrown into chaos with the arrival of new, more complex emotions like Anxiety, Envy, and Embarrassment.",
      "genres": ["Animation", "Adventure", "Comedy"],
      "year": 2024,
      "duration": "1h 36m",
      "ageRating": "PG",
    },
  ];
