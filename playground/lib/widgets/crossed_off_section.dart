import 'package:flutter/material.dart';
import 'package:playground/constants/theme.dart';
import 'package:playground/widgets/custom_button.dart';
import 'package:playground/widgets/section.dart';
import 'package:rough_notation/rough_notation.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class CrossedOffSection extends StatefulWidget {
  const CrossedOffSection({super.key});

  @override
  State<CrossedOffSection> createState() => _CrossedOffSectionState();
}

class _CrossedOffSectionState extends State<CrossedOffSection> {
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
      backgroundColor: kCrossSectionColor,
      children: [
        RoughCrossedOffAnnotation(
          controller: _controller,
          child: Text(
            'Crossed-Off',
            style: ShadTheme.of(
              context,
            ).textTheme.h3.copyWith(fontWeight: FontWeight.normal),
          ),
        ),

        SizedBox(height: 16),
        SelectableText.rich(
          TextSpan(
            text: 'To symbolize rejection, use a ',
            style: ShadTheme.of(
              context,
            ).textTheme.p.copyWith(fontSize: kBodyFontSize),
            children: [
              WidgetSpan(
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
                child: RoughCrossedOffAnnotation(
                  controller: _controller,
                  child: Text(
                    'crossed-off',
                    style: ShadTheme.of(
                      context,
                    ).textTheme.p.copyWith(fontSize: kBodyFontSize),
                  ),
                ),
              ),

              TextSpan(
                text: ' effect on a widget.',
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
