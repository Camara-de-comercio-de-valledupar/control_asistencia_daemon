import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DNIField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  const DNIField(
      {super.key,
      this.controller,
      this.focusNode,
      this.decoration,
      this.keyboardType,
      this.textInputAction,
      this.style,
      this.strutStyle});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: style?.color ??
              Theme.of(context).inputDecorationTheme.hintStyle?.color,
        );
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      decoration: decoration ??
          const InputDecoration(
            prefixIcon: Icon(Icons.person),
            hintText: 'Ingrese su Cédula de Identidad',
          ),
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      style: textStyle,
      strutStyle: strutStyle,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingrese su DNI';
        }
        return null;
      },
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
        DNIInputFormatter(),
      ],
    );
  }
}

class DNIInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // 1234567890 => 1.234.567.890
    // 49775730 => 49.775.730
    // 123456789 => 123.456.789

    final text = newValue.text.replaceAll(RegExp(r'[.]'), '');

    // Hacer split de cada 3 caracteres de reverso
    final List<String> split = text.split('').reversed.toList();
    final List<String> result = [];
    for (var i = 0; i < split.length; i++) {
      if (i % 3 == 0 && i != 0) {
        result.add('.');
      }
      result.add(split[i]);
    }

    return TextEditingValue(
      text: result.reversed.join(''),
      selection: TextSelection.collapsed(offset: result.length),
    );
  }
}
