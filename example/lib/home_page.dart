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

            
            const SizedBox(height: 20),
            RoughUnderlineAnnotation(
              strokeWidth: 2.5,
            
              child: Text("Underline me!", style: TextStyle(fontSize: 24)),
            ),
            const SizedBox(height: 20),
            RoughStrikethroughAnnotation(
              strokeWidth: 2.5,
              duration: Duration(milliseconds: 2000),
              child: Text('Strike me out!', style: TextStyle(fontSize: 24)),
            ),
            const SizedBox(height: 20),
            RoughCrossedOffAnnotation(
              strokeWidth: 2.5,
              duration: const Duration(milliseconds: 2000),

              child: Text('Cross me off!', style: TextStyle(fontSize: 24)),
            ),

            const SizedBox(height: 20),
            RoughBoxAnnotation(
              strokeWidth: 2.5,
              duration: const Duration(milliseconds: 2000),
              child: const Text('Boxed Annotation!', style: TextStyle(fontSize: 24)),
            ),

            const SizedBox(height: 20),
            
          ],
        ),
      ),
    );
  }
}
