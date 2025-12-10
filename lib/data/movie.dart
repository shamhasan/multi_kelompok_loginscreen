import 'package:multi_kelompok/models/movie.dart';

// --- GENRE LIST (Digunakan sebagai referensi, mungkin tidak diperlukan jika data genre dari API) ---
final List<String> availableGenres = const [
  "Action",
  "Comedy",
  "Horror",
  "Sci-Fi",
  "Thriller",
  "Drama",
  "Romance",
  "Fantasy",
  "Documentary",
  "Crime",
  "Adventure",
  "Animation",
];

// --- DATA FILM DENGAN FORMAT YANG KONSISTEN (Movie Model) ---

// 1. Film yang sebelumnya berada di 'nowPlayingItems' diubah menjadi objek Movie
final List<Movie> nowPlayingMovies = [
  Movie(
    id: '11',
    title: 'Breaking Bad',
    imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSfQnh9Q8lrQ1hNKN47ECCAtGDR-GNclcr57g&s',
    rating: 9.5,
    overview: 'A high school chemistry teacher diagnosed with inoperable lung cancer turns to manufacturing and selling methamphetamine in order to secure his family\'s future.',
    genres: ['Crime', 'Drama', 'Thriller'],
    year: 2008,
    duration: '5 Seasons',
    ageRating: 'TV-MA',
  ),
  Movie(
    id: '12',
    title: 'Arcane',
    imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTMPqCv2EodaysWtgTw1XFckTFTZ_WtgTw1XFckTFTZ_WjiN4z0emeh_KiLXmM6yaN0s8TIZAzM0LqBTbIOENae5mOEnop2re9FRzIl53hfvh2hBvI3TZfU0MB',
    rating: 9.0,
    overview: 'Set in the utopian Piltover and the oppressed underground of Zaun, the story follows the origins of two iconic League of Legends champions.',
    genres: ['Animation', 'Action', 'Adventure'],
    year: 2021,
    duration: '1 Season',
    ageRating: 'TV-14',
  ),
  Movie(
    id: '13',
    title: 'The Last of Us',
    imageUrl: 'https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcT-0IQBKt5Rp7z_z6U5sWMyxHtFqDdBPIFzHGYoQOoO1mJM7Flvap3y_fXcnxT6m1zwQ5PCvFBkqXucOc_bNwDErSbNaaogjiQXOkGahBVu',
    rating: 8.8,
    overview: 'After a global pandemic destroys civilization, a hardened survivor takes charge of a 14-year-old girl who may be humanity\'s last hope.',
    genres: ['Action', 'Adventure', 'Drama'],
    year: 2023,
    duration: '1 Season',
    ageRating: 'TV-MA',
  ),
  Movie(
    id: '14',
    title: 'Stranger Things',
    imageUrl: 'https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcSuQHP-yhfyQhH-YWnEDhtRqPZ6rQztuOvbdCnuKkpJLYJ762XsqDyVC7v3qIIBDazBe6ahyp9RBqaYyaOhWjtcj6GriHllfaoKHukdkH7s',
    rating: 8.7,
    overview: 'When a young boy vanishes, a small town uncovers a mystery involving secret experiments, terrifying supernatural forces and one strange little girl.',
    genres: ['Drama', 'Fantasy', 'Horror'],
    year: 2016,
    duration: '4 Seasons',
    ageRating: 'TV-14',
  ),
  Movie(
    id: '15',
    title: 'Girl from Nowhere',
    imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRlyLkyQDi8X9EUr6JkZIbVP73Lqz5ALwELIrUJdr6emfUmzS44n_zVRo9XqPYKFCLlnRvxlpIbJ94HbAkK6nBUOJAN1uYKksf7Guv3I7VACw',
    rating: 7.6,
    overview: 'A mysterious, clever girl named Nanno transfers to different schools, exposing the lies and misdeeds of the students and faculty at every turn.',
    genres: ['Crime', 'Drama', 'Fantasy'],
    year: 2018,
    duration: '2 Seasons',
    ageRating: 'TV-MA',
  ),
  Movie(
    id: '16',
    title: 'The Gifted',
    imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSFDG1z755aH0D7LKDJvHwgdCNxf2yZcEUhrCXc59KWJvj6hBq',
    rating: 7.5,
    overview: 'In a world where mutated humans are treated with distrust and fear, an institute for mutants battles to achieve peaceful co-existence with humanity.',
    genres: ['Action', 'Drama', 'Fantasy'],
    year: 2017,
    duration: '2 Seasons',
    ageRating: 'TV-14',
  ),
];

