class Genre {
  final int id;
  String name;
  final DateTime createdAt;
  String? description;

  Genre({required this.id, required this.name, required this.createdAt, this.description});

  factory Genre.fromMap(Map<String, dynamic> map) {
    return Genre(
      id: map['id'] as int,
      name: map['name'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      description: map['description'] as String?,
    );
  }
}
