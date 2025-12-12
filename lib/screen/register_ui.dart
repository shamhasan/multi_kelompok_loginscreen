import 'package:flutter/material.dart';
import 'package:multi_kelompok/providers/auth_provider/AuthProvider.dart';
import 'package:multi_kelompok/screen/login_screen.dart';
import 'package:multi_kelompok/widgets/social_button.dart';
import 'package:multi_kelompok/widgets/text_field.dart';
import 'package:provider/provider.dart';

class RegisterUi extends StatefulWidget {
  const RegisterUi({super.key});

  @override
  State<RegisterUi> createState() => _RegisterUiState();
}

class _RegisterUiState extends State<RegisterUi> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.signUp(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _usernameController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Registrasi berhasil. Silakan cek email Anda untuk konfirmasi.'),
          backgroundColor: Colors.blue,
        ));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal registrasi: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
        child: Form(
          key: _formKey,
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
                "Daftar Pengguna Baru",
                style: TextStyle(fontSize: 15, color: Colors.black54),
              ),
              const SizedBox(height: 40),
              CustomTextField(controller: _emailController, hint: "Email", validator: (value) => value!.isEmpty ? 'Email tidak boleh kosong' : null),
              const SizedBox(height: 16),
              CustomTextField(controller: _usernameController, hint: "Username", validator: (value) => value!.isEmpty ? 'Username tidak boleh kosong' : null),
              const SizedBox(height: 16),
              CustomTextField(controller: _passwordController, hint: "Kata sandi", isPassword: true, validator: (value) => (value?.length ?? 0) < 6 ? 'Kata sandi minimal 6 karakter' : null),
              const SizedBox(height: 16),
              CustomTextField(controller: _confirmPasswordController, hint: "Tulis ulang kata sandi", isPassword: true, validator: (value) {
                  if (value != _passwordController.text) {
                    return 'Kata sandi tidak cocok';
                  }
                  return null;
                }),
              const SizedBox(height: 24),
              _isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _register,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                        child: const Text(
                          "Daftar",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
              const SizedBox(height: 14),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                child: const Text('Sudah punya akun? Masuk'),
              ),
              const SizedBox(height: 30),
              const Text("Lanjutkan dengan", style: TextStyle(fontSize: 13)),
              const SizedBox(height: 12),
              // Menggunakan SocialButton kembali
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
      ),
    );
  }
}
