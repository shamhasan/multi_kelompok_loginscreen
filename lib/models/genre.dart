class Genre {
  final int id;
  String name;
  final DateTime createdAt;
  String? description;

  Genre({required this.id, required this.name, required this.createdAt, this.description});

  // Mengubah data dari format Map (JSON) menjadi objek Genre
  factory Genre.fromMap(Map<String, dynamic> map) {
    return Genre(
      id: map['id'] as int,
      name: map['name'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      description: map['description'] as String?,
    );
  }

  // DITAMBAHKAN: Mengubah objek Genre menjadi format Map (JSON) untuk dikirim ke Supabase
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      // ID dan createdAt biasanya tidak perlu dikirim saat membuat data baru
    };
  }
}
