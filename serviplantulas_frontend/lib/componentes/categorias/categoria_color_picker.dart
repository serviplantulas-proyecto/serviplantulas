import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';

/// Colores del identificador de categoría (Figma).
const kCategoriaColores = <Color>[
  Color(0xFF5BAF6A),
  Color(0xFF8B6914),
  Color(0xFFE07A5F),
  Color(0xFF4A90A4),
  Color(0xFF8B6BC9),
];

/// Fondos pastel para el icono en la lista (mismo orden).
const kCategoriaIconBg = <Color>[
  Color(0xFFE5F5E9),
  Color(0xFFF5EDE0),
  Color(0xFFFFE8E0),
  Color(0xFFE0F0F5),
  Color(0xFFF0E8FF),
];

class CategoriaColorPicker extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const CategoriaColorPicker({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(kCategoriaColores.length, (i) {
        final selected = selectedIndex == i;
        final color = kCategoriaColores[i];
        return Padding(
          padding: const EdgeInsets.only(right: 12),
          child: GestureDetector(
            onTap: () => onChanged(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: selected
                    ? Border.all(color: AppColors.primary, width: 3)
                    : null,
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: color.withOpacity(0.4),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
            ),
          ),
        );
      }),
    );
  }
}
