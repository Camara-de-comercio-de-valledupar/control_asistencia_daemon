import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DNIField extends StatefulWidget {
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
  State<DNIField> createState() => _DNIFieldState();
}

class _DNIFieldState extends State<DNIField> {
  bool _userHasUsername = false;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: widget.style?.color ??
              Theme.of(context).inputDecorationTheme.hintStyle?.color,
        );
    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      decoration: widget.decoration ??
          InputDecoration(
            prefixIcon: Icon(
              _userHasUsername ? Icons.person : Icons.credit_card,
            ),
            suffix: TextButton(
                onPressed: () {
                  widget.controller?.clear();
                  setState(() {
                    _userHasUsername = !_userHasUsername;
                  });
                },
                child: const Text("¿Tienes usuario?")),
            hintText: _userHasUsername
                ? 'Ingrese su Usuario'
                : 'Ingrese su Cédula de Identidad',
          ),
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      style: textStyle,
      strutStyle: widget.strutStyle,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return _userHasUsername
              ? 'Por favor ingrese su usuario'
              : 'Por favor ingrese su cédula de identidad';
        }
        return null;
      },
      inputFormatters: _userHasUsername
          ? []
          : [
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
