import 'package:flutter/material.dart';

class CategoryFilterWidget extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onSelectCategory;

  const CategoryFilterWidget({
    super.key,
    required this.selectedCategory,
    required this.onSelectCategory,
  });

  @override
  Widget build(BuildContext context) {
    final categories = ['All', 'Private', 'Group'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Explore Your Next Journey',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Color(0xFF3E3E3E),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: categories.map((cat) {
              final isSelected = selectedCategory == cat;
              return Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: GestureDetector(
                  onTap: () => onSelectCategory(cat),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFFE4E7D)
                          : const Color(0xFFA3EDEE),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFF3E3E3E),
                        width: 2,
                      ),
                    ),
                    child: Text(
                      cat,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF3E3E3E),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}