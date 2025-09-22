import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: LoginScreen()));
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isDesktop = screenWidth > 960; // Deteksi jika perangkat adalah Desktop

    return Scaffold(
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            bool isPortrait = orientation == Orientation.portrait;

            return Center(
              child: LayoutBuilder(
                builder: (context, builder) {
                  return Container(
                    width: isDesktop
                        ? 960
                        : (isPortrait ? screenWidth * 0.9 : screenWidth * 0.65),
                    padding: EdgeInsets.all(16),
                    height: screenHeight,
                    child: isDesktop
                        ? _buildDesktop(screenWidth)
                        : (isPortrait
                              ? _buildPortrait(screenWidth)
                              : _buildLanscape(screenWidth)),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  // Widget untuk tampilan lanskap
  Widget _buildLanscape(double screenWidth) {
    return Container(
      color: Colors.blueGrey[50],
      child: Center(
        child: Text(
          "Landscape UI",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // Widget untuk tampilan potret
  Widget _buildPortrait(double screenWidth) {
    return Container(
      color: Colors.teal[50],
      child: Center(
        child: Text(
          "Portrait UI",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildDesktop(double screenWidth) {
    return Container(
      color: Colors.amber[50],
      child: Center(
        child: Text(
          "Desktop UI",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
