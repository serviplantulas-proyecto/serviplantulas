import 'package:flutter/material.dart';

import '../componentes/navegacion/bottom_nav_bar.dart';
import '../styles/app_colors.dart';
import 'analisis_ventas_page.dart';
import 'chat_eva_page.dart';
import 'clientes_page.dart';
import 'dashboard_page.dart';
import 'historial_pedidos_page.dart';
import 'inventario_page.dart';
import 'menu_mas_page.dart';
import 'notificaciones_page.dart';
import 'registrar_producto_page.dart';
import 'registro_venta_page.dart';

/// Shell principal con bottom navigation.
/// Índice: 0=Inicio, 1=Inventario, 2=Ventas, 3=Clientes, 4=Más
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  // Mapeo de índice de nav a índice de IndexedStack
  // Nav: 0 Inicio, 1 Inventario, 2 Ventas(push), 3 Clientes, 4 Más
  // Stack: 0 Dashboard, 1 Inventario, 2 Clientes, 3 Más
  int get _stackIndex {
    if (_currentIndex <= 1) return _currentIndex;
    if (_currentIndex == 3) return 2;
    if (_currentIndex == 4) return 3;
    return 0;
  }

  void _onNavTap(int index) {
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const RegistroVentaPage()),
      );
      return;
    }
    setState(() => _currentIndex = index);
  }

  void _push(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _stackIndex,
        children: [
          DashboardPage(
            onNuevaVenta: () => _push(const RegistroVentaPage()),
            onVerInventario: () => setState(() => _currentIndex = 1),
            onChatBot: () => _push(const ChatEvaPage()),
            onNuevoProducto: () => _push(const RegistrarProductoPage()),
            onAnalisis: () => _push(const AnalisisVentasPage()),
            onHistorial: () => _push(const HistorialPedidosPage()),
            onNotificaciones: () => _push(const NotificacionesPage()),
          ),
          const InventarioPage(),
          const ClientesPage(),
          const MenuMasPage(),
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
