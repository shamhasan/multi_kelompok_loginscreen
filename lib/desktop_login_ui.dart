import 'package:flutter/material.dart';
import 'package:multi_kelompok/home_screen.dart';
import 'package:multi_kelompok/profile_ui.dart';
import 'package:multi_kelompok/register_ui.dart';
import 'package:multi_kelompok/widgets/desktop_social_button.dart';
import 'package:multi_kelompok/widgets/text_field.dart';

class DesktopLoginUi extends StatelessWidget {
  final double screenWidth;
  const DesktopLoginUi({super.key, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Masuk Di sini",
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF329A71),
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Selamat Datang Kembali!",
                style: TextStyle(fontSize: 24, color: Colors.black),
              ),
              SizedBox(height: 64),
              Container(
                width: screenWidth * 0.4,
                child: CustomTextField(hint: "Email"),
              ),
              SizedBox(height: 32),
              Container(
                width: screenWidth * 0.4,
                child: CustomTextField(hint: "Kata sandi", isPassword: true),
              ),
              SizedBox(height: 32),
              Container(
                width: screenWidth * 0.4,
                child: Text(
                  "Lupa Kata Sandi?",
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
              SizedBox(height: 60),
              Container(
                width: screenWidth * 0.4,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileUi() ,));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF329A71),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Masuk",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Container(
                width: screenWidth * 0.4,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen() ,));
                  },
                  child: Text(
                    "Daftar",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32),
              Container(
                width: screenWidth * 0.25,
                child: Row(
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
              SizedBox(height: 24),
              Container(
                width: screenWidth * 0.25,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DesktopSocialButton(
                      icon: "assets/images/google.png",
                      title:"Google",
                      onPressed: () {},
                    ),
                    SizedBox(width: 32),
                    DesktopSocialButton(
                      icon:"assets/images/facebook.png",
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
