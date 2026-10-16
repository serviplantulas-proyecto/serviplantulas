import 'package:flutter/material.dart';

import '../componentes/compartidos/app_bar_simple.dart';
import '../componentes/inventario/inventory_search_bar.dart';
import '../styles/app_colors.dart';
import '../styles/app_radius.dart';
import '../styles/app_text_styles.dart';
import 'agregar_proveedor_page.dart';

class DirectorioProveedoresPage extends StatefulWidget {
  const DirectorioProveedoresPage({super.key});

  @override
  State<DirectorioProveedoresPage> createState() =>
      _DirectorioProveedoresPageState();
}

class _DirectorioProveedoresPageState extends State<DirectorioProveedoresPage> {
  final _searchCtrl = TextEditingController();

  // Mock — GET /proveedores
  final _proveedores = const [
    ('Nativo Verde S.A.', '900.123.456-7', '+57 601 555 0100', 48),
    ('Floricultura del Valle', '900.234.567-8', '+57 602 555 0200', 32),
    ('Importaciones Verdes', '900.345.678-9', '+57 601 555 0300', 15),
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const AppBarSimple(title: 'Directorio de Proveedores'),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: InventorySearchBar(
                controller: _searchCtrl,
                hint: 'Buscar proveedor o NIT...',
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                itemCount: _proveedores.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final (nombre, nit, tel, productos) = _proveedores[i];
                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.large),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.editBackground,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.local_shipping_outlined,
                            size: 20,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                nombre,
                                style: AppTextStyles.bodyLarge.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                              Text(
                                'NIT $nit · $tel',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '$productos prod.',
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.mutedGreen,
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
            MaterialPageRoute(builder: (_) => const AgregarProveedorPage()),
          );
        },
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
