import 'package:flutter/material.dart';

import '../componentes/chat/chat_eva_header.dart';
import '../componentes/chat/chat_historial_drawer.dart';
import '../componentes/chat/chat_input_bar.dart';
import '../componentes/chat/chat_message_list.dart';
import '../services/chat_plantulas_service.dart';
import '../styles/app_colors.dart';

class ChatEvaPage extends StatefulWidget {
  const ChatEvaPage({super.key});

  @override
  State<ChatEvaPage> createState() => _ChatEvaPageState();
}

class _ChatEvaPageState extends State<ChatEvaPage> {
  final _controller = TextEditingController();
  final _scrollCtrl = ScrollController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late String _sesionId;
  bool _cargando = false;
  bool _histLoading = false;
  List<ChatMensaje> _mensajes = [];
  List<ChatSesionItem> _sesiones = [];

  @override
  void initState() {
    super.initState();
    _nuevaSesion(bienvenida: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _nuevaSesion({bool bienvenida = false}) {
    setState(() {
      _sesionId = 'serviplantulas_${DateTime.now().millisecondsSinceEpoch}';
      _mensajes = bienvenida
          ? [
              const ChatMensaje(
                texto:
                    '¡Hola! Soy EVA, la asistente de Serviplantulas. ¿En qué puedo ayudarte hoy?',
                esUsuario: false,
              ),
            ]
          : [];
    });
  }

  Future<void> _abrirHistorial() async {
    _scaffoldKey.currentState?.openEndDrawer();
    setState(() => _histLoading = true);
    try {
      final list = await ChatEvaService.listarSesiones();
      if (mounted) setState(() => _sesiones = list);
    } on ChatException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    } finally {
      if (mounted) setState(() => _histLoading = false);
    }
  }

  Future<void> _cargarSesion(ChatSesionItem s) async {
    Navigator.pop(context);
    setState(() => _cargando = true);
    try {
      final msgs = await ChatEvaService.obtenerHistorial(s.sesionId);
      if (!mounted) return;
      setState(() {
        _sesionId = s.sesionId;
        _mensajes = msgs; // oldest→newest; finales = más recientes
      });
      _scrollAlFinal();
    } on ChatException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  Future<void> _enviar() async {
    final texto = _controller.text.trim();
    if (texto.isEmpty || _cargando) return;
    setState(() {
      _mensajes = [..._mensajes, ChatMensaje(texto: texto, esUsuario: true)];
      _controller.clear();
      _cargando = true;
    });
    _scrollAlFinal();
    try {
      final r =
          await ChatEvaService.enviarMensaje(texto, sesionId: _sesionId);
      if (!mounted) return;
      setState(() {
        _mensajes = [..._mensajes, ChatMensaje(texto: r, esUsuario: false)];
      });
    } on ChatException catch (e) {
      if (!mounted) return;
      setState(() {
        _mensajes = [
          ..._mensajes,
          ChatMensaje(texto: e.message, esUsuario: false),
        ];
      });
    } finally {
      if (mounted) {
        setState(() => _cargando = false);
        _scrollAlFinal();
      }
    }
  }

  void _scrollAlFinal() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollCtrl.hasClients) return;
      _scrollCtrl.animateTo(
        _scrollCtrl.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      endDrawer: ChatHistorialDrawer(
        sesiones: _sesiones,
        loading: _histLoading,
        sesionActiva: _sesionId,
        onSeleccionar: _cargarSesion,
        onNueva: () {
          Navigator.pop(context);
          _nuevaSesion(bienvenida: true);
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            ChatEvaHeader(
              onBack: () => Navigator.pop(context),
              onHistorial: _abrirHistorial,
            ),
            Expanded(
              child: ChatMessageList(
                mensajes: _mensajes,
                cargando: _cargando,
                controller: _scrollCtrl,
              ),
            ),
            ChatInputBar(
              controller: _controller,
              cargando: _cargando,
              onEnviar: _enviar,
            ),
          ],
        ),
      ),
    );
  }
}
