import 'package:flutter/material.dart';
import 'package:playground/constants/theme.dart';
import 'package:playground/widgets/custom_button.dart';
import 'package:playground/widgets/section.dart';
import 'package:rough_notation/rough_notation.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class StylingSection extends StatefulWidget {
  const StylingSection({super.key});

  @override
  State<StylingSection> createState() => _StylingSectionState();
}

class _StylingSectionState extends State<StylingSection> {
  late final RoughAnnotationController _controller;
  late final RoughAnnotationController _slowController;

  @override
  void initState() {
    super.initState();
    _controller = RoughAnnotationController(autoPlay: false);
    _slowController = RoughAnnotationController(autoPlay: false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Section(
      backgroundColor: kConfigSectionColor,
      children: [
        RoughBoxAnnotation(
          controller: _controller,
          color: Colors.red,
          strokeWidth: 6,
          child: Text(
            'Annotation Styling',
            style: ShadTheme.of(
              context,
            ).textTheme.h3.copyWith(fontWeight: FontWeight.normal),
          ),
        ),

        SizedBox(height: 16),
        SelectableText.rich(
          TextSpan(
            text:
                'Various properties of the annotation can be configured, like color, strokeWidth, ',
            style: ShadTheme.of(
              context,
            ).textTheme.p.copyWith(fontSize: kBodyFontSize),
            children: [
              WidgetSpan(
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
                child: RoughBoxAnnotation(
                  color: Colors.green[900] ?? Colors.green,
                  duration: const Duration(milliseconds: 4500),
                  controller: _slowController,
                  child: Text(
                    'animation duration.',
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
            _slowController.show();
          },
        ),
      ],
    );
  }
}
