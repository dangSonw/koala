import 'package:flutter/material.dart';

class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 16, 
              fontWeight: FontWeight.w600, 
              color: Theme.of(context).colorScheme.primary
            ),
          ),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}
