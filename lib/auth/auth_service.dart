import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  // Sign in 
  Future<AuthResponse> signInWithEmailPassword(String email, String password) async{
    return await supabase.auth.signInWithPassword(
      email: email,
      password: password);
  }

  // Sign up
  Future<AuthResponse> signUpWithEmailPassword(String email, String password)async{
    
    return await supabase.auth.signUp(
      email: email,
      password: password,
      );
  }

  // Sign out
  Future<void> signOut() async {
    await supabase.auth.signOut();
  }


  // get user email
  String? getUserEmail() {
    final session = supabase.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }
}