// 2. Data 'watchlistitems' (Tetap, ID di atas 10 untuk menghindari duplikasi ID jika digabungkan)
final List<Movie> watchlistItems = [
  // Catatan: Breaking Bad, Arcane, The Last of Us, dll. sudah ada di nowPlayingMovies,
  // tetapi dibiarkan di sini untuk mempertahankan struktur dummy data Anda (dengan ID berbeda).
  // Di aplikasi nyata, Anda akan memiliki satu list utama.
  Movie(
    id: '5',
    title: 'Breaking Bad (Watchlist)',
    imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSfQnh9Q8lrQ1hNKN47ECCAtGDR-GNclcr57g&s',
    rating: 9.5,
    overview: 'A high school chemistry teacher diagnosed with inoperable lung cancer turns to manufacturing and selling methamphetamine in order to secure his family\'s future.',
    genres: ['Crime', 'Drama', 'Thriller'],
    year: 2008,
    duration: '5 Seasons',
    ageRating: 'TV-MA',
  ),
  // ... Movie lainnya (Arcane, The Last of Us, dst.)
  // (Menggunakan data asli dari input Anda)
  Movie(
    id: '6',
    title: 'Arcane (Watchlist)',
    imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTMPqCv2EodaysWtgTw1XFckTFTZ_WjiN4z0emeh_KiLXmM6yaN0s8TIZAzM0LqBTbIOENae5mOEnop2re9FRzIl53hfvh2hBvI3TZfU0MB',
    rating: 9.0,
    overview: 'Set in the utopian Piltover and the oppressed underground of Zaun, the story follows the origins of two iconic League of Legends champions-and the power that will tear them apart.',
    genres: ['Animation', 'Action', 'Adventure'],
    year: 2021,
    duration: '1 Season',
    ageRating: 'TV-14',
  ),
  Movie(
    id: '7',
    title: 'The Last of Us (Watchlist)',
    imageUrl: 'https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcT-0IQBKt5Rp7z_z6U5sWMyxHtFqDdBPIFzHGYoQOoO1mJM7Flvap3y_fXcnxT6m1zwQ5PCvFBkqXucOc_bNwDErSbNaaogjiQXOkGahBVu',
    rating: 8.8,
    overview: 'After a global pandemic destroys civilization, a hardened survivor takes charge of a 14-year-old girl who may be humanity\'s last hope.',
    genres: ['Action', 'Adventure', 'Drama'],
    year: 2023,
    duration: '1 Season',
    ageRating: 'TV-MA',
  ),
  Movie(
    id: '8',
    title: 'Stranger Things (Watchlist)',
    imageUrl: 'https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcSuQHP-yhfyQhH-YWnEDhtRqPZ6rQztuOvbdCnuKkpJLYJ762XsqDyVC7v3qIIBDazBe6ahyp9RBqaYyaOhWjtcj6GriHllfaoKHukdkH7s',
    rating: 8.7,
    overview: 'When a young boy vanishes, a small town uncovers a mystery involving secret experiments, terrifying supernatural forces and one strange little girl.',
    genres: ['Drama', 'Fantasy', 'Horror'],
    year: 2016,
    duration: '4 Seasons',
    ageRating: 'TV-14',
  ),
  Movie(
    id: '9',
    title: 'Girl from Nowhere (Watchlist)',
    imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRlyLkyQDi8X9EUr6JkZIbVP73Lqz5ALwELIrUJdr6emfUmzS44n_zVRo9XqPYKFCLlnRvxlpIbJ94HbAkK6nBUOJAN1uYKksf7Guv3I7VACw',
    rating: 7.6,
    overview: 'A mysterious, clever girl named Nanno transfers to different schools, exposing the lies and misdeeds of the students and faculty at every turn.',
    genres: ['Crime', 'Drama', 'Fantasy'],
    year: 2018,
    duration: '2 Seasons',
    ageRating: 'TV-MA',
  ),
  Movie(
    id: '10',
    title: 'The Gifted (Watchlist)',
    imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSFDG1z755aH0D7LKDJvHwgdCNxf2yZcEUhrCXc59KWJvj6hBq',
    rating: 7.5,
    overview: 'In a world where mutated humans are treated with distrust and fear, an institute for mutants battles to achieve peaceful co-existence with humanity.',
    genres: ['Action', 'Drama', 'Fantasy'],
    year: 2017,
    duration: '2 Seasons',
    ageRating: 'TV-14',
  ),
];

