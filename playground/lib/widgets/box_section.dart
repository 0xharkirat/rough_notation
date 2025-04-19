import 'package:flutter/material.dart';
import 'package:playground/constants/theme.dart';
import 'package:playground/widgets/custom_button.dart';
import 'package:playground/widgets/section.dart';
import 'package:rough_notation/rough_notation.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class BoxSection extends StatefulWidget {
  const BoxSection({super.key});

  @override
  State<BoxSection> createState() => _BoxSectionState();
}

class _BoxSectionState extends State<BoxSection> {
  late final RoughAnnotationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = RoughAnnotationController(autoPlay: false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Section(
      backgroundColor: kBoxSectionColor,
      children: [
        RoughBoxAnnotation(
          controller: _controller,
          child: Text(
            'Box',
            style: ShadTheme.of(
              context,
            ).textTheme.h3.copyWith(fontWeight: FontWeight.normal),
          ),
        ),

        SizedBox(height: 16),
        SelectableText.rich(
          TextSpan(
            text: 'This style draws a ',
            style: ShadTheme.of(
              context,
            ).textTheme.p.copyWith(fontSize: kBodyFontSize),
            children: [
              WidgetSpan(
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
                child: RoughBoxAnnotation(
                  controller: _controller,
                  child: Text(
                    'box',
                    style: ShadTheme.of(
                      context,
                    ).textTheme.p.copyWith(fontSize: kBodyFontSize),
                  ),
                ),
              ),

              TextSpan(
                text: ' around any widget in your app.',
                style: ShadTheme.of(
                  context,
                ).textTheme.p.copyWith(fontSize: kBodyFontSize),
              ),
            ],
          ),
        ),

        SizedBox(height: 16),

        CustomButton(
          onPressed: () {
            _controller.show();
          },
        ),
      ],
    );
  }
}
