import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../models/environment_model.dart';
import '../providers/session_provider.dart';
import '../services/evaluation_engine.dart';
import 'results_screen.dart';

class PronunciationPracticeScreen extends StatefulWidget {
  const PronunciationPracticeScreen({super.key});

  @override
  State<PronunciationPracticeScreen> createState() => _PronunciationPracticeScreenState();
}

class _PronunciationPracticeScreenState extends State<PronunciationPracticeScreen> {
  int currentWordIndex = 0;

  final List<Map<String, String>> words = [
    {'word': 'Communication', 'phonetic': '/kəˌmju:nɪˈkeɪʃən/'},
    {'word': 'Articulation', 'phonetic': '/ɑ:ˌtɪkjʊˈleɪʃən/'},
    {'word': 'Persuasive', 'phonetic': '/pəˈsweɪsɪv/'},
    {'word': 'Confidence', 'phonetic': '/ˈkɒnfɪdəns/'},
  ];

  @override
  Widget build(BuildContext context) {
    final sessionProvider = context.watch<SessionProvider>();
    final isListening = sessionProvider.state == RecordingState.listening;
    final current = words[currentWordIndex];

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
          'Pronunciation Practice',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              // Progress Indicator
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: List.generate(
                    words.length,
                    (index) => Expanded(
                      child: Container(
                        height: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: index <= currentWordIndex ? const Color(0xFF534AE3) : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Target Word Section
              FadeInDown(
                key: ValueKey(currentWordIndex),
                child: Column(
                  children: [
                    const Text(
                      'Repeat After AI',
                      style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      current['word']!,
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      current['phonetic']!,
                      style: const TextStyle(fontSize: 16, color: Colors.grey, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Your Live Recording
              Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FF),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    Text(
                      isListening ? 'Recording voice...' : 'Speech Transcript',
                      style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      sessionProvider.liveTranscript.isNotEmpty
                          ? sessionProvider.liveTranscript
                          : (isListening ? 'Listening...' : 'Tap Record button below to speak'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF534AE3)),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Record Button
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final micGranted = await Permission.microphone.isGranted;
                    if (!micGranted) {
                      final status = await Permission.microphone.request();
                      if (!status.isGranted) return;
                    }

                    if (isListening) {
                      await sessionProvider.stopRecording();
                      final text = sessionProvider.liveTranscript.isNotEmpty
                          ? sessionProvider.liveTranscript
                          : current['word']!;
                      
                      final result = EvaluationEngine.instance.evaluate(
                        transcript: text,
                        durationSeconds: 15,
                        environment: EnvironmentModel.byId('conversation'),
                      );

                      await sessionProvider.addManualEvaluation(
                        result: result,
                        environment: EnvironmentModel.byId('conversation'),
                      );

                      if (mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ResultsScreen(result: result)),
                        );
                      }
                    } else {
                      await sessionProvider.startRecording();
                    }
                  },
                  icon: Icon(isListening ? Icons.stop_rounded : Icons.mic_rounded, color: Colors.white),
                  label: Text(
                    isListening ? 'Stop & Evaluate' : 'Record Voice',
                    style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isListening ? Colors.redAccent : const Color(0xFF534AE3),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              TextButton(
                onPressed: () {
                  setState(() {
                    currentWordIndex = (currentWordIndex + 1) % words.length;
                  });
                },
                child: const Text('Next Word →', style: TextStyle(color: Color(0xFF534AE3), fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
