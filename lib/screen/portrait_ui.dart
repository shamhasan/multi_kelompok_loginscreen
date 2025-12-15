import 'package:flutter/material.dart';
import 'package:multi_kelompok/screen/register_ui.dart';
import 'package:multi_kelompok/widgets/social_button.dart';

class PortraitUi extends StatelessWidget {
  // Menerima state dan callback dari parent (LoginScreen)
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onSignIn;
  final bool isLoading;

  const PortraitUi({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.onSignIn,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Masuk",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Selamat Datang Kembali!",
              style: TextStyle(fontSize: 15, color: Colors.black54),
            ),
            const SizedBox(height: 40),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: (value) => value!.isEmpty ? 'Email tidak boleh kosong' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Kata Sandi'),
              obscureText: true,
              validator: (value) => value!.isEmpty ? 'Kata Sandi tidak boleh kosong' : null,
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  "Lupa Kata Sandi?",
                  style: TextStyle(color: Colors.green, fontSize: 12),
                ),
              ),
            ),
            const SizedBox(height: 24),
            isLoading
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: onSignIn, // Menghubungkan ke fungsi signIn
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Masuk",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
            const SizedBox(height: 14),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterUi()),
                );
              },
              child: const Text.rich(
                TextSpan(
                  text: "Belum punya akun? ",
                  style: TextStyle(color: Colors.black87),
                  children: [
                    TextSpan(
                      text: "Daftar",
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
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SocialButton(icon: Icons.g_mobiledata),
                SizedBox(width: 20),
                SocialButton(icon: Icons.facebook),
                SizedBox(width: 20),
                SocialButton(icon: Icons.apple),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
