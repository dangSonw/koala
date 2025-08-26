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
    if (searches.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.trending_up,
              size: 20,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 8),
            Text(
              'Popular Searches',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: searches.take(12).map((search) {
            return InkWell(
              onTap: () => onSearchTap(search),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                      Theme.of(context).colorScheme.secondaryContainer.withValues(alpha: 0.3),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getAnimalIcon(search),
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      search,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  IconData _getAnimalIcon(String animal) {
    switch (animal.toLowerCase()) {
      case 'lion':
      case 'tiger':
        return Icons.pets;
      case 'elephant':
        return Icons.nature;
      case 'penguin':
      case 'eagle':
      case 'owl':
        return Icons.flutter_dash;
      case 'dolphin':
      case 'whale':
      case 'shark':
        return Icons.waves;
      case 'butterfly':
        return Icons.local_florist;
      case 'snake':
        return Icons.timeline;
      case 'turtle':
        return Icons.shield;
      case 'monkey':
        return Icons.face;
      case 'panda':
      case 'koala':
        return Icons.favorite;
      case 'kangaroo':
        return Icons.sports_handball;
      case 'giraffe':
        return Icons.height;
      case 'zebra':
        return Icons.straighten;
      default:
        return Icons.pets;
    }
  }
}
