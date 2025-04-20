import 'package:flutter/material.dart';

class Section extends StatelessWidget {
  const Section({
    super.key,
    this.backgroundColor,
    required this.children,
    this.maxContentWidth = 640,
    this.outerPadding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 40,
    ),
    this.initialInnerPadding = 320,
  });

  final Color? backgroundColor;
  final List<Widget> children;
  final double maxContentWidth;
  final EdgeInsets outerPadding;
  final double initialInnerPadding;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final windowWidth = constraints.maxWidth;

        final double targetWidth =
            maxContentWidth + 2 * initialInnerPadding + outerPadding.horizontal;

        // Adjust innerPadding if window is smaller than target layout width
        final double computedInnerPadding =
            windowWidth > targetWidth
                ? initialInnerPadding
                : ((windowWidth - maxContentWidth - outerPadding.horizontal) /
                        2)
                    .clamp(0, initialInnerPadding);

        return Container(
          color: backgroundColor,
          width: double.infinity,
          padding: outerPadding,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: computedInnerPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        );
      },
    );
  }
}
