import 'package:flutter/material.dart';
import 'package:playground/constants/theme.dart';
import 'package:playground/widgets/custom_button.dart';
import 'package:playground/widgets/section.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:textf/textf.dart';
import 'package:url_launcher/url_launcher.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

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
        SizedBox(height: 32),

        Textf(
          'All the code and documentation is available on GitHub.',
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
        CustomButton(
          onPressed: () {
            _launchUrl("https://pub.dev/packages/rough_notation");
          },
          text: "View on Pub.dev",
        ),

        SizedBox(height: 16),

        TextfOptions(
          onUrlTap: (url, displayText) {
            _launchUrl(url);
          },
          urlStyle: ShadTheme.of(context).textTheme.p.copyWith(
            fontSize: kBodyFontSize,
            color: Colors.blueAccent,
          ),
          child: Textf(
            'Reach out on Twitter/X [**@0xharkirat**](https://x.com/0xharkirat)',
            style: ShadTheme.of(
              context,
            ).textTheme.p.copyWith(fontSize: kBodyFontSize),
          ),
        ),

        SizedBox(height: 32),

        Textf(
          'I/we acknowledge the original creators and contributors of the **Rough Notation** JS library — including the website design, colors, and overall inspiration.',
          style: ShadTheme.of(
            context,
          ).textTheme.p.copyWith(fontSize: kBodyFontSize),
        ),

        SizedBox(height: 16),

        Textf(
          "Grateful for the open-source community and everyone who shares their work so generously. ",
          style: ShadTheme.of(
            context,
          ).textTheme.p.copyWith(fontSize: kBodyFontSize),
        ),
      ],
    );
  }
}
