import 'package:flutter/material.dart';

import '../componentes/analisis/analisis_granularidad.dart';
import '../componentes/analisis/analisis_ingresos_card.dart';
import '../componentes/analisis/analisis_mas_vendidos.dart';
import '../componentes/analisis/analisis_periodo_selector.dart';
import '../componentes/analisis/analisis_ventas_categoria.dart';
import '../componentes/compartidos/app_bar_simple.dart';
import '../styles/app_colors.dart';
import '../styles/app_spacing.dart';

class AnalisisVentasPage extends StatefulWidget {
  const AnalisisVentasPage({super.key});

  @override
  State<AnalisisVentasPage> createState() => _AnalisisVentasPageState();
}

class _AnalisisVentasPageState extends State<AnalisisVentasPage> {
  DateTime _mes = DateTime(DateTime.now().year, DateTime.now().month);
  AnalisisVista _vista = AnalisisVista.semanal;
  int _dia = 1;
  int _semana = 1;

  // Mock — TODO: GET /analisis/ventas?desde=&hasta=&vista=
  static const _ingresos = 8530000.0;
  static const _top = [
    TopVendidoItem(
      nombre: "Helecho Boston Maceta 10''",
      monto: 12000,
      porcentaje: 42,
    ),
    TopVendidoItem(
      nombre: 'Cuna de Moisés (Spathiphyllum)',
      monto: 22000,
      porcentaje: 28,
    ),
    TopVendidoItem(
      nombre: 'Ficus Lyrata Elegance',
      monto: 18000,
      porcentaje: 18,
    ),
  ];
  static const _categorias = [
    CategoriaVentaItem(
      nombre: 'Plantas de Sombra',
      monto: 4520000,
      porcentaje: 1.0,
    ),
    CategoriaVentaItem(
      nombre: 'Arbustos y Árboles',
      monto: 2890000,
      porcentaje: 0.64,
    ),
    CategoriaVentaItem(
      nombre: 'Insumos & Fertilizantes',
      monto: 1120000,
      porcentaje: 0.25,
    ),
  ];

  Future<void> _abrirSelectorMes() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _mes,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: 'Selecciona el mes',
      fieldLabelText: 'Mes',
      locale: const Locale('es', 'CO'),
    );
    if (picked != null) {
      setState(() {
        _mes = DateTime(picked.year, picked.month);
        _dia = 1;
        _semana = 1;
      });
      // TODO: recargar datos del backend con el nuevo mes
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const AppBarSimple(title: 'Análisis de Ventas'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnalisisPeriodoSelector(
                      mesSeleccionado: _mes,
                      rangoTexto:
                          AnalisisPeriodoSelector.formatearRango(_mes),
                      onTapMes: _abrirSelectorMes,
                    ),
                    const SizedBox(height: AppSpacing.large),
                    AnalisisGranularidad(
                      vista: _vista,
                      diaSeleccionado: _dia,
                      semanaSeleccionada: _semana,
                      onVistaChanged: (v) => setState(() => _vista = v),
                      onDiaChanged: (d) => setState(() => _dia = d),
                      onSemanaChanged: (s) => setState(() => _semana = s),
                    ),
                    const SizedBox(height: AppSpacing.extraLarge),
                    const AnalisisIngresosCard(
                      ingresos: _ingresos,
                      variacionTexto: '+12.4% vs período anterior',
                    ),
                    const SizedBox(height: AppSpacing.extraLarge),
                    const AnalisisMasVendidos(items: _top),
                    const SizedBox(height: AppSpacing.extraLarge),
                    const AnalisisVentasCategoria(items: _categorias),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
