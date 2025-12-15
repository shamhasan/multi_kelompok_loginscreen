import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:multi_kelompok/models/genre.dart';

final supabase = Supabase.instance.client;

class GenreProvider extends ChangeNotifier {
  List<Genre> _genres = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Genre> get genres => _genres;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  static const Color primaryColor = Color(0xFF469756);

  void _showSnackbar(BuildContext context, String message,
      {bool isError = false}) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red.shade600 : primaryColor,
        ),
      );
    }
  }

  // 1. READ
  Future<void> fetchGenres(BuildContext context) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final List<Map<String, dynamic>> response = await supabase
          .from('genres')
          .select('id, name, created_at, description')
          .order('id', ascending: true);

      _genres = response.map((item) => Genre.fromMap(item)).toList();
    } catch (e) {
      _errorMessage = 'Error Read Data: ${e.toString()}';
      _showSnackbar(context, _errorMessage!, isError: true);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 2. CREATE
  Future<bool> addGenre(BuildContext context, String name,
      String description) async {
    // ... [Logika addGenre tetap sama seperti sebelumnya, tapi menggunakan Genre] ...
    try {
      final List<Map<String, dynamic>> response = await supabase
          .from('genres')
          .insert({'name': name.trim(), 'description': description.trim()})
          .select();

      if (response.isNotEmpty) {
        final newGenre = Genre.fromMap(response.first);
        _genres.add(newGenre);
        notifyListeners();
        _showSnackbar(
            context, 'Genre "${newGenre.name}" berhasil ditambahkan!');
        return true;
      }
      return false;
    } catch (e) {
      _showSnackbar(
          context, 'Gagal menambah genre: ${e.toString()}', isError: true);
      return false;
    }
  }

  // 3. UPDATE
  Future<bool> editGenre(BuildContext context, int id, String newName,
      String newDescription) async {
    // ... [Logika editGenre tetap sama] ...
    try {
      await supabase
          .from('genres')
          .update(
          {'name': newName.trim(), 'description': newDescription.trim()})
          .eq('id', id);

      final i = _genres.indexWhere((g) => g.id == id);
      if (i != -1) {
        _genres[i].name = newName.trim();
        _genres[i].description = newDescription.trim();
        notifyListeners();
        _showSnackbar(context, 'Genre berhasil diperbarui!');
        return true;
      }
      return false;
    } catch (e) {
      _showSnackbar(
          context, 'Gagal mengedit genre: ${e.toString()}', isError: true);
      return false;
    }
  }

  // 4. DELETE
  Future<void> deleteGenre(BuildContext context, int id, String name) async {
    try {
      await supabase.from('genres').delete().eq('id', id);
      _genres.removeWhere((g) => g.id == id);
      notifyListeners();
      _showSnackbar(context, 'Genre "$name" berhasil dihapus!');
    } catch (e) {
      _showSnackbar(context, 'Gagal menghapus genre. Detail: ${e.toString()}',
          isError: true);
    }
  }
}
