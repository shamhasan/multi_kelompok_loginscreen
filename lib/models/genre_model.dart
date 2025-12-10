class Genre {
  final int? id;
  final String name;

  Genre({
    this.id,
    required this.name,
  });


  factory Genre.fromMap(Map<String, dynamic> map) {
    return Genre(
      id: map['id'],
      name: map['name'] ?? '', 
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }

  // Override toString agar mudah dibaca saat di-print (debug)
  @override
  String toString() => 'Genre(id: $id, name: $name)';
}