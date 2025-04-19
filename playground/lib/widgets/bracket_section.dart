import 'package:flutter/material.dart';
import 'package:playground/constants/theme.dart';
import 'package:playground/widgets/custom_button.dart';
import 'package:playground/widgets/section.dart';
import 'package:rough_notation/rough_notation.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class BracketSection extends StatefulWidget {
  const BracketSection({super.key});

  @override
  State<BracketSection> createState() => _BracketSectionState();
}

class _BracketSectionState extends State<BracketSection> {
  late final RoughAnnotationController _controller;
  late final RoughAnnotationController _topController;

  @override
  void initState() {
    super.initState();
    _controller = RoughAnnotationController(autoPlay: false);
    _topController = RoughAnnotationController(autoPlay: false);
  }

  @override
  void dispose() {
    _controller.dispose();
    _topController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Section(
      backgroundColor: kBracketSectionColor,
      children: [
        RoughBracketAnnotation(
          brackets: ['top'],
          controller: _topController,
          duration: const Duration(milliseconds: 2000),
          child: Text(
            'Brackets',
            style: ShadTheme.of(
              context,
            ).textTheme.h3.copyWith(fontWeight: FontWeight.normal),
          ),
        ),

        SizedBox(height: 16),

        SelectableText(
          'Create a hand-drawn bracket around a block (like a paragraph of text) on one or multiple sides of the block.',
          style: ShadTheme.of(
            context,
          ).textTheme.p.copyWith(fontSize: kBodyFontSize),
        ),
        SizedBox(height: 16),

        RoughBracketAnnotation(
          controller: _controller,
          child: SelectableText(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed accumsan nisi hendrerit augue molestie tempus. Phasellus purus quam, aliquet nec commodo quis, pharetra ut orci. Donec laoreet ligula nisl, placerat molestie mauris luctus id. Fusce dapibus non libero nec lobortis. Nullam iaculis nisl ac eros consequat, sit amet placerat massa vulputate.",
            style: ShadTheme.of(
              context,
            ).textTheme.p.copyWith(fontSize: kBodyFontSize),
          ),
        ),

        SizedBox(height: 16),

        CustomButton(
          onPressed: () {
            _controller.show();
            _topController.show(Duration(milliseconds: 1000));
          },
        ),
      ],
    );
  }
}
