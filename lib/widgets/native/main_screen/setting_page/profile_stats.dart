import 'package:flutter/material.dart';

class ProfileStats extends StatelessWidget {
  final String label;
  final String value;

  const ProfileStats({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18, 
            fontWeight: FontWeight.bold, 
            color: Colors.white
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70),
        ),
      ],
    );
  }
}
