import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../providers/session_provider.dart';
import '../utils/practice_question_bank.dart';
import 'results_screen.dart';

class ConfidencePracticeScreen extends StatefulWidget {
  const ConfidencePracticeScreen({super.key});

  @override
  State<ConfidencePracticeScreen> createState() => _ConfidencePracticeScreenState();
}

class _ConfidencePracticeScreenState extends State<ConfidencePracticeScreen> {
  late String _currentChallenge;

  @override
  void initState() {
    super.initState();
    _currentChallenge = PracticeQuestionBank.getRandomConfidenceChallenge();
  }

  void _nextChallenge() {
    setState(() {
      _currentChallenge = PracticeQuestionBank.getRandomConfidenceChallenge();
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
          'Confidence Practice',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 16),
              
              // Header Card
              FadeInDown(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF4081), Color(0xFFE91E63)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        'Speak With Confidence',
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Own the conversation. Believe in your voice.',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Challenge Card
              FadeInDown(
                key: ValueKey(_currentChallenge),
                delay: const Duration(milliseconds: 200),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDEEF2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFFFE0E4)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'CHALLENGE',
                            style: TextStyle(color: Color(0xFFE91E63), fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1),
                          ),
                          IconButton(
                            icon: const Icon(Icons.refresh_rounded, color: Color(0xFFE91E63), size: 20),
                            onPressed: _nextChallenge,
                            tooltip: 'New Challenge',
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _currentChallenge,
                        style: const TextStyle(color: Color(0xFF1A1A1A), fontSize: 14, fontWeight: FontWeight.w600, height: 1.4),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Live Speech Box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FF),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    Text(
                      _formatTime(sessionProvider.elapsedSeconds),
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFFE91E63)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      sessionProvider.liveTranscript.isNotEmpty
                          ? sessionProvider.liveTranscript
                          : (isListening ? 'Listening to speech...' : 'Tap button below to start challenge'),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: isListening ? Colors.black87 : Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 28),
              
              // Start Button
              FadeInUp(
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final micGranted = await Permission.microphone.isGranted;
                      if (!micGranted) {
                        final status = await Permission.microphone.request();
                        if (!status.isGranted) return;
                      }

                      if (isListening) {
                        await sessionProvider.stopRecording();
                        if (mounted && sessionProvider.lastResult != null) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => ResultsScreen(result: sessionProvider.lastResult!)),
                          );
                        }
                      } else {
                        await sessionProvider.startRecording();
                      }
                    },
                    icon: Icon(isListening ? Icons.stop_rounded : Icons.play_arrow_rounded, color: Colors.white),
                    label: Text(
                      isListening ? 'Stop & Evaluate' : 'Start Challenge',
                      style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isListening ? Colors.redAccent : const Color(0xFFE91E63),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                  ),
                ),
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
