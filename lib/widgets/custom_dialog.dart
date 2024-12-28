import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomDialog extends StatelessWidget {
  final double? width;
  final double? height;
  final Widget child;
  final String title;
  final IconData? titleIcon;
  final Map<Widget, VoidCallback>? actions;

  const CustomDialog(
      {super.key,
      this.width,
      this.height,
      required this.child,
      required this.title,
      this.titleIcon,
      this.actions});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: width,
        height: height,
        child: Material(
          color: Theme.of(context).dialogBackgroundColor,
          child: LayoutBuilder(builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  child,
                  const SizedBox(height: 20),
                  _buildActions(context)
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    var actions = this.actions?.entries.toList();
    if (actions == null) {
      return const SizedBox.shrink();
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: actions
          .map((e) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: ElevatedButton(onPressed: e.value.call, child: e.key),
              ))
          .toList(),
    );
  }

  Container _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Icon(titleIcon ?? FontAwesomeIcons.solidSquarePlus,
              size: 30, color: Theme.of(context).colorScheme.onPrimary),
          const SizedBox(width: 10),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
          ),
        ],
      ),
    );
  }
}
