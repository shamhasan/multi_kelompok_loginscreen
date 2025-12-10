import 'package:flutter/material.dart';
import 'package:multi_kelompok/Providers/auth_provider/AuthProvider.dart';
import 'package:multi_kelompok/home_screen.dart';
import 'package:multi_kelompok/login_screen.dart';
import 'package:multi_kelompok/profile_ui.dart';
import 'package:multi_kelompok/widgets/social_button.dart';
import 'package:multi_kelompok/widgets/text_field.dart';
import 'package:provider/provider.dart';

class RegisterUi extends StatelessWidget {
  RegisterUi({super.key});

  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Register",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Daftar Pengguna",
              style: TextStyle(fontSize: 15, color: Colors.black54),
            ),
            const SizedBox(height: 40),

            CustomTextField(hint: "Email", controller: _emailController),
            const SizedBox(height: 16),
            CustomTextField(hint: "Username", controller: _usernameController,),
            const SizedBox(height: 16),
            CustomTextField(hint: "Kata sandi", isPassword: true, controller: _passwordController,),
            const SizedBox(height: 16),
            CustomTextField(hint: "Tulis ulang kata sandi", isPassword: true, controller: _passwordConfirmationController,),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                 if (_passwordController.text != _passwordConfirmationController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Password tidak sesuai: ${_passwordController.text} tidak sama ${_passwordConfirmationController.text}") ),
                  );
                  return;
                 } else {
                  try {
                    await Provider.of<AuthProvider>(context, listen: false).signUp(
                      _emailController.text,
                      _passwordController.text,
                      _usernameController.text,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Pendaftaran berhasil! Silakan cek email untuk konfirmasi.")),
                    );
                    
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Gagal daftar: $e")),
                    );
                    return;
                  }
                 }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Daftar",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 14),

            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: const Text.rich(
                TextSpan(
                  text: "Sudah punya akun? ",
                  style: TextStyle(color: Colors.black87),
                  children: [
                    TextSpan(
                      text: "Masuk",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            const Text("Lanjutkan dengan", style: TextStyle(fontSize: 13)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SocialButton(icon: Icons.g_mobiledata),
                const SizedBox(width: 20),
                SocialButton(icon: Icons.facebook),
                const SizedBox(width: 20),
                SocialButton(icon: Icons.apple),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
