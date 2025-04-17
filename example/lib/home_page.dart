import 'package:flutter/material.dart';
import 'package:rough_notation/rough_notation.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rough Notation Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            RoughNotation(
              child: const Text(
                'Highlighted Text',
                style: TextStyle(fontSize: 24),
              ),
            ),

            const SizedBox(height: 20),

            RoughNotation(
              duration: const Duration(milliseconds: 1000),
              type: RoughNotationType.underline,
              child: const Text(
                'Underlined Text',
                style: TextStyle(fontSize: 24),
              ),
            ),

            const SizedBox(height: 20),
            RoughNotation(
              duration: const Duration(milliseconds: 1000),
              type: RoughNotationType.strikeThrough,
              child: const Text(
                'Strikethrough Text',
                style: TextStyle(fontSize: 24),
              ),
            ),

            const SizedBox(height: 20),
            RoughNotation(
              duration: const Duration(milliseconds: 1000),
              type: RoughNotationType.crossedOff,
              child: const Text(
                'Crossed Off Text',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
