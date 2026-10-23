import 'package:flutter/material.dart';

import '../componentes/boton/app_button.dart';
import '../componentes/clientes/cliente_form_fields.dart';
import '../componentes/compartidos/app_bar_simple.dart';
import '../models/cliente.dart';
import '../services/clientes_service.dart';
import '../styles/app_colors.dart';
import '../styles/app_spacing.dart';

class AgregarClientePage extends StatefulWidget {
  final Cliente? cliente;

  const AgregarClientePage({super.key, this.cliente});

  @override
  State<AgregarClientePage> createState() => _AgregarClientePageState();
}

class _AgregarClientePageState extends State<AgregarClientePage> {
  final _service = ClientesService();
  final _nombreCtrl = TextEditingController();
  final _docCtrl = TextEditingController();
  final _telCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _dirCtrl = TextEditingController();
  bool _esCedula = true;
  bool _isLoading = false;

  bool get _esEdicion => widget.cliente != null;

  @override
  void initState() {
    super.initState();
    final c = widget.cliente;
    if (c == null) return;
    _nombreCtrl.text = c.nombreCliente;
    _docCtrl.text = c.cedulaCliente ?? '';
    _telCtrl.text = (c.telefonoCliente ?? '').replaceFirst('+57 ', '');
    _emailCtrl.text = c.correoCliente ?? '';
    _dirCtrl.text = c.direccionCliente ?? '';
    _esCedula = c.tipoDocumento != 'NIT';
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _docCtrl.dispose();
    _telCtrl.dispose();
    _emailCtrl.dispose();
    _dirCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    final nombre = _nombreCtrl.text.trim();
    final tel = _telCtrl.text.trim();
    if (nombre.isEmpty || tel.isEmpty) {
      _snack('Nombre y teléfono son obligatorios', error: true);
      return;
    }
    setState(() => _isLoading = true);
    try {
      final doc = _docCtrl.text.trim();
      final email = _emailCtrl.text.trim();
      final dir = _dirCtrl.text.trim();
      final telFull = tel.startsWith('+') ? tel : tel;
      if (_esEdicion) {
        await _service.actualizar(
          id: widget.cliente!.idCliente,
          campos: {
            'nombre_cliente': nombre,
            'telefono_cliente': telFull,
            'correo_cliente': email,
            'direccion_cliente': dir,
            'cedula_cliente': doc,
          },
        );
        if (!mounted) return;
        _snack('Cliente actualizado');
      } else {
        await _service.crear(
          nombreCliente: nombre,
          telefonoCliente: telFull,
          correoCliente: email.isEmpty ? null : email,
          direccionCliente: dir.isEmpty ? null : dir,
          cedulaCliente: doc.isEmpty ? null : doc,
        );
        if (!mounted) return;
        _snack('Cliente guardado');
      }
      Navigator.pop(context, true);
    } on ClientesException catch (e) {
      if (mounted) _snack(e.message, error: true);
    } catch (_) {
      if (mounted) _snack('Error al guardar', error: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _snack(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: error ? AppColors.error : AppColors.success,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            AppBarSimple(
              title: _esEdicion ? 'Editar Cliente' : 'Agregar Cliente',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ClienteFormLabel('Nombre Completo'),
                    ClienteFormField(
                      controller: _nombreCtrl,
                      hint: 'Ej. Juan Carlos Pérez',
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: AppSpacing.large),
                    const ClienteFormLabel('Documento de Identidad'),
                    ClienteTipoDocToggle(
                      esCedula: _esCedula,
                      onChanged: (v) => setState(() => _esCedula = v),
                    ),
                    const SizedBox(height: 8),
                    ClienteFormField(
                      controller: _docCtrl,
                      hint: 'Número de documento (sin puntos)',
                      keyboard: TextInputType.number,
                    ),
                    const SizedBox(height: AppSpacing.large),
                    const ClienteFormLabel('Teléfono Móvil'),
                    ClienteFormField(
                      controller: _telCtrl,
                      hint: '300 123 4567',
                      prefix: '+57 ',
                      keyboard: TextInputType.phone,
                    ),
                    const SizedBox(height: AppSpacing.large),
                    const ClienteFormLabel('Correo Electrónico'),
                    ClienteFormField(
                      controller: _emailCtrl,
                      hint: 'correo@ejemplo.com',
                      icon: Icons.email_outlined,
                      keyboard: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: AppSpacing.large),
                    const ClienteFormLabel('Dirección de Envío'),
                    ClienteFormField(
                      controller: _dirCtrl,
                      hint: 'Calle, Carrera, Barrio, Ciudad',
                      icon: Icons.location_on_outlined,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              decoration: const BoxDecoration(
                color: AppColors.background,
                border: Border(
                  top: BorderSide(color: AppColors.border, width: 0.5),
                ),
              ),
              child: AppButton(
                text: 'Guardar Cliente',
                icon: Icons.check,
                isLoading: _isLoading,
                onPressed: _guardar,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
