import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EmailField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final String? suffixText;

  const EmailField(
      {super.key,
      this.controller,
      this.focusNode,
      this.decoration,
      this.keyboardType,
      this.textInputAction,
      this.style,
      this.strutStyle,
      this.suffixText = "@ccvalledupar.org.co"});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: style?.color ??
              Theme.of(context).inputDecorationTheme.hintStyle?.color,
        );
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      style: textStyle,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.email),
        hintText: 'Ingrese su usuario institucional',
        suffixText: suffixText,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingrese su usuario institucional';
        }
        return null;
      },
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
      ],
    );
  }
}
