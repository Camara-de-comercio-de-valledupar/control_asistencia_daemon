import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CapacitySelector extends StatefulWidget {
  final ValueChanged<int>? onChanged;
  final int? initialValue;
  const CapacitySelector({super.key, this.onChanged, this.initialValue});

  @override
  State<CapacitySelector> createState() => _CapacitySelectorState();
}

class _CapacitySelectorState extends State<CapacitySelector> {
  int _capacity = 0;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      _capacity = widget.initialValue!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).colorScheme.primary;
    final foregroundColor = Theme.of(context).colorScheme.onPrimary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Capacidad",
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: backgroundColor,
              ),
        ),
        const SizedBox(height: 10),
        Container(
          width: 350,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(0),
          ),
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  child: Icon(FontAwesomeIcons.chevronLeft,
                      color: foregroundColor),
                  onTap: () {
                    if (_capacity > 0) {
                      setState(() {
                        _capacity--;
                      });
                    }
                    widget.onChanged?.call(_capacity);
                  },
                ),
              ),
              Text(
                "$_capacity Personas",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: foregroundColor,
                      fontSize: 20,
                    ),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  child: Icon(FontAwesomeIcons.chevronRight,
                      color: foregroundColor),
                  onTap: () {
                    setState(() {
                      _capacity++;
                    });
                    widget.onChanged?.call(_capacity);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
