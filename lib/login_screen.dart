import 'package:flutter/material.dart';

void main() {
  runApp(LoginScreen());
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isTablet = screenWidth > 600; // Deteksi jika perangkat adalah tablet

    return Scaffold(
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            bool isPortrait = orientation == Orientation.portrait;

            return Center(
              child: LayoutBuilder(builder: (context, builder){
                return Container(
                  width: isTablet ? 600 : (isPortrait ? screenWidth * 0.9 : screenWidth * 0.65),
                  padding: EdgeInsets.all(16),
                  height: screenHeight,
                  child: Column(),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}
