import 'package:flutter/material.dart';
import 'speech_to_text_app.dart';

class LevelPage extends StatelessWidget {
  final int level;

  LevelPage({required this.level});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Level $level'),
      ),
      body: Center(
        child: level == 1
            ? SpeechToTextApp()
            : Text('Content for Level $level is locked.'),
      ),
    );
  }
}
