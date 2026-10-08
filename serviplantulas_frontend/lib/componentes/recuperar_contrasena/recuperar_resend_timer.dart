import 'dart:async';
import 'package:flutter/material.dart';
import '../../styles/app_colors.dart';
import '../../styles/app_text_styles.dart';

class RecuperarResendTimer extends StatefulWidget {
  final VoidCallback onResend;
  final int initialSeconds;

  const RecuperarResendTimer({
    super.key,
    required this.onResend,
    this.initialSeconds = 60,
  });

  @override
  State<RecuperarResendTimer> createState() => _RecuperarResendTimerState();
}

class _RecuperarResendTimerState extends State<RecuperarResendTimer> {
  late int _seconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _seconds = widget.initialSeconds;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        setState(() => _seconds--);
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_seconds > 0) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Reenviar código en ',
            style: AppTextStyles.bodySmall,
          ),
          Text(
            '00:${_seconds.toString().padLeft(2, '0')}',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.accent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    }

    return Center(
      child: GestureDetector(
        onTap: () {
          _startTimer();
          widget.onResend();
        },
        child: Text(
          '¿No recibiste el código? Reenviar',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.accent,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}