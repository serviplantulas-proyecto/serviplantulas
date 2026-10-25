import '../componentes/analisis/analisis_mas_vendidos.dart';
import '../componentes/analisis/analisis_ventas_categoria.dart';
import '../componentes/ventas/factura_list_card.dart';
import 'facturas_service.dart';

class AnalisisResultado {
  final double ingresos;
  final List<TopVendidoItem> topVendidos;
  final List<CategoriaVentaItem> categorias;
  final String periodoLabel;

  const AnalisisResultado({
    required this.ingresos,
    required this.topVendidos,
    required this.categorias,
    required this.periodoLabel,
  });
}

class AnalisisService {
  final _facturas = FacturasService();

  /// [desde] inclusive, [hasta] exclusive end of day handled by caller.
  Future<AnalisisResultado> calcular({
    required DateTime desde,
    required DateTime hasta,
    required String periodoLabel,
  }) async {
    final todas = await _facturas.listar();
    final enRango = todas.where((f) {
      final dt = _parseFecha(f.fecha);
      if (dt == null) return false;
      return !dt.isBefore(desde) && dt.isBefore(hasta.add(const Duration(days: 1)));
    }).toList();

    final ingresos = enRango.fold<double>(0, (s, f) => s + f.total);

    // Top productos por monto
    final montoPorProducto = <String, double>{};
    for (final f in enRango) {
      for (final l in f.lineas) {
        montoPorProducto[l.nombre] =
            (montoPorProducto[l.nombre] ?? 0) + l.subtotal;
      }
    }
    final sortedProd = montoPorProducto.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final maxProd = sortedProd.isEmpty ? 1.0 : sortedProd.first.value;
    final top = sortedProd.take(5).map((e) {
      return TopVendidoItem(
        nombre: e.key,
        monto: e.value,
        porcentaje: maxProd == 0 ? 0 : (e.value / maxProd) * 100,
      );
    }).toList();

    // Por "categoría" usamos primer palabra del nombre o nombre completo
    // (sin tabla categoría en detalle). Agrupamos por prefijo simple.
    final montoCat = <String, double>{};
    for (final f in enRango) {
      for (final l in f.lineas) {
        final cat = _categoriaAprox(l.nombre);
        montoCat[cat] = (montoCat[cat] ?? 0) + l.subtotal;
      }
    }
    final sortedCat = montoCat.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final maxCat = sortedCat.isEmpty ? 1.0 : sortedCat.first.value;
    final cats = sortedCat.map((e) {
      return CategoriaVentaItem(
        nombre: e.key,
        monto: e.value,
        porcentaje: maxCat == 0 ? 0 : e.value / maxCat,
      );
    }).toList();

    return AnalisisResultado(
      ingresos: ingresos,
      topVendidos: top,
      categorias: cats,
      periodoLabel: periodoLabel,
    );
  }

  DateTime? _parseFecha(String fecha) {
    // Esperado: "12 Oct 2023" desde FacturasService
    const meses = {
      'Ene': 1, 'Feb': 2, 'Mar': 3, 'Abr': 4, 'May': 5, 'Jun': 6,
      'Jul': 7, 'Ago': 8, 'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dic': 12,
    };
    final parts = fecha.split(' ');
    if (parts.length < 3) return null;
    final d = int.tryParse(parts[0]);
    final m = meses[parts[1]];
    final y = int.tryParse(parts[2]);
    if (d == null || m == null || y == null) return null;
    return DateTime(y, m, d);
  }

  String _categoriaAprox(String nombre) {
    // Heurística ligera hasta tener id_categoria en el detalle
    final n = nombre.toLowerCase();
    if (n.contains('helecho') || n.contains('ficus') || n.contains('monstera')) {
      return 'Plantas de interior';
    }
    if (n.contains('abono') || n.contains('fertiliz') || n.contains('sustrato')) {
      return 'Insumos';
    }
    if (n.contains('maceta')) return 'Macetas y accesorios';
    return 'Otros productos';
  }
}
