import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../componentes/categorias/categoria_color_picker.dart';
import '../componentes/categorias/categoria_list_card.dart';
import '../componentes/compartidos/app_bar_simple.dart';
import '../models/categoria.dart';
import '../services/categorias_service.dart';
import '../services/productos_service.dart';
import '../styles/app_colors.dart';
import '../styles/app_text_styles.dart';
import 'agregar_categoria_page.dart';

class CategoriasPage extends StatefulWidget {
  const CategoriasPage({super.key});

  @override
  State<CategoriasPage> createState() => _CategoriasPageState();
}

class _CategoriasPageState extends State<CategoriasPage> {
  final _catService = CategoriasService();
  final _prodService = ProductosService();

  List<Categoria> _categorias = [];
  Map<int, int> _conteoProductos = {};
  Map<int, int> _colores = {};
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final cats = await _catService.listar();
      Map<int, int> conteo = {};
      try {
        final prods = await _prodService.listar();
        for (final p in prods) {
          if (p.idCategoria != null) {
            conteo[p.idCategoria!] = (conteo[p.idCategoria!] ?? 0) + 1;
          }
        }
      } catch (_) {}
      final prefs = await SharedPreferences.getInstance();
      final colores = <int, int>{};
      for (final c in cats) {
        colores[c.idCategoria] =
            (prefs.getInt('cat_color_${c.idCategoria}') ?? 0)
                .clamp(0, kCategoriaColores.length - 1);
      }
      if (!mounted) return;
      setState(() {
        _categorias = cats;
        _conteoProductos = conteo;
        _colores = colores;
        _loading = false;
      });
    } on CategoriasException catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'No se pudieron cargar las categorías.';
      });
    }
  }

  Future<void> _abrirForm({Categoria? categoria}) async {
    final ok = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => AgregarCategoriaPage(categoria: categoria),
      ),
    );
    if (ok == true) _cargar();
  }

  Future<void> _eliminar(Categoria c) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar categoría'),
        content: Text('¿Eliminar "${c.nombreCategoria}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await _catService.eliminar(c.idCategoria);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Categoría eliminada'),
          backgroundColor: AppColors.success,
        ),
      );
      _cargar();
    } on CategoriasException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message), backgroundColor: AppColors.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const AppBarSimple(title: 'Categorías'),
            Expanded(child: _body()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirForm(),
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _body() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              TextButton(onPressed: _cargar, child: const Text('Reintentar')),
            ],
          ),
        ),
      );
    }
    if (_categorias.isEmpty) {
      return Center(
        child: Text(
          'No hay categorías. Crea la primera.',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _cargar,
      color: AppColors.primary,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
        itemCount: _categorias.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final c = _categorias[i];
          final ci = _colores[c.idCategoria] ?? (i % kCategoriaColores.length);
          return CategoriaListCard(
            categoria: c,
            productosCount: _conteoProductos[c.idCategoria] ?? 0,
            iconBg: kCategoriaIconBg[ci],
            iconColor: kCategoriaColores[ci],
            onEdit: () => _abrirForm(categoria: c),
            onDelete: () => _eliminar(c),
          );
        },
      ),
    );
  }
}
