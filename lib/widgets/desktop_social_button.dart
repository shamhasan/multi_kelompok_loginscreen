import 'package:flutter/material.dart';

class DesktopSocialButton extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback? onPressed;

  const DesktopSocialButton({
    super.key,
    required this.icon,
    required this.title,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
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
      icon: Image.network(icon, width: 32, height: 32),
    );
  }
}
