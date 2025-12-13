import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider extends ChangeNotifier {
  final SupabaseClient _client = Supabase.instance.client;

  User? _user;
  User? get user => _user;

  String? _role;
  String? get role => _role;

  Map<String, dynamic>? _profileData;
  Map<String, dynamic>? get profileData => _profileData;

  

  AuthProvider() {
    _init();
  }

  void _init() {
    _user = _client.auth.currentUser;
    notifyListeners();

    _client.auth.onAuthStateChange.listen((data) async {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      _user = session?.user;

      if(_user != null){
        await fetchUserProfile();
      }

      notifyListeners();
    });
  }

  Future<void> signUp(String email, String password, String username) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {'username': username},
      );

      print("response: $response");

      if (response.user != null) {
        _user = response.user;
        notifyListeners();
      }
    } on AuthException {
      rethrow;
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        _user = response.user;
        notifyListeners();
      }
    } on AuthException {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
      _user = null;
      notifyListeners();
    } on AuthException {
      rethrow;
    }
  }

  Future<void> fetchUserProfile() async {
    if (_user == null) return;

    try {
      // Mengambil semua kolom (*) dari tabel profiles berdasarkan ID user yang login
      final response = await _client
          .from('profiles')
          .select() 
          .eq('id', _user!.id)
          .single();

      _profileData = response as Map<String, dynamic>?;
      
      notifyListeners();
      
    } catch (e) {
      debugPrint("Error fetching profile: $e");
      // Opsional: Jika data profiles belum ada, kita bisa handle error di sini
    }
  }
}
