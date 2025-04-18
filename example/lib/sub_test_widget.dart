import 'package:flutter/material.dart';
import 'package:rough_notation/rough_notation.dart';

class SubTestWidget extends StatelessWidget {
  const SubTestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RoughStrikethroughAnnotation(
          group: 'demo',
          sequence: 6,
          child: const Text(
            "Step 6: Strikethrough",
            style: TextStyle(fontSize: 24),
          ),
        ),
        const SizedBox(height: 24),
        RoughUnderlineAnnotation(
          group: 'demo',
          sequence: 5,
          child: const Text(
            "Step 5: Underline",
            style: TextStyle(fontSize: 24),
          ),
        ),
        const SizedBox(height: 24),
        RoughBoxAnnotation(
          group: 'demo',
          sequence: 7,
          child: const Text("Step 7: Box", style: TextStyle(fontSize: 24)),
        ),
        const SizedBox(height: 24),
        RoughCrossedOffAnnotation(
          group: 'demo',
          sequence: 8,
          child: const Text(
            "Step 8: Crossed Off",
            style: TextStyle(fontSize: 24),
          ),
        ),
      ],
    );
  }
}
