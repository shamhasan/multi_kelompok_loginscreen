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
    final PageController controller = PageController();

    return Scaffold(
      body: PageView(
        controller: controller,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildLoginUIWithNav(controller),
          _buildRegisterUIWithNav(controller),
          _buildEditProfileUIWithNav(controller),
        ],
      ),
    );
  }

  Widget _buildLoginUIWithNav(PageController controller) {
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
                  fontSize: 26, fontWeight: FontWeight.bold, color: Colors.green),
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
                child: const Text("Lupa Kata Sandi?",
                    style: TextStyle(color: Colors.black54, fontSize: 13)),
              ),
            ),
            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => controller.jumpToPage(2),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                child: const Text("Masuk",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 14),

            GestureDetector(
              onTap: () => controller.jumpToPage(1),
              child: const Text(
                "Daftar",
                style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                    fontSize: 15),
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

  Widget _buildRegisterUIWithNav(PageController controller) {
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
                  fontSize: 26, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 6),
            const Text("Daftar Pengguna",
                style: TextStyle(fontSize: 15, color: Colors.black54)),
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
                onPressed: () => controller.jumpToPage(0),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("Daftar",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 14),

            GestureDetector(
              onTap: () => controller.jumpToPage(0),
              child: const Text.rich(
                TextSpan(
                  text: "Sudah punya akun? ",
                  style: TextStyle(color: Colors.black87),
                  children: [
                    TextSpan(
                      text: "Masuk",
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.w600),
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

  Widget _buildEditProfileUIWithNav(PageController controller) {
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
                  onPressed: () => controller.jumpToPage(0),
                  icon: const Icon(Icons.arrow_back),
                ),
                const SizedBox(width: 8),
                const Text("Edit Profile",
                    style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 20),

            Stack(
              alignment: Alignment.bottomRight,
              children: [
                const CircleAvatar(
                  radius: 55,
                  backgroundImage: NetworkImage(
                      "https://i.pravatar.cc/150?img=47"), // contoh gambar
                ),
                Container(
                  decoration: const BoxDecoration(
                      color: Colors.green, shape: BoxShape.circle),
                  padding: const EdgeInsets.all(6),
                  child: const Icon(Icons.camera_alt,
                      color: Colors.white, size: 18),
                ),
              ],
            ),
            const SizedBox(height: 30),

            Align(
              alignment: Alignment.centerLeft,
              child: const Text("Detail Profil",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            const SizedBox(height: 12),

            _profileField(Icons.email, "Email", "jollybeer@gmail.com"),
            const SizedBox(height: 12),
            _profileField(Icons.phone, "No Telp", "082247283745"),

            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: const Text("Pengaturan",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            const SizedBox(height: 12),

            _settingField(Icons.notifications, "Atur Notifikasi"),
            _settingField(Icons.lock, "Ubah Kata Sandi"),

            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () => controller.jumpToPage(0),
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text("Keluar",
                  style: TextStyle(color: Colors.red)),
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Edit Akun",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
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
        suffixIcon:
        isPassword ? const Icon(Icons.visibility_off_outlined) : null,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
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
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              Text(value,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500)),
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
              Text(title,
                  style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
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

  // Widget untuk tampilan dekstop
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