// 3. Data 'popularMovies' (Tetap menggunakan data asli)
final List<Movie> popularMovies = [
  Movie(
    id: '1',
    title: 'Dune: Part Two',
    imageUrl: 'assets/images/poster_duneparttwo.png',
    rating: 8.6,
    overview: 'Paul Atreides unites with Chani and the Fremen while on a warpath of revenge against the conspirators who destroyed his family. Faced with a choice between the love of his life and the fate of the universe, he endeavors to prevent a terrible future that only he can foresee.',
    genres: ['Sci-Fi', 'Adventure', 'Action'],
    year: 2024,
    duration: '2h 46m',
    ageRating: 'PG-13',
  ),
  Movie(
    id: '2',
    title: 'Wednesday',
    imageUrl: 'assets/images/poster_wednesday.png',
    rating: 8.1,
    overview: 'A sleuthing, supernaturally infused mystery charting Wednesday Addams\' years as a student at Nevermore Academy, where she attempts to master her emerging psychic ability and solve a monstrous killing spree.',
    genres: ['Comedy', 'Crime', 'Fantasy'],
    year: 2022,
    duration: '8 Episodes',
    ageRating: 'TV-14',
  ),
  Movie(
    id: '3',
    title: 'Furiosa: A Mad Max Saga',
    imageUrl: 'assets/images/poster_furiosa.png',
    rating: 7.8,
    overview: 'The origin story of renegade warrior Furiosa before she teamed up with Mad Max. Snatched from the Green Place of Many Mothers, young Furiosa is captured by a great Biker Horde led by the Warlord Dementus. As two tyrants war for dominance, Furiosa must survive many trials while piecing together the means to find her way home.',
    genres: ['Action', 'Adventure', 'Sci-Fi'],
    year: 2024,
    duration: '2h 28m',
    ageRating: 'R',
  ),
  Movie(
    id: '4',
    title: 'Inside Out 2',
    imageUrl: 'assets/images/poster_insideout.png',
    rating: 7.9,
    overview: 'Follows Riley in her teenage years, where she encounters the complexities of high school and friendships. The existing emotions—Joy, Sadness, Anger, Fear, and Disgust—are suddenly thrown into chaos with the arrival of new, more complex emotions like Anxiety, Envy, and Embarrassment.',
    genres: ['Animation', 'Adventure', 'Comedy'],
    year: 2024,
    duration: '1h 36m',
    ageRating: 'PG',
  ),
];


// --- DAFTAR FILM UTAMA (Digunakan oleh MovieProvider untuk filter genre) ---
// Menggabungkan semua list ke dalam satu list utama dan menghapus duplikasi (berdasarkan ID)
final List<Movie> allMovies = [...nowPlayingMovies, ...watchlistItems, ...popularMovies]
    .fold<Map<String, Movie>>({}, (map, movie) {
  map[movie.id] = movie;
  return map;
})
    .values
    .toList();