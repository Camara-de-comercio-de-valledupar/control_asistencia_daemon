import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CurrencyInput extends StatefulWidget {
  final String labelText;
  final ValueChanged<int>? onChanged;
  final int? initialValue;
  const CurrencyInput(
      {super.key, required this.labelText, this.onChanged, this.initialValue});

  @override
  State<CurrencyInput> createState() => _CurrencyInputState();
}

class _CurrencyInputState extends State<CurrencyInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      _controller.text = currencyFormat(widget.initialValue!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final foregroundColor = Theme.of(context).colorScheme.onPrimary;

    return TextFormField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: widget.labelText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixText: "\$",
        prefixStyle: TextStyle(color: foregroundColor),
      ),
      onChanged: (value) {
        if (value.isEmpty) {
          widget.onChanged?.call(0);
          return;
        }
        var parsedValue = currencyParse(value);
        widget.onChanged?.call(parsedValue);
      },
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
        CurrencyTextFieldFormatter(),
      ],
    );
  }
}

class CurrencyTextFieldFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final intValue = currencyParse(newValue.text);
    final newText = currencyFormat(intValue);
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class UppercaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
