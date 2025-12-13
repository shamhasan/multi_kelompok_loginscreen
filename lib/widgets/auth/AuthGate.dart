// File: lib/widgets/auth_gate.dart (sesuaikan path)

import 'package:flutter/material.dart';
import 'package:multi_kelompok/Providers/auth_provider/AuthProvider.dart';
import 'package:multi_kelompok/screen/admin/admin_screen.dart';
import 'package:multi_kelompok/screen/home_screen.dart';
import 'package:multi_kelompok/screen/login_screen.dart';
import 'package:provider/provider.dart';


class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, AuthProvider authProvider, _) {
if (authProvider.user == null) {
          return const LoginScreen();
        }

        // 2. Jika sudah login, cek Rolenya
        // Pastikan profileData sudah ter-fetch (kadang butuh loading sebentar)
        if (authProvider.profileData == null) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

       final String? userRole = authProvider.profileData?['role'];

        // Debugging: Print role dari DATABASE (bukan dari user auth)
        print("Cek Role: User ini memiliki role -> $userRole");

        // 4. Logika Percabangan
        if (userRole == 'admin') {
          return const AdminScreen();
        } else {
          return const HomeScreen();
        }
      },
    );
  }
}
