import 'dart:io';

import 'package:flutter/material.dart';

import '../../models/categoria.dart';
import '../../models/proveedor.dart';
import '../../styles/app_spacing.dart';
import 'producto_image_selector.dart';
import 'widgets.dart';

/// Formulario de alta/edición de producto.
class RegistrarProductoForm extends StatelessWidget {
  final File? imagen;
  final String? imagenUrl;
  final bool ocultarImagenUrl;
  final bool isLoading;
  final TextEditingController nombreCtrl;
  final TextEditingController precioCompraCtrl;
  final TextEditingController precioVentaCtrl;
  final TextEditingController descCtrl;
  final TextEditingController stockMinimoCtrl;
  final int stockInicial;
  final ValueChanged<int> onStockChanged;
  final List<Categoria> categorias;
  final List<Proveedor> proveedores;
  final Categoria? categoriaSel;
  final Proveedor? proveedorSel;
  final ValueChanged<Categoria> onCategoriaChanged;
  final ValueChanged<Proveedor> onProveedorChanged;
  final ValueChanged<File> onImagenSeleccionada;
  final VoidCallback onQuitarImagen;
  final VoidCallback onGuardar;

  const RegistrarProductoForm({
    super.key,
    required this.imagen,
    required this.imagenUrl,
    required this.ocultarImagenUrl,
    required this.isLoading,
    required this.nombreCtrl,
    required this.precioCompraCtrl,
    required this.precioVentaCtrl,
    required this.descCtrl,
    required this.stockMinimoCtrl,
    required this.stockInicial,
    required this.onStockChanged,
    required this.categorias,
    required this.proveedores,
    required this.categoriaSel,
    required this.proveedorSel,
    required this.onCategoriaChanged,
    required this.onProveedorChanged,
    required this.onImagenSeleccionada,
    required this.onQuitarImagen,
    required this.onGuardar,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductoImageSelector(
            imagen: imagen,
            imagenUrl: ocultarImagenUrl ? null : imagenUrl,
            habilitado: !isLoading,
            onImagenSeleccionada: onImagenSeleccionada,
            onQuitar: onQuitarImagen,
          ),
          const SizedBox(height: AppSpacing.large),
          ProductoCampoTexto(
            label: 'Nombre del Producto',
            controller: nombreCtrl,
            hint: 'Ej. Monstera Deliciosa',
          ),
          const SizedBox(height: AppSpacing.large),
          if (categorias.isNotEmpty)
            ProductoDropdownField(
              label: 'Categoría',
              value: categoriaSel?.nombreCategoria ??
                  categorias.first.nombreCategoria,
              options: categorias.map((c) => c.nombreCategoria).toList(),
              onChanged: (nombre) {
                final match = categorias.firstWhere(
                  (c) => c.nombreCategoria == nombre,
                );
                onCategoriaChanged(match);
              },
            ),
          const SizedBox(height: AppSpacing.large),
          Row(
            children: [
              Expanded(
                child: ProductoCampoTexto(
                  label: 'Precio compra',
                  controller: precioCompraCtrl,
                  hint: '0',
                  keyboard: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ProductoCampoTexto(
                  label: 'Precio venta',
                  controller: precioVentaCtrl,
                  hint: '0',
                  keyboard: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.large),
          Row(
            children: [
              Expanded(
                child: ProductoCampoTexto(
                  label: 'Stock mínimo',
                  controller: stockMinimoCtrl,
                  hint: '5',
                  keyboard: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ProductoCampoStock(
                  value: stockInicial,
                  onChanged: onStockChanged,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.large),
          if (proveedores.isNotEmpty)
            ProductoDropdownField(
              label: 'Proveedor',
              value: proveedorSel?.nombreProveedor ??
                  proveedores.first.nombreProveedor,
              options: proveedores.map((p) => p.nombreProveedor).toList(),
              onChanged: (nombre) {
                final match = proveedores.firstWhere(
                  (p) => p.nombreProveedor == nombre,
                );
                onProveedorChanged(match);
              },
            ),
          const SizedBox(height: AppSpacing.large),
          ProductoCampoTexto(
            label: 'Descripción',
            controller: descCtrl,
            hint: 'Descripción del producto...',
            maxLines: 3,
          ),
          const SizedBox(height: AppSpacing.extraLarge),
          ProductoBotonGuardar(
            isLoading: isLoading,
            onPressed: onGuardar,
          ),
        ],
      ),
    );
  }
}
