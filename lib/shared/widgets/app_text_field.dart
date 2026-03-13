import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum AppTextFieldType {
  text,
  number,
  phone,
  currency,
  password,
  multiline,
}

class AppTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? helperText;
  final TextEditingController? controller;
  final AppTextFieldType type;
  final bool isRequired;
  final bool isRTL;
  final Widget? prefix;
  final Widget? suffix;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final String? errorText;
  final bool readOnly;
  final int? maxLines;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;

  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.controller,
    this.type = AppTextFieldType.text,
    this.isRequired = false,
    this.isRTL = true,
    this.prefix,
    this.suffix,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.errorText,
    this.readOnly = false,
    this.maxLines,
    this.maxLength,
    this.textInputAction,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      crossAxisAlignment: isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            isRequired ? '$label *' : label!,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: errorText != null ? cs.error : cs.onSurface,
            ),
            textAlign: isRTL ? TextAlign.right : TextAlign.left,
          ),
          const SizedBox(height: 8),
        ],
        TextField(
          controller: controller,
          focusNode: focusNode,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          onTap: onTap,
          readOnly: readOnly,
          maxLines: type == AppTextFieldType.multiline ? (maxLines ?? 3) : 1,
          minLines: type == AppTextFieldType.multiline ? 2 : 1,
          maxLength: maxLength,
          textAlign: isRTL ? TextAlign.right : TextAlign.left,
          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
          obscureText: type == AppTextFieldType.password,
          keyboardType: _getKeyboardType(),
          inputFormatters: _getInputFormatters(),
          textInputAction: textInputAction,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: readOnly ? cs.onSurface.withOpacity(0.5) : cs.onSurface,
          ),
          decoration: InputDecoration(
            hintText: hint,
            helperText: helperText,
            errorText: errorText,
            prefixIcon: prefix,
            suffixIcon: suffix,
          ),
        ),
      ],
    );
  }

  TextInputType _getKeyboardType() {
    switch (type) {
      case AppTextFieldType.number:
      case AppTextFieldType.currency:
        return TextInputType.number;
      case AppTextFieldType.phone:
        return TextInputType.phone;
      case AppTextFieldType.multiline:
        return TextInputType.multiline;
      case AppTextFieldType.text:
      case AppTextFieldType.password:
        return TextInputType.text;
    }
  }

  List<TextInputFormatter>? _getInputFormatters() {
    switch (type) {
      case AppTextFieldType.number:
      case AppTextFieldType.currency:
        return [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
        ];
      case AppTextFieldType.phone:
        return [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10),
        ];
      default:
        return null;
    }
  }
}
