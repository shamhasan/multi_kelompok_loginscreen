import 'package:flutter/material.dart';
import 'package:multi_kelompok/providers/auth_provider/AuthProvider.dart';
import 'package:multi_kelompok/screen/home_screen.dart';
import 'package:multi_kelompok/screen/portrait_ui.dart';
import 'package:multi_kelompok/screen/landscape_ui.dart';
import 'package:multi_kelompok/screen/desktop_login_ui.dart';
import 'package:provider/provider.dart';

// Mengubah menjadi StatefulWidget untuk menampung state
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _signIn() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      // Cukup panggil signIn. AuthGate akan menangani navigasi secara otomatis.
      await Provider.of<AuthProvider>(context, listen: false).signIn(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      
      // PERBAIKAN: Hapus navigasi manual dari sini.
      // AuthGate akan secara reaktif membangun ulang dan menampilkan HomeScreen.
      
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal login: ${e.toString()}'), backgroundColor: Colors.red),
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isDesktop = screenWidth > 960;

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
                        ? 1200
                        : (isPortrait ? screenWidth * 0.9 : screenWidth * 0.65),
                    padding: const EdgeInsets.all(0.0),
                    height: screenHeight,
                    child: isDesktop
                        ? DesktopLoginUi(
                            screenWidth: screenWidth,
                            emailController: _emailController,
                            passwordController: _passwordController,
                            onSignIn: _signIn,
                            isLoading: _isLoading,
                          )
                        : (isPortrait
                            ? PortraitUi(
                                emailController: _emailController,
                                passwordController: _passwordController,
                                onSignIn: _signIn,
                                isLoading: _isLoading,
                              )
                            : LandscapeUI(
                                emailController: _emailController,
                                passwordController: _passwordController,
                                onSignIn: _signIn,
                                isLoading: _isLoading,
                              )),
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
