import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';

class DateRangePicker extends StatefulWidget {
  final void Function(DateTime?, DateTime?) onChanged;

  const DateRangePicker({super.key, required this.onChanged});

  @override
  State<DateRangePicker> createState() => _DateRangePickerState();
}

class _DateRangePickerState extends State<DateRangePicker> {
  DateTimeRange? _selectedDateRange;

  @override
  Widget build(BuildContext context) {
    return CustomCardButton(
      onPressed: () async {
        final DateTimeRange? selectedDate = await showDateRangePicker(
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
        widget.onChanged(selectedDate?.start, selectedDate?.end);
        setState(() {
          _selectedDateRange = selectedDate;
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
            _selectedDateRange == null
                ? "Seleccionar fecha"
                : "Desde ${formatDateToHumanDate(_selectedDateRange!.start)} hasta ${formatDateToHumanDate(_selectedDateRange!.end)}",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
