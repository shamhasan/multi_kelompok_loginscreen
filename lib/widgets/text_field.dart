import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final bool isPassword;
  final String hint;
  final TextEditingController? controller;


  const CustomTextField({
    super.key,
    this.isPassword = false,
    required this.hint, required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: isPassword,
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: isPassword ? Icon(Icons.visibility_off_outlined) : null,
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
}
