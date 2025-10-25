import 'package:flutter/material.dart';

class SettingField extends StatelessWidget {
  final IconData icon;
  final String title;
  
  const SettingField({super.key, required this.icon, required this.title});

  @override
 Widget build(BuildContext context) {
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
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const Icon(Icons.chevron_right, color: Colors.black45),
      ],
    ),
  );
}
}