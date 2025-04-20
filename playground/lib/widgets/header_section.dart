import 'package:flutter/material.dart';
import 'package:playground/constants/theme.dart';
import 'package:playground/widgets/custom_button.dart';
import 'package:playground/widgets/section.dart';
import 'package:rough_notation/rough_notation.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:textf/textf.dart';
import 'package:url_launcher/url_launcher.dart';

class HeaderSection extends StatefulWidget {
  const HeaderSection({super.key});

  @override
  State<HeaderSection> createState() => _HeaderSectionState();
}

class _HeaderSectionState extends State<HeaderSection> {
  @override
  void initState() {
    super.initState();
    RoughAnnotationRegistry.markGroupForAutoStart('header');
  }

  ///
  Future<void> _launchUrl(String url) async {
    final Uri url0 = Uri.parse(url);
    if (!await launchUrl(url0)) {
      throw Exception('Could not launch $url0');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Section(
      backgroundColor: Colors.white,
      children: [
        RoughHighlightAnnotation(
          group: 'header',
          sequence: 1,
          child: Text(
            'Rough Notation Flutter',
            style: ShadTheme.of(
              context,
            ).textTheme.h1.copyWith(fontWeight: FontWeight.normal),
          ),
        ),

        SizedBox(height: 16),
        SelectableText.rich(
          TextSpan(
            text:
                'A lightweight Flutter package to create animated, hand-drawn-style ',
            style: ShadTheme.of(
              context,
            ).textTheme.p.copyWith(fontSize: kBodyFontSize),
            children: [
              WidgetSpan(
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
                child: RoughBoxAnnotation(
                  color: Colors.red,
                  group: 'header',
                  sequence: 2,

                  child: Text(
                    'annotations',
                    style: ShadTheme.of(
                      context,
                    ).textTheme.p.copyWith(fontSize: kBodyFontSize),
                  ),
                ),
              ),

              TextSpan(
                text: ' on widgets.',
                style: ShadTheme.of(
                  context,
                ).textTheme.p.copyWith(fontSize: kBodyFontSize),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        SelectableText.rich(
          TextSpan(
            text: 'This package recreates the original ',
            style: ShadTheme.of(
              context,
            ).textTheme.p.copyWith(fontSize: kBodyFontSize),
            children: [
              WidgetSpan(
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
                child: RoughUnderlineAnnotation(
                  color: Colors.blue,
                  group: 'header',
                  sequence: 3,

                  child: InkWell(
                    onTap: () {
                      // https://roughnotation.com/
                      _launchUrl("https://roughnotation.com/");
                    },
                    child: Textf(
                      '**Rough Notation**',
                      style: ShadTheme.of(
                        context,
                      ).textTheme.p.copyWith(fontSize: kBodyFontSize),
                    ),
                  ),
                ),
              ),

              TextSpan(
                text: ' experience created by ',
                style: ShadTheme.of(
                  context,
                ).textTheme.p.copyWith(fontSize: kBodyFontSize),
              ),

              WidgetSpan(
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
                child: RoughCircleAnnotation(
                  color: Colors.green,
                  group: 'header',
                  sequence: 4,

                  child: InkWell(
                    onTap: () {
                      //https://x.com/preetster
                      _launchUrl("https://x.com/preetster");
                    },
                    child: Textf(
                      '***Preet Shihn***',
                      style: ShadTheme.of(
                        context,
                      ).textTheme.p.copyWith(fontSize: kBodyFontSize),
                    ),
                  ),
                ),
              ),

              TextSpan(
                text: ' and ',
                style: ShadTheme.of(
                  context,
                ).textTheme.p.copyWith(fontSize: kBodyFontSize),
              ),

              WidgetSpan(
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
                child: RoughBracketAnnotation(
                  color: Colors.orange,
                  group: 'header',
                  sequence: 5,
                  padding: 4.0,

                  child: InkWell(
                    onTap: () {
                      // https://github.com/rough-stuff/rough-notation/graphs/contributors
                      _launchUrl(
                        "https://github.com/rough-stuff/rough-notation/graphs/contributors",
                      );
                    },
                    child: Textf(
                      '*contributors*.',
                      style: ShadTheme.of(
                        context,
                      ).textTheme.p.copyWith(fontSize: kBodyFontSize),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 16),

        Textf(
          'It uses Flutter’s **CustomPainter** to render the annotations, supporting config options for styling and animation — including manual triggers, sequencing via groups, and autoplay.',
          style: ShadTheme.of(
            context,
          ).textTheme.p.copyWith(fontSize: kBodyFontSize),
        ),

        SizedBox(height: 16),

        CustomButton(
          text: "View on GitHub",
          onPressed: () {
            _launchUrl("https://github.com/0xharkirat/rough_notation");
          },
        ),
        SizedBox(height: 16),
        CustomButton(onPressed: () {
          _launchUrl("https://pub.dev/packages/rough_notation");
        }, text: "View on Pub.dev"),

        SizedBox(height: 32),

        Textf(
          "Following are the different styles of annotations. Hit the **annotate** button in each section to see the animated annotation",
          style: ShadTheme.of(
            context,
          ).textTheme.p.copyWith(fontSize: kBodyFontSize),
        ),
      ],
    );
  }
}
