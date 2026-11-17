import 'dart:async';

import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

/// Thin wrapper around `speech_to_text` that exposes a simple
/// start/stop API plus broadcast streams for the live transcript and
/// listening state, so the UI layer never touches the plugin directly.
class SpeechService {
  SpeechService._();
  static final SpeechService instance = SpeechService._();

  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isInitialized = false;

  final StreamController<String> _transcriptController = StreamController.broadcast();
  final StreamController<bool> _listeningController = StreamController.broadcast();

  Stream<String> get transcriptStream => _transcriptController.stream;
  Stream<bool> get listeningStream => _listeningController.stream;

  String _lastTranscript = '';
  DateTime? _startedAt;

  Future<bool> initialize() async {
    final micStatus = await Permission.microphone.request();
    if (!micStatus.isGranted) return false;

    _isInitialized = await _speech.initialize(
      onStatus: (status) {
        _listeningController.add(status == 'listening');
      },
      onError: (error) {
        _listeningController.add(false);
      },
    );
    return _isInitialized;
  }

  Future<void> startListening() async {
    if (!_isInitialized) {
      final ok = await initialize();
      if (!ok) return;
    }
    _lastTranscript = '';
    _startedAt = DateTime.now();
    await _speech.listen(
      onResult: (result) {
        _lastTranscript = result.recognizedWords;
        _transcriptController.add(_lastTranscript);
      },
      listenFor: const Duration(minutes: 5),
      pauseFor: const Duration(seconds: 8),
      partialResults: true,
      cancelOnError: false,
      listenMode: stt.ListenMode.dictation,
    );
    _listeningController.add(true);
  }

  Future<String> stopListening() async {
    await _speech.stop();
    _listeningController.add(false);
    return _lastTranscript;
  }

  int get elapsedSeconds {
    if (_startedAt == null) return 0;
    return DateTime.now().difference(_startedAt!).inSeconds;
  }

  bool get isAvailable => _speech.isAvailable;

  void dispose() {
    _transcriptController.close();
    _listeningController.close();
  }
}
