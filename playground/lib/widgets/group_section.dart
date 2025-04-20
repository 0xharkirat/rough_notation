import 'package:flutter/material.dart';
import 'package:playground/constants/theme.dart';
import 'package:playground/widgets/custom_button.dart';
import 'package:playground/widgets/section.dart';
import 'package:rough_notation/rough_notation.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class GroupSection extends StatelessWidget {
  const GroupSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Section(
      backgroundColor: kGroupSectionColor,
      children: [
        RoughBoxAnnotation(
          color: Colors.red,
          group: 'group',
          sequence: 3,

          child: Text(
            'Annotation Group',
            style: ShadTheme.of(
              context,
            ).textTheme.h3.copyWith(fontWeight: FontWeight.normal),
          ),
        ),

        SizedBox(height: 16),
        SelectableText.rich(
          TextSpan(
            text:
                'Rough Notation provides a way to order the animation of annotations by creating an ',
            style: ShadTheme.of(
              context,
            ).textTheme.p.copyWith(fontSize: kBodyFontSize),
            children: [
              WidgetSpan(
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
                child: RoughHighlightAnnotation(
                  group: 'group',
                  sequence: 1,

                  child: Text(
                    'Annotation Group',
                    style: ShadTheme.of(
                      context,
                    ).textTheme.p.copyWith(fontSize: kBodyFontSize),
                  ),
                ),
              ),

              TextSpan(
                text: ' Pass the list of annotations to create a group. When ',
                style: ShadTheme.of(
                  context,
                ).textTheme.p.copyWith(fontSize: kBodyFontSize),
              ),

              WidgetSpan(
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
                child: RoughUnderlineAnnotation(
                  group: 'group',
                  sequence: 2,

                  child: Text(
                    'show',
                    style: ShadTheme.of(
                      context,
                    ).textTheme.p.copyWith(fontSize: kBodyFontSize),
                  ),
                ),
              ),

              TextSpan(
                text:
                    ' is called on the group, the annotations are animated in order.',
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
            RoughAnnotationRegistry.showGroup('group');
          },
        ),
      ],
    );
  }
}
