import 'package:flutter/material.dart';
import 'package:multi_kelompok/screen/register_ui.dart';
import 'package:multi_kelompok/widgets/desktop_social_button.dart';

class DesktopLoginUi extends StatelessWidget {
  final double screenWidth;
  // Menerima state dan callback dari parent (LoginScreen)
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onSignIn;
  final bool isLoading;

  const DesktopLoginUi({
    super.key,
    required this.screenWidth,
    required this.emailController,
    required this.passwordController,
    required this.onSignIn,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Masuk Di sini",
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF329A71),
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Selamat Datang Kembali!",
                style: TextStyle(fontSize: 24, color: Colors.black),
              ),
              const SizedBox(height: 64),
              SizedBox(
                width: screenWidth * 0.4,
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: "Email",
                    suffixIcon: const Icon(Icons.email_outlined),
                    filled: true,
                    fillColor: Colors.grey[200],
                    hintStyle: TextStyle(
                      fontSize: 20,
                      fontFamily: "Poppins",
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w200,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 20,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Email tidak boleh kosong' : null,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: screenWidth * 0.4,
                child: TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Kata Sandi", // Hint diperbaiki
                    suffixIcon: const Icon(Icons.visibility_off_outlined),
                    filled: true,
                    fillColor: Colors.grey[200],
                    hintStyle: TextStyle(
                      fontSize: 20,
                      fontFamily: "Poppins",
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w200,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 20,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                   validator: (value) =>
                      value!.isEmpty ? 'Kata Sandi tidak boleh kosong' : null,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: screenWidth * 0.4,
                child: const Text(
                  "Lupa Kata Sandi?",
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
              const SizedBox(height: 60),
              isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: screenWidth * 0.4,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: onSignIn, // Menghubungkan ke fungsi signIn
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF329A71),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Masuk",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
              const SizedBox(height: 16),
              SizedBox(
                width: screenWidth * 0.4,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterUi()),
                    );
                  },
                  child: const Text(
                    "Daftar",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: screenWidth * 0.25,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Divider(color: Colors.black54, thickness: 1),
                    ),
                    SizedBox(width: 16),
                    Text(
                      "Lanjutkan dengan",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Divider(color: Colors.black54, thickness: 1),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: screenWidth * 0.25,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DesktopSocialButton(
                      icon: "assets/images/google.png",
                      title: "Google",
                      onPressed: () {},
                    ),
                    const SizedBox(width: 32),
                    DesktopSocialButton(
                      icon: "assets/images/facebook.png",
                      title: "Facebook",
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
