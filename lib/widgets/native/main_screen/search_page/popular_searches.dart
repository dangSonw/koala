import 'package:flutter/material.dart';

class PopularSearches extends StatelessWidget {
  final List<String> searches;
  final Function(String) onSearchTap;

  const PopularSearches({
    super.key,
    required this.searches,
    required this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Popular Searches',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: searches.length,
          itemBuilder: (context, index) {
            final search = searches[index];
            return InkWell(
              onTap: () => onSearchTap(search),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    search,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
