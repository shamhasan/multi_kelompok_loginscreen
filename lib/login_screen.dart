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
                              : _buildLandscape(screenWidth)),
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
  Widget _buildLandscape(double screenWidth) {
    return Container(
      // color: Colors.blueGrey[50],
      child: Row(
        children: [
          // welcome text
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.only(right: screenWidth * 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  Text(
                    "Masuk Di sini",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Selamat Datang\nKembali!",
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),

          // form login
          Expanded(
            flex: 3,
            child: Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // email
                      TextField(
                        decoration: InputDecoration(
                          hintText: "Email",
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // password
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Kata sandi",
                          suffixIcon: const Icon(Icons.visibility_off),
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),

                      // lupa sandi
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Lupa Kata Sandi?",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),

                      // tombol masuk
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {},
                          child: const Text("Masuk"),
                        ),
                      ),
                      const SizedBox(height: 5),

                      // daftar
                      TextButton(
                        onPressed: () {},
                        child: const Text("Daftar"),
                      ),

                      const SizedBox(height: 5),
                      const Text("Lanjutkan dengan"),

                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.g_mobiledata,
                                size: 28, color: Colors.red),
                          ),
                          SizedBox(width: 16),
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.facebook,
                                size: 28, color: Colors.blue),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
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
