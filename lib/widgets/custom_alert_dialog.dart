import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final Map<Widget, VoidCallback>? actions;

  const CustomAlertDialog(
      {super.key, required this.title, required this.content, this.actions});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.3,
        child: Material(
          color: Theme.of(context).dialogBackgroundColor,
          child: LayoutBuilder(builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(context),
                  content,
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

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
                fontSize: 24.0,
              ),
        ),
        if (actions != null)
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
      ],
    );
  }
}
