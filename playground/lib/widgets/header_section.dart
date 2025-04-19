import 'package:flutter/material.dart';
import 'package:playground/widgets/section.dart';
import 'package:rough_notation/rough_notation.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Section(
      children: [
        RoughHighlightAnnotation(
          child: Text(
            'Rough Notation Flutter',
            style: ShadTheme.of(context).textTheme.h1,
          ),
        ),
      ],
    );
  }
}
