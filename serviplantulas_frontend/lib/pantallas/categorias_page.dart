import 'package:flutter/material.dart';

import '../componentes/compartidos/app_bar_simple.dart';
import '../styles/app_colors.dart';
import '../styles/app_radius.dart';
import '../styles/app_text_styles.dart';
import 'agregar_categoria_page.dart';

class CategoriasPage extends StatelessWidget {
  const CategoriasPage({super.key});

  // Mock — GET /categorias
  static const _cats = [
    ('Helechos', 24, Icons.grass),
    ('Arbustos', 18, Icons.park),
    ('Flores', 32, Icons.local_florist),
    ('Frutales', 12, Icons.eco),
    ('Suculentas', 28, Icons.spa),
    ('Interiores', 15, Icons.home_outlined),
    ('Sombra', 9, Icons.wb_cloudy_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const AppBarSimple(title: 'Categorías'),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.4,
                ),
                itemCount: _cats.length,
                itemBuilder: (context, i) {
                  final (nombre, count, icon) = _cats[i];
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.large),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(icon, size: 28, color: AppColors.mutedGreen),
                        const SizedBox(height: 8),
                        Text(
                          nombre,
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          '$count productos',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AgregarCategoriaPage()),
          );
        },
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
