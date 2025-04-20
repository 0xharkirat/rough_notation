import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:playground/pages/home_page.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ShadApp(
      debugShowCheckedModeBanner: false,
      title: 'RoughNotation Flutter',
      themeMode: ThemeMode.light,
      theme: ShadThemeData(
        colorScheme: ShadNeutralColorScheme.light(),
        brightness: Brightness.light,
        textTheme: ShadTextTheme.fromGoogleFont(GoogleFonts.manrope),
      ),
      home: const HomePage(),
    );
  }
}
