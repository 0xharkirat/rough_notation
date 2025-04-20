import 'package:flutter/material.dart';
import 'package:playground/constants/theme.dart';
import 'package:playground/widgets/custom_button.dart';
import 'package:playground/widgets/section.dart';
import 'package:rough_notation/rough_notation.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class HighlightSection extends StatefulWidget {
  const HighlightSection({super.key});

  @override
  State<HighlightSection> createState() => _HighlightSectionState();
}

class _HighlightSectionState extends State<HighlightSection> {
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
      backgroundColor: kHighlightSectionColor,
      children: [
        RoughHighlightAnnotation(
          controller: _controller,
          child: Text(
            'Highlight',
            style: ShadTheme.of(
              context,
            ).textTheme.h3.copyWith(fontWeight: FontWeight.normal),
          ),
        ),

        SizedBox(height: 16),
        SelectableText.rich(
          TextSpan(
            text: 'Create a highlighted effect as if marked by a ',
            style: ShadTheme.of(
              context,
            ).textTheme.p.copyWith(fontSize: kBodyFontSize),
            children: [
              WidgetSpan(
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
                child: RoughHighlightAnnotation(
                  controller: _controller,
                  child: Text(
                    'highlighter',
                    style: ShadTheme.of(
                      context,
                    ).textTheme.p.copyWith(fontSize: kBodyFontSize),
                  ),
                ),
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
