import 'package:flutter/material.dart';

class FilterChips extends StatelessWidget {
  final List<String> filters;
  final String selectedFilter;
  final Function(String) onFilterSelected;

  const FilterChips({
    super.key,
    required this.filters,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter;
          
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                onFilterSelected(filter);
              },
              backgroundColor: Colors.grey.shade200,
              selectedColor: Colors.blue.shade100,
              checkmarkColor: Colors.blue,
            ),
          );
        },
      ),
    );
  }
}
