import 'package:control_asistencia_daemon/lib.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class CustomDropdownSearch<T> extends StatelessWidget {
  const CustomDropdownSearch({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
    this.value,
  });

  final String label;
  final List<T> items;
  final T? value;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
              ),
        ),
        const SizedBox(height: 5),
        CustomCard(
          enablePadding: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: DropdownSearch<T>(
              dropdownBuilder: (context, selectedItem) {
                return Text(
                  selectedItem?.toString() ?? label,
                  style: Theme.of(context).textTheme.bodyMedium,
                );
              },
              selectedItem: value,
              items: (_, __) => items,
              onChanged: onChanged,
              popupProps: PopupProps.menu(
                showSearchBox: true,
                searchFieldProps: TextFieldProps(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
