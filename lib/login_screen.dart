import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: LoginScreen(), debugShowCheckedModeBanner: false,));
}

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
                        ? _buildDesktop(screenWidth)
                        : (isPortrait
<<<<<<< HEAD
                              ? _buildPortrait(screenWidth)
                              : _buildLandscape(screenWidth)),
=======
                        ? _buildEditProfileUI()
                        : _buildLanscape(screenWidth)),
>>>>>>> 1173d5e24a7c208b6dee9b4f7d87ef260fb2c1a3
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
  Widget _buildLoginUI() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Login",
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

            TextField(
              decoration: InputDecoration(
                hintText: "Email",
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Kata sandi",
                suffixIcon: const Icon(Icons.visibility_off_outlined),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 8),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  "Lupa Kata Sandi?",
                  style: TextStyle(color: Colors.black54, fontSize: 13),
                ),
              ),
            ),
            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Add your login logic here
                },
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
                // Add navigation logic to the Register page if needed
              },
              child: const Text(
                "Daftar",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(height: 30),

            const Text("Lanjutkan dengan", style: TextStyle(fontSize: 13)),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _socialButton(Icons.g_mobiledata),
                const SizedBox(width: 20),
                _socialButton(Icons.facebook),
                const SizedBox(width: 20),
                _socialButton(Icons.apple),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterUI() {
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

            _textField("Email"),
            const SizedBox(height: 16),
            _textField("Username"),
            const SizedBox(height: 16),
            _textField("Kata sandi", isPassword: true),
            const SizedBox(height: 16),
            _textField("Tulis ulang kata sandi", isPassword: true),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Add your registration logic here
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
                // Add navigation logic to the Login page if needed
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
                _socialButton(Icons.g_mobiledata),
                const SizedBox(width: 20),
                _socialButton(Icons.facebook),
                const SizedBox(width: 20),
                _socialButton(Icons.apple),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditProfileUI() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    // Add back navigation logic here
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                const SizedBox(width: 8),
                const Text(
                  "Edit Profile",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Stack(
              alignment: Alignment.bottomRight,
              children: [
                const CircleAvatar(
                  radius: 55,
                  backgroundImage: NetworkImage(
                    "https://i.pravatar.cc/150?img=47",
                  ), // contoh gambar
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(6),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            const Align(
              alignment: Alignment.centerLeft,
<<<<<<< HEAD
              child: const Text(
                "Detail Profil",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
=======
              child: Text("Detail Profil",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
>>>>>>> 1173d5e24a7c208b6dee9b4f7d87ef260fb2c1a3
            ),
            const SizedBox(height: 12),

            _profileField(Icons.email, "Email", "jollybeer@gmail.com"),
            const SizedBox(height: 12),
            _profileField(Icons.phone, "No Telp", "082247283745"),

            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
<<<<<<< HEAD
              child: const Text(
                "Pengaturan",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
=======
              child: Text("Pengaturan",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
>>>>>>> 1173d5e24a7c208b6dee9b4f7d87ef260fb2c1a3
            ),
            const SizedBox(height: 12),

            _settingField(Icons.notifications, "Atur Notifikasi"),
            _settingField(Icons.lock, "Ubah Kata Sandi"),

            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () {
                // Add logout logic here
              },
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text("Keluar", style: TextStyle(color: Colors.red)),
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Add logic for "Edit Akun" button
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Edit Akun",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textField(String hint, {bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: isPassword
            ? const Icon(Icons.visibility_off_outlined)
            : null,
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
    );
  }

  Widget _profileField(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[700]),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _settingField(IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.black87),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Icon(Icons.chevron_right, color: Colors.black45),
        ],
      ),
    );
  }

  Widget _socialButton(IconData icon) {
    return Container(
      width: 45,
      height: 45,
      decoration: const BoxDecoration(
        color: Color(0xFFF1F1F1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 26, color: Colors.black87),
    );
  }

  Widget _desktopSocialButton(
    String icon,
    String title, 
    VoidCallback? onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      label: Text(title, style: TextStyle(fontSize: 12, color: Colors.black45)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.black54),
        ),
      ),
      icon: Image.network(icon,width: 32, height: 32,),
      
    );
  }

  // Widget untuk tampilan dekstop
  Widget _buildDesktop(double screenWidth) {
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
              Container(width: screenWidth * 0.4, child: _textField("Email")),
              SizedBox(height: 32),
              Container(
                width: screenWidth * 0.4,
                child: _textField("Kata sandi", isPassword: true),
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
                  onPressed: () {},
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
                  onPressed: () {},
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
                    _desktopSocialButton("assets/images/google.png", "Google", (){}),
                    SizedBox(width: 32),
                    _desktopSocialButton("assets/images/facebook.png", "Facebook", (){}),
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