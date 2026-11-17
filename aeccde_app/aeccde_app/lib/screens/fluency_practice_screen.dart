import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../providers/session_provider.dart';
import '../utils/practice_question_bank.dart';
import 'results_screen.dart';

class FluencyPracticeScreen extends StatefulWidget {
  const FluencyPracticeScreen({super.key});

  @override
  State<FluencyPracticeScreen> createState() => _FluencyPracticeScreenState();
}

class _FluencyPracticeScreenState extends State<FluencyPracticeScreen> {
  late String _currentTopic;

  @override
  void initState() {
    super.initState();
    _currentTopic = PracticeQuestionBank.getRandomFluencyTopic();
  }

  void _nextTopic() {
    setState(() {
      _currentTopic = PracticeQuestionBank.getRandomFluencyTopic();
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
          'Fluency Practice',
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
                    color: const Color(0xFFF1F8F1),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'FLUENCY CHALLENGE',
                            style: TextStyle(
                              color: Color(0xFF00BFA5),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF00BFA5), size: 20),
                            onPressed: _nextTopic,
                            tooltip: 'New Topic',
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '"$_currentTopic"',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Instruction Box
              FadeInDown(
                delay: const Duration(milliseconds: 200),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F2FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Text('✨ ', style: TextStyle(fontSize: 16)),
                      Expanded(
                        child: Text(
                          'Try speaking continuously for 60 seconds without long pauses or filler words.',
                          style: TextStyle(color: Color(0xFF534AE3), fontSize: 13, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Timer & Live Speech Box
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
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF00897B)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      sessionProvider.liveTranscript.isNotEmpty
                          ? sessionProvider.liveTranscript
                          : (isListening ? 'Listening to speech...' : 'Tap button below to start'),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: isListening ? Colors.black87 : Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Start Button
              SizedBox(
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
                    isListening ? 'Stop & Evaluate' : 'Start Practice',
                    style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isListening ? Colors.redAccent : const Color(0xFF00897B),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
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
