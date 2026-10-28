import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../styles/app_colors.dart';
import '../../styles/app_text_styles.dart';

class VentaQtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const VentaQtyBtn({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(icon, size: 16, color: AppColors.primary),
      ),
    );
  }
}

/// Cantidad editable entre − y +.
class VentaQtyField extends StatefulWidget {
  final int value;
  final ValueChanged<int>? onChanged;

  const VentaQtyField({super.key, required this.value, this.onChanged});

  @override
  State<VentaQtyField> createState() => _VentaQtyFieldState();
}

class _VentaQtyFieldState extends State<VentaQtyField> {
  late final TextEditingController _ctrl;
  late final FocusNode _focus;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: '${widget.value}');
    _focus = FocusNode()
      ..addListener(() {
        if (!_focus.hasFocus) _aplicar();
      });
  }

  @override
  void didUpdateWidget(VentaQtyField old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value &&
        _ctrl.text != '${widget.value}' &&
        !_focus.hasFocus) {
      _ctrl.text = '${widget.value}';
    }
  }

  @override
  void dispose() {
    _focus.dispose();
    _ctrl.dispose();
    super.dispose();
  }

  void _aplicar() {
    final p = int.tryParse(_ctrl.text.trim());
    if (p == null) {
      _ctrl.text = '${widget.value}';
      return;
    }
    final v = p.clamp(1, 99999);
    _ctrl.text = '$v';
    if (v != widget.value) widget.onChanged?.call(v);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      child: TextField(
        controller: _ctrl,
        focusNode: _focus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(5),
        ],
        style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w700),
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 4),
        ),
        onSubmitted: (_) => _aplicar(),
      ),
    );
  }
}
