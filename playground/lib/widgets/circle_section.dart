import 'package:flutter/material.dart';
import 'package:playground/constants/theme.dart';
import 'package:playground/widgets/custom_button.dart';
import 'package:playground/widgets/section.dart';
import 'package:rough_notation/rough_notation.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class CircleSection extends StatefulWidget {
  const CircleSection({super.key});

  @override
  State<CircleSection> createState() => _CircleSectionState();
}

class _CircleSectionState extends State<CircleSection> {
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
      backgroundColor: kCircleSectionColor,
      children: [
        RoughCircleAnnotation(
          controller: _controller,
          child: Text(
            'Circle',
            style: ShadTheme.of(
              context,
            ).textTheme.h3.copyWith(fontWeight: FontWeight.normal),
          ),
        ),

        SizedBox(height: 16),
        SelectableText.rich(
          TextSpan(
            text: 'Draw a ',
            style: ShadTheme.of(
              context,
            ).textTheme.p.copyWith(fontSize: kBodyFontSize),
            children: [
              WidgetSpan(
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
                child: RoughCircleAnnotation(
                  controller: _controller,
                  child: Text(
                    'circle',
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
