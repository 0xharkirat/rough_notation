import 'package:example/sub_test_widget.dart';
import 'package:flutter/material.dart';
import 'package:rough_notation/rough_notation.dart';

class AnnotationTestPage extends StatefulWidget {
  const AnnotationTestPage({super.key});

  @override
  State<AnnotationTestPage> createState() => _AnnotationTestPageState();
}

class _AnnotationTestPageState extends State<AnnotationTestPage> {
  final _underlineController = RoughAnnotationController(
    autoPlay: true,
    delay: const Duration(seconds: 2),
  );

  @override
  void initState() {
    super.initState();

    // Auto-start the 'demo' group
    RoughAnnotationRegistry.markGroupForAutoStart(
      'demo',
      delayBetween: const Duration(microseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Annotation Group Test')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RoughBracketAnnotation(
              brackets: ['left', 'right'], // or ['top'], ['bottom'], etc.
              child: Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                'Sed accumsan nisi hendrerit augue molestie tempus...',
                style: TextStyle(fontSize: 18),
              ),
            ),

            const SizedBox(height: 20),
            RoughUnderlineAnnotation(
              controller: _underlineController,
              delay: const Duration(seconds: 2),
              child: const Text("Manually Triggered Underline"),
            ),

            const SizedBox(height: 20),
            //
            Text("Standalone demo", style: TextStyle(fontSize: 24)),
            const SizedBox(height: 24),

            RoughStrikethroughAnnotation(
              child: const Text(
                "Standalone Strikethrough",
                style: TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(height: 24),

            Text("Annotation group demo", style: TextStyle(fontSize: 24)),
            const SizedBox(height: 24),
            RoughStrikethroughAnnotation(
              group: 'demo',
              sequence: 2,
              child: const Text(
                "Step 2: Strikethrough",
                style: TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(height: 24),
            RoughUnderlineAnnotation(
              controller: _underlineController,
              group: 'demo',
              sequence: 1,
              delay: Duration(seconds: 2), // This should be ignored in group
              child: const Text(
                "Step 1: Underline (should not delay)",
                style: TextStyle(fontSize: 20),
              ),
            ),

            const SizedBox(height: 24),
            RoughBoxAnnotation(
              group: 'demo',
              sequence: 3,
              child: const Text("Step 3: Box", style: TextStyle(fontSize: 24)),
            ),
            const SizedBox(height: 24),
            RoughCrossedOffAnnotation(
              group: 'demo',
              sequence: 4,
              child: const Text(
                "Step 4: Crossed Off",
                style: TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(height: 40),

            RoughCircleAnnotation(
              child: Text("Look at me!", style: TextStyle(fontSize: 24)),
            ),

            const SizedBox(height: 20),
            RoughHighlightAnnotation(
              child: const Text(
                "Highlight me!",
                style: TextStyle(fontSize: 24),
              ),
            ),

            // SubTestWidget(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // RoughAnnotationRegistry.showGroup('demo');
          _underlineController.show();
        },
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}
