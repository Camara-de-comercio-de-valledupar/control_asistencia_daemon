import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextStyle? style;
  final StrutStyle? strutStyle;

  const PasswordField(
      {super.key,
      this.controller,
      this.focusNode,
      this.decoration,
      this.keyboardType,
      this.textInputAction,
      this.style,
      this.strutStyle});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: widget.style?.color ??
              Theme.of(context).inputDecorationTheme.hintStyle?.color,
        );
    InputDecoration decoration = widget.decoration ?? const InputDecoration();
    decoration = decoration.copyWith(
      prefixIcon: const Icon(Icons.lock),
      suffixIcon: _passwordVisible
          ? IconButton(
              icon: const Icon(Icons.visibility),
              onPressed: () {
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              },
            )
          : IconButton(
              icon: const Icon(Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              },
            ),
      hintText: widget.decoration?.hintText ?? 'Ingrese su contraseña',
    );
    return TextFormField(
      style: textStyle,
      obscureText: !_passwordVisible,
      decoration: decoration,
      strutStyle: widget.strutStyle,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: widget.textInputAction,
      controller: widget.controller,
      focusNode: widget.focusNode,
    );
  }
}
