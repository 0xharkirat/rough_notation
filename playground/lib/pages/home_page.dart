import 'package:flutter/material.dart';
import 'package:playground/widgets/box_section.dart';
import 'package:playground/widgets/bracket_section.dart';
import 'package:playground/widgets/circle_section.dart';
import 'package:playground/widgets/crossed_off_section.dart';
import 'package:playground/widgets/group_section.dart';
import 'package:playground/widgets/highlight_section.dart';
import 'package:playground/widgets/no_animation_section.dart';
import 'package:playground/widgets/strikethrough_section.dart';
import 'package:playground/widgets/styling_section.dart';
import 'package:playground/widgets/underline_section.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          
          children: [
            UnderlineSection(),
            BoxSection(),
            CircleSection(),
            HighlightSection(),
            StrikethroughSection(),
            CrossedOffSection(),
            BracketSection(),
            GroupSection(),
            StylingSection(),
            NoAnimationSection(),

            
          ],
        ),
      ),
    );
  }
}
