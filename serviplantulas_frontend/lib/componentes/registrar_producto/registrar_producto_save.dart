import 'package:flutter/material.dart';
import 'dart:io';

import '../../models/categoria.dart';
import '../../models/producto.dart';
import '../../models/proveedor.dart';
import '../../services/productos_service.dart';

class RegistrarProductoSaveData {
  final String nombre;
  final double precioVenta;
  final double? precioCompra;
  final int stockMin;
  final String? error;

  const RegistrarProductoSaveData({
    required this.nombre,
    required this.precioVenta,
    required this.precioCompra,
    required this.stockMin,
    this.error,
  });
}

RegistrarProductoSaveData parseRegistrarProductoForm({
  required String nombre,
  required String precioVentaText,
  required String precioCompraText,
  required String stockMinText,
  required Categoria? categoriaSel,
}) {
  final n = nombre.trim();
  final precioVenta =
      double.tryParse(precioVentaText.replaceAll(',', '.')) ?? -1;
  final precioCompra =
      double.tryParse(precioCompraText.replaceAll(',', '.'));
  final stockMin = int.tryParse(stockMinText.trim()) ?? 0;

  if (n.isEmpty) {
    return RegistrarProductoSaveData(
      nombre: n,
      precioVenta: precioVenta,
      precioCompra: precioCompra,
      stockMin: stockMin,
      error: 'El nombre es obligatorio',
    );
  }
  if (precioVenta < 0) {
    return RegistrarProductoSaveData(
      nombre: n,
      precioVenta: precioVenta,
      precioCompra: precioCompra,
      stockMin: stockMin,
      error: 'Ingresa un precio de venta válido',
    );
  }
  if (categoriaSel == null) {
    return RegistrarProductoSaveData(
      nombre: n,
      precioVenta: precioVenta,
      precioCompra: precioCompra,
      stockMin: stockMin,
      error: 'Selecciona una categoría',
    );
  }
  return RegistrarProductoSaveData(
    nombre: n,
    precioVenta: precioVenta,
    precioCompra: precioCompra,
    stockMin: stockMin,
  );
}

Future<void> ejecutarGuardarProducto({
  required ProductosService service,
  required bool esEdicion,
  required int? idProducto,
  required RegistrarProductoSaveData data,
  required int stockInicial,
  required Categoria categoriaSel,
  required Proveedor? proveedorSel,
  required String descripcion,
  required File? imagen,
}) async {
  if (esEdicion) {
    final campos = <String, String>{
      'nombre_producto': data.nombre,
      'precio_producto': data.precioVenta.toString(),
      'stock': stockInicial.toString(),
      'stock_minimo': data.stockMin.toString(),
      'id_categoria': categoriaSel.idCategoria.toString(),
    };
    if (data.precioCompra != null) {
      campos['costo_compra'] = data.precioCompra.toString();
    }
    if (descripcion.trim().isNotEmpty) {
      campos['descripcion_producto'] = descripcion.trim();
    }
    if (proveedorSel != null) {
      campos['id_proveedor'] = proveedorSel.idProveedor.toString();
    }
    await service.actualizar(
      id: idProducto!,
      campos: campos,
      imagen: imagen,
    );
  } else {
    await service.crear(
      nombreProducto: data.nombre,
      descripcionProducto:
          descripcion.trim().isEmpty ? null : descripcion.trim(),
      precioProducto: data.precioVenta,
      costoCompra: data.precioCompra,
      stock: stockInicial,
      stockMinimo: data.stockMin,
      idCategoria: categoriaSel.idCategoria,
      idProveedor: proveedorSel?.idProveedor,
      imagen: imagen,
    );
  }
}

({Categoria? categoria, Proveedor? proveedor}) resolverSeleccionesProducto({
  required List<Categoria> categorias,
  required List<Proveedor> proveedores,
  required int? idCategoria,
  required int? idProveedor,
}) {
  Categoria? catSel;
  Proveedor? provSel;
  if (idCategoria != null) {
    final match = categorias.where((c) => c.idCategoria == idCategoria);
    if (match.isNotEmpty) catSel = match.first;
  }
  catSel ??= categorias.isNotEmpty ? categorias.first : null;

  if (idProveedor != null) {
    final match = proveedores.where((x) => x.idProveedor == idProveedor);
    if (match.isNotEmpty) provSel = match.first;
  }
  provSel ??= proveedores.isNotEmpty ? proveedores.first : null;
  return (categoria: catSel, proveedor: provSel);
}


void aplicarProductoEnFormulario({
  required Producto? producto,
  required TextEditingController nombreCtrl,
  required TextEditingController precioVentaCtrl,
  required TextEditingController precioCompraCtrl,
  required TextEditingController descCtrl,
  required TextEditingController stockMinimoCtrl,
  required void Function(int) setStock,
}) {
  if (producto == null) return;
  nombreCtrl.text = producto.nombreProducto;
  precioVentaCtrl.text = producto.precioProducto.toStringAsFixed(0);
  if (producto.costoCompra != null) {
    precioCompraCtrl.text = producto.costoCompra!.toStringAsFixed(0);
  }
  descCtrl.text = producto.descripcionProducto ?? '';
  stockMinimoCtrl.text = producto.stockMinimo.toString();
  setStock(producto.stock);
}
