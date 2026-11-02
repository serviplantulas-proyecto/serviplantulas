import 'package:flutter/services.dart';

/// Teléfono CO: solo dígitos, máx. 10.
List<TextInputFormatter> get phone10Formatters => [
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(10),
    ];

/// Enteros ≥ 0 (stock, cantidades, documentos).
List<TextInputFormatter> get nonNegativeIntFormatters => [
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(12),
    ];

/// Decimales ≥ 0 (precios). Sin signo negativo.
List<TextInputFormatter> get nonNegativeDecimalFormatters => [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
      _SingleDotFormatter(),
      LengthLimitingTextInputFormatter(15),
    ];

class _SingleDotFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final t = newValue.text;
    if (t.contains('-')) return oldValue;
    if ('.'.allMatches(t).length > 1) return oldValue;
    return newValue;
  }
}
