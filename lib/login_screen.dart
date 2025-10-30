import 'package:flutter/material.dart';
import 'package:multi_kelompok/desktop_login_ui.dart';
import 'package:multi_kelompok/landscape_ui.dart';
import 'package:multi_kelompok/portrait_ui.dart';
import 'package:multi_kelompok/popular_movie_ui.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isDesktop = screenWidth > 960; // Deteksi jika perangkat adalah Desktop

    return Scaffold(
      // backgroundColor: Colors.white,
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            bool isPortrait = orientation == Orientation.portrait;

            return Center(
              child: LayoutBuilder(
                builder: (context, builder) {
                  return Container(
                    width: isDesktop
                        ? 1200
                        : (isPortrait ? screenWidth * 0.9 : screenWidth * 0.65),
                    padding: const EdgeInsets.all(0.0),
                    height: screenHeight,
                    child: isDesktop
                        ? DesktopLoginUi(screenWidth: screenWidth,)
                        : (isPortrait ? PortraitUi() : LandscapeUI()),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
