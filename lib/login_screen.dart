import 'package:flutter/material.dart';

void main() {
  runApp(LoginScreen());
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();

}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true; //tooglepass
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 30),
                      Text(
                        "Masuk Di Sini",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Selamat Datang Kembali!",
                        style: TextStyle(fontSize:16,color: Colors.black54),
                      )
                    ],
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}


// Widget untuk tampilan  lanskap
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
