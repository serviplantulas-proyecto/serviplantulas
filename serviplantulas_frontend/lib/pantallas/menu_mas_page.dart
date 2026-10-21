import 'package:flutter/material.dart';
import 'package:serviplantulas_frontend/pantallas/categorias_page.dart';
import 'package:serviplantulas_frontend/pantallas/directorio_proveedores_page.dart';

import '../componentes/menu/menu_option_tile.dart';
import '../styles/app_colors.dart';
import '../styles/app_text_styles.dart';
import 'ajustar_stock_page.dart';
import 'chat_eva_page.dart';
import 'configurar_alertas_page.dart';
import 'historial_facturas_page.dart';
import 'mi_cuenta_page.dart';

class MenuMasPage extends StatelessWidget {
  const MenuMasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                children: [
                  MenuOptionTile(
                    icon: Icons.category_outlined,
                    title: 'Directorio Categorías',
                    subtitle: 'Ver todas las categorás del catágolo',
                    onTap: () => _go(context, const CategoriasPage()),
                  ),
                  MenuOptionTile(
                    icon: Icons.local_shipping_outlined,
                    title: 'Directorio Proveedores',
                    subtitle: 'Ver contactos de abastecimiento',
                    onTap: () => _go(context, const DirectorioProveedoresPage()),
                  ),
                  MenuOptionTile(
                    icon: Icons.person_outline,
                    title: 'Mi Cuenta',
                    subtitle: 'Configuración de perfil y acceso',
                    onTap: () => _go(context, const MiCuentaPage()),
                  ),
                  MenuOptionTile(
                    icon: Icons.notifications_outlined,
                    title: 'Configurar Alertas',
                    subtitle: 'Alertas de stock mínimo y compras',
                    onTap: () => _go(context, const ConfigurarAlertasPage()),
                  ),
                  MenuOptionTile(
                    icon: Icons.receipt_long_outlined,
                    title: 'Historial de Facturas',
                    subtitle: 'Revisar ventas e ingresos',
                    onTap: () => _go(context, const HistorialFacturasPage()),
                  ),
                  MenuOptionTile(
                    icon: Icons.swap_vert,
                    title: 'Ajustar Stock',
                    subtitle: 'Modificaciones manuales de inventario',
                    onTap: () => _go(context, const AjustarStockPage()),
                  ),
                  MenuOptionTile(
                    icon: Icons.smart_toy_outlined,
                    title: 'Chat Bot',
                    subtitle: 'Accede a la IA de ServiPlantulas',
                    iconBg: AppColors.infoBackground,
                    onTap: () => _go(context, const ChatEvaPage()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Más Opciones',
            style: AppTextStyles.titleSmall.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
              fontSize: 18,
            ),
          ),
          const Icon(Icons.eco_outlined, color: AppColors.primary, size: 22),
        ],
      ),
    );
  }

  void _go(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }
}
