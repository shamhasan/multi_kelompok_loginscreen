class AgeRating {
  final int? id;
  final String name;

  AgeRating({
    this.id,
    required this.name,
  });

  // Factory: Mengubah JSON (Map) dari Supabase menjadi Object Dart
  factory AgeRating.fromMap(Map<String, dynamic> map) {
    return AgeRating(
      id: map['id'],
      // Gunakan ?? '' untuk mencegah error jika data name null (meski di db not null)
      name: map['name'] ?? '', 
    );
  }

  // Method: Mengubah Object menjadi JSON (jika nanti butuh fitur tambah rating baru)
  Map<String, dynamic> toMap() {
    return {
      // id tidak dikirim saat insert
      'name': name,
    };
  }

  // Override toString agar mudah dibaca di Debug Console
  @override
  String toString() => 'AgeRating(id: $id, name: $name)';
  
  // Override operator == dan hashCode sangat penting untuk DropdownButton 
  // agar Flutter bisa mengenali object yang sama saat dipilih
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is AgeRating &&
      other.id == id &&
      other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}