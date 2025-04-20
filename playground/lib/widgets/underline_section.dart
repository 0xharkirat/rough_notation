import 'package:flutter/material.dart';
import 'package:playground/constants/theme.dart';
import 'package:playground/widgets/custom_button.dart';
import 'package:playground/widgets/section.dart';
import 'package:rough_notation/rough_notation.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class UnderlineSection extends StatefulWidget {
  const UnderlineSection({super.key});

  @override
  State<UnderlineSection> createState() => _UnderlineSectionState();
}

class _UnderlineSectionState extends State<UnderlineSection> {
  late final RoughAnnotationController _underlineController;

  @override
  void initState() {
    _underlineController = RoughAnnotationController(autoPlay: false);
    super.initState();
  }

  @override
  void dispose() {
    _underlineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Section(
      backgroundColor: kUnderLineSectionColor,
      children: [
        RoughUnderlineAnnotation(
          controller: _underlineController,
          child: Text(
            'Underline',
            style: ShadTheme.of(
              context,
            ).textTheme.h3.copyWith(fontWeight: FontWeight.normal),
          ),
        ),

        SizedBox(height: 16),
        SelectableText.rich(
          TextSpan(
            text: 'Create a sketchy ',
            style: ShadTheme.of(
              context,
            ).textTheme.p.copyWith(fontSize: kBodyFontSize),
            children: [
              WidgetSpan(
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
                child: RoughUnderlineAnnotation(
                  controller: _underlineController,
                  child: Text(
                    'underline',
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
            _underlineController.show();
          },
        ),
      ],
    );
  }
}
