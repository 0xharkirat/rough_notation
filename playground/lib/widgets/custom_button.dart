import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.onPressed, this.text});
  final VoidCallback onPressed;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      mouseCursor: SystemMouseCursors.click,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: ShadTheme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        child: Text(
          text?.toUpperCase() ?? 'ANNOTATE',
          style: ShadTheme.of(context).textTheme.p,
        ),
      ),
    );
  }
}
