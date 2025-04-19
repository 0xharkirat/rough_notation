import 'package:flutter/material.dart';
import 'package:playground/constants/theme.dart';
import 'package:playground/widgets/custom_button.dart';
import 'package:playground/widgets/section.dart';
import 'package:rough_notation/rough_notation.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class StrikethroughSection extends StatefulWidget {
  const StrikethroughSection({super.key});

  @override
  State<StrikethroughSection> createState() => _StrikethroughSectionState();
}

class _StrikethroughSectionState extends State<StrikethroughSection> {
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
      backgroundColor: kStrikeSectionColor,
      children: [
        RoughStrikethroughAnnotation(
          controller: _controller,
          child: Text(
            'Strike-Through',
            style: ShadTheme.of(
              context,
            ).textTheme.h3.copyWith(fontWeight: FontWeight.normal),
          ),
        ),

        SizedBox(height: 16),
        SelectableText.rich(
          TextSpan(
            text: 'Draw a hand-drawn line through the widget creating a ',
            style: ShadTheme.of(
              context,
            ).textTheme.p.copyWith(fontSize: kBodyFontSize),
            children: [
              WidgetSpan(
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
                child: RoughStrikethroughAnnotation(
                  controller: _controller,
                  child: Text(
                    'stroke-through',
                    style: ShadTheme.of(
                      context,
                    ).textTheme.p.copyWith(fontSize: kBodyFontSize),
                  ),
                ),
              ),

              TextSpan(
                text: ' effect.',
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
