import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../styles/app_colors.dart';
import '../../styles/app_radius.dart';
import '../../styles/app_text_styles.dart';

class RecuperarCodeInput extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onCompleted;

  const RecuperarCodeInput({
    super.key,
    required this.onChanged,
    this.onCompleted,
  });

  @override
  State<RecuperarCodeInput> createState() => _RecuperarCodeInputState();
}

class _RecuperarCodeInputState extends State<RecuperarCodeInput> {
  final int length = 6;
  final List<TextEditingController> _controllers = [];
  final List<FocusNode> _focusNodes = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < length; i++) {
      _controllers.add(TextEditingController());
      _focusNodes.add(FocusNode());
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onCodeChanged() {
    String code = _controllers.map((c) => c.text).join();
    widget.onChanged(code);
    if (code.length == length && widget.onCompleted != null) {
      widget.onCompleted!(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(length, (index) {
        final hasValue = _controllers[index].text.isNotEmpty;
        return SizedBox(
          width: 48,
          height: 56,
          child: TextFormField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: AppTextStyles.titleSmall.copyWith(
              color: AppColors.primary,
            ),
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: InputDecoration(
              hintText: '•',
              hintStyle: AppTextStyles.titleSmall.copyWith(
                color: AppColors.textPrimary,
              ),
              filled: true,
              fillColor: AppColors.surface,
              contentPadding: EdgeInsets.zero,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.medium),
                borderSide: BorderSide(
                  color: hasValue ? AppColors.primary : AppColors.border,
                  width: hasValue ? 1.5 : 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.medium),
                borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
            onChanged: (value) {
              setState(() {});
              if (value.isNotEmpty) {
                if (index < length - 1) {
                  _focusNodes[index + 1].requestFocus();
                } else {
                  _focusNodes[index].unfocus();
                }
              } else {
                if (index > 0) {
                  _focusNodes[index - 1].requestFocus();
                }
              }
              _onCodeChanged();
            },
          ),
        );
      }),
    );
  }
}