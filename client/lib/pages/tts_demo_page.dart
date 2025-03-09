import 'package:flutter/material.dart';
import 'package:smart_prep/common/app_theme.dart';
import 'package:smart_prep/services/text_to_speech_service.dart';

class TtsDemoPage extends StatefulWidget {
  const TtsDemoPage({super.key});

  @override
  State<TtsDemoPage> createState() => _TtsDemoPageState();
}

class _TtsDemoPageState extends State<TtsDemoPage> {
  late TextToSpeechService _service;
  bool _playing = false;
  double _progress = 0.0;
  String text = """
This is a test paragraph for Text-to-Speech functionality.
""";

  @override
  void initState() {
    super.initState();
    _service = TextToSpeechService(onProgress: (progress) {
      setState(() {
        _progress = progress;
      });
    }, onComplete: () {
      setState(() {
        _playing = false;
        _progress = 1.0;
      });
    });
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: LinearProgressIndicator(
                value: _progress,
                backgroundColor: Colors.grey[300],
                color: AppTheme.gradient2,
                minHeight: 6,
              ),
            ),
            IconButton(
              onPressed: () {
                if (_playing) {
                  _service.pause();
                } else {
                  _service.speak(text);
                }
                setState(() {
                  _playing = !_playing;
                  if (!_playing) _progress = 0.0;
                });
              },
              icon: Icon(
                _playing ? Icons.pause : Icons.play_arrow,
                size: 50,
                color: AppTheme.gradient2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}