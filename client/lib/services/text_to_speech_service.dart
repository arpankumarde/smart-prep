import 'package:flutter_tts/flutter_tts.dart';

typedef ProgressCallback = void Function(double progress);
typedef CompletionCallback = void Function();

class TextToSpeechService {
  final FlutterTts flutterTts = FlutterTts();
  final ProgressCallback onProgress;
  final CompletionCallback onComplete;

  TextToSpeechService({required this.onProgress, required this.onComplete}) {
    flutterTts.setCompletionHandler(() {
      onComplete();
    });

    flutterTts.setProgressHandler((String text, int start, int end, String word) {
      onProgress(start / text.length);
    });
    changeVoice();
  }

  void speak(String text) async {
    if (text.isNotEmpty) {
      await flutterTts.speak(text);
    }
  }

  void pause() async {
    await flutterTts.pause();
  }

  void dispose() async {
    await flutterTts.stop();
  }

  void changeVoice() async {
    await flutterTts.setVoice({"name": "Karen", "locale": "en-AU"});
  }
}
