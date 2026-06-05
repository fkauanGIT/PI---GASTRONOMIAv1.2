import 'package:flutter/material.dart';
import '../../../../../../config/theme/app_colors.dart';

class IngredientChipSelector extends StatelessWidget {
  final String selectedUnit;
  final Function(String) onUnitSelected;

  const IngredientChipSelector({
    super.key,
    required this.selectedUnit,
    required this.onUnitSelected,
  });

  @override
  Widget build(BuildContext context) {
    final unidades = ["g", "kg", "ml", "L", "un"];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: const TextSpan(
            text: 'Unidade',
            style: TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            children: [
              TextSpan(
                text: ' *',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: unidades.map((unidade) {
            final isSelected = unidade == selectedUnit;
            return ChoiceChip(
              label: Text(unidade),
              selected: isSelected,
              onSelected: (_) => onUnitSelected(unidade),
              selectedColor: AppColors.primary.withValues(alpha: 0.1),
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.primary : const Color(0xFF6B7280),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              side: BorderSide(
                color: isSelected ? AppColors.primary : const Color(0xFFE5E7EB),
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              showCheckmark: false,
            );
          }).toList(),
        ),
      ],
    );
  }
}
