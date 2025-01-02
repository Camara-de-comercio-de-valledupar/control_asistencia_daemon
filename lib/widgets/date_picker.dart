import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';

class DatePicker extends StatefulWidget {
  final ValueChanged<DateTime> onChanged;

  const DatePicker({super.key, required this.onChanged});

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return CustomCardButton(
      onPressed: () async {
        final DateTime? selectedDate = await showDatePicker(
          context: context,
          firstDate: DateTime(2024),
          lastDate: DateTime(2025),
          builder: (context, child) {
            return Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  width: 400,
                  height: 400,
                  child: Theme(
                      data: ThemeData(
                        iconTheme: IconThemeData(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        colorScheme: ColorScheme.light(
                          surface: Theme.of(context).colorScheme.onPrimary,
                          onSurface: Theme.of(context).colorScheme.primary,
                          primary: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      child: child!),
                ),
              ),
            );
          },
        );
        widget.onChanged(selectedDate!);
        setState(() {
          _selectedDate = selectedDate;
        });
      },
      child: Row(
        children: [
          Icon(
            Icons.calendar_today,
            size: 30,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          const SizedBox(width: 10),
          Text(
            _selectedDate == null
                ? "Seleccionar fecha"
                : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
