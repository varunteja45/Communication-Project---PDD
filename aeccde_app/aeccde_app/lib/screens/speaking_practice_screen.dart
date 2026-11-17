import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../providers/session_provider.dart';
import '../utils/practice_question_bank.dart';
import 'results_screen.dart';

class SpeakingPracticeScreen extends StatefulWidget {
  const SpeakingPracticeScreen({super.key});

  @override
  State<SpeakingPracticeScreen> createState() => _SpeakingPracticeScreenState();
}

class _SpeakingPracticeScreenState extends State<SpeakingPracticeScreen> {
  late String _currentTopic;

  @override
  void initState() {
    super.initState();
    _currentTopic = PracticeQuestionBank.getRandomSpeakingTopic();
  }

  void _nextTopic() {
    setState(() {
      _currentTopic = PracticeQuestionBank.getRandomSpeakingTopic();
    });
  }

  @override
  Widget build(BuildContext context) {
    final sessionProvider = context.watch<SessionProvider>();
    final isListening = sessionProvider.state == RecordingState.listening;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Speaking Practice',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 16),
              
              // Topic Card
              FadeInDown(
                key: ValueKey(_currentTopic),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F2FF),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Text('✨ ', style: TextStyle(fontSize: 16)),
                              Text(
                                "PRACTICE TOPIC",
                                style: TextStyle(
                                  color: Color(0xFF534AE3),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF534AE3), size: 20),
                            onPressed: _nextTopic,
                            tooltip: 'New Topic',
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '"$_currentTopic"',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Speak into the microphone. Try to stay on topic.',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Timer
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isListening ? const Color(0xFFEDEEFC) : Colors.white,
                  border: Border.all(
                    color: isListening ? const Color(0xFF534AE3) : Colors.grey.shade200,
                    width: 3,
                  ),
                ),
                child: Center(
                  child: Text(
                    _formatTime(sessionProvider.elapsedSeconds),
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Transcript Box
              Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FF),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Text(
                  sessionProvider.liveTranscript.isNotEmpty
                      ? sessionProvider.liveTranscript
                      : (isListening ? 'Recording voice... speak clearly.' : 'Tap mic below to start recording.'),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: isListening ? Colors.black87 : Colors.grey, fontSize: 14),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Record Button
              GestureDetector(
                onTap: () async {
                  final micGranted = await Permission.microphone.isGranted;
                  if (!micGranted) {
                    final status = await Permission.microphone.request();
                    if (!status.isGranted) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Microphone permission is required to record audio.'),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      }
                      return;
                    }
                  }

                  if (isListening) {
                    await sessionProvider.stopRecording();
                    if (mounted && sessionProvider.lastResult != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ResultsScreen(result: sessionProvider.lastResult!),
                        ),
                      );
                    }
                  } else {
                    await sessionProvider.startRecording();
                  }
                },
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: isListening ? Colors.redAccent : const Color(0xFF534AE3),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (isListening ? Colors.redAccent : const Color(0xFF534AE3)).withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    isListening ? Icons.stop_rounded : Icons.mic_rounded,
                    color: Colors.white,
                    size: 34,
                  ),
                ),
              ),
              
              const SizedBox(height: 10),
              Text(
                isListening ? 'Tap to Stop & Evaluate' : 'Tap microphone to start',
                style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500),
              ),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
