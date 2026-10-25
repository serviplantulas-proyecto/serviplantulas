import 'package:flutter/material.dart';

import '../componentes/analisis/analisis_granularidad.dart';
import '../componentes/analisis/analisis_ingresos_card.dart';
import '../componentes/analisis/analisis_mas_vendidos.dart';
import '../componentes/analisis/analisis_mes_picker.dart';
import '../componentes/analisis/analisis_periodo_selector.dart';
import '../componentes/analisis/analisis_ventas_categoria.dart';
import '../componentes/compartidos/app_bar_simple.dart';
import '../services/analisis_service.dart';
import '../services/pedidos_service.dart';
import '../styles/app_colors.dart';
import '../styles/app_spacing.dart';

class AnalisisVentasPage extends StatefulWidget {
  const AnalisisVentasPage({super.key});

  @override
  State<AnalisisVentasPage> createState() => _AnalisisVentasPageState();
}

class _AnalisisVentasPageState extends State<AnalisisVentasPage> {
  final _service = AnalisisService();
  DateTime _mes = DateTime(DateTime.now().year, DateTime.now().month);
  AnalisisVista _vista = AnalisisVista.mensual;
  int _dia = DateTime.now().day;
  int _semana = 1;
  bool _loading = true;
  String? _error;
  AnalisisResultado? _data;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  (DateTime, DateTime, String) _rango() {
    final y = _mes.year;
    final m = _mes.month;
    final diasMes = DateTime(y, m + 1, 0).day;
    switch (_vista) {
      case AnalisisVista.diario:
        final d = _dia.clamp(1, diasMes);
        final desde = DateTime(y, m, d);
        return (desde, desde, 'Día $d');
      case AnalisisVista.semanal:
        final inicio = ((_semana - 1) * 7 + 1).clamp(1, diasMes);
        final fin = (inicio + 6).clamp(1, diasMes);
        return (DateTime(y, m, inicio), DateTime(y, m, fin), 'Semana $_semana');
      case AnalisisVista.mensual:
        return (
          DateTime(y, m, 1),
          DateTime(y, m, diasMes),
          AnalisisPeriodoSelector.formatearRango(_mes),
        );
    }
  }

  Future<void> _cargar() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final (desde, hasta, label) = _rango();
      final data = await _service.calcular(
        desde: desde,
        hasta: hasta,
        periodoLabel: label,
      );
      if (!mounted) return;
      setState(() {
        _data = data;
        _loading = false;
      });
    } on PedidosException catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'No se pudo cargar el análisis.';
      });
    }
  }

  Future<void> _abrirMes() async {
    final picked = await AnalisisMesPicker.show(context, mesActual: _mes);
    if (picked == null || !mounted) return;
    setState(() {
      _mes = DateTime(picked.year, picked.month);
      _dia = 1;
      _semana = 1;
    });
    _cargar();
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
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(_error!, textAlign: TextAlign.center),
                              TextButton(
                                onPressed: _cargar,
                                child: const Text('Reintentar'),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _cargar,
                          color: AppColors.primary,
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AnalisisPeriodoSelector(
                                  mesSeleccionado: _mes,
                                  rangoTexto:
                                      AnalisisPeriodoSelector.formatearRango(
                                          _mes),
                                  onTapMes: _abrirMes,
                                ),
                                const SizedBox(height: AppSpacing.large),
                                AnalisisGranularidad(
                                  vista: _vista,
                                  mes: _mes,
                                  diaSeleccionado: _dia,
                                  semanaSeleccionada: _semana,
                                  onVistaChanged: (v) {
                                    setState(() => _vista = v);
                                    _cargar();
                                  },
                                  onDiaChanged: (d) {
                                    setState(() => _dia = d);
                                    _cargar();
                                  },
                                  onSemanaChanged: (s) {
                                    setState(() => _semana = s);
                                    _cargar();
                                  },
                                ),
                                const SizedBox(height: AppSpacing.extraLarge),
                                AnalisisIngresosCard(
                                  ingresos: _data?.ingresos ?? 0,
                                  variacionTexto: _data?.periodoLabel,
                                ),
                                const SizedBox(height: AppSpacing.extraLarge),
                                AnalisisMasVendidos(
                                  items: _data?.topVendidos ?? const [],
                                ),
                                const SizedBox(height: AppSpacing.extraLarge),
                                AnalisisVentasCategoria(
                                  items: _data?.categorias ?? const [],
                                ),
                              ],
                            ),
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
