import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../models/environment_model.dart';
import '../providers/session_provider.dart';
import '../services/evaluation_engine.dart';
import 'results_screen.dart';

class VocabularyPracticeScreen extends StatefulWidget {
  const VocabularyPracticeScreen({super.key});

  @override
  State<VocabularyPracticeScreen> createState() => _VocabularyPracticeScreenState();
}

class _VocabularyPracticeScreenState extends State<VocabularyPracticeScreen> {
  final TextEditingController _controller = TextEditingController();
  int currentWordIndex = 0;

  final List<Map<String, dynamic>> words = [
    {
      'word': 'Eloquent',
      'level': 'ADVANCED',
      'definition': 'Fluent or persuasive in speaking or writing',
      'example': '"She gave an eloquent speech that moved the audience."',
      'synonyms': ['articulate', 'expressive', 'fluent', 'persuasive'],
      'gradient': [const Color(0xFFFF9100), const Color(0xFFFF6D00)],
    },
    {
      'word': 'Resilient',
      'level': 'INTERMEDIATE',
      'definition': 'Able to withstand or recover quickly from difficult conditions',
      'example': '"He remained resilient throughout the tough interview process."',
      'synonyms': ['strong', 'tough', 'adaptable', 'flexible'],
      'gradient': [const Color(0xFF534AE3), const Color(0xFF7A6FFF)],
    },
    {
      'word': 'Meticulous',
      'level': 'ADVANCED',
      'definition': 'Showing great attention to detail; very careful and precise',
      'example': '"Her meticulous presentation left no question unanswered."',
      'synonyms': ['precise', 'thorough', 'scrupulous', 'accurate'],
      'gradient': [const Color(0xFF00BFA5), const Color(0xFF00ACC1)],
    },
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _nextWord() {
    setState(() {
      currentWordIndex = (currentWordIndex + 1) % words.length;
      _controller.clear();
    });
  }

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
          'Vocabulary Practice',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              
              // Main Word Card
              FadeInDown(
                key: ValueKey(currentWordIndex),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: current['gradient'] as List<Color>,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Column(
                    children: [
                      Text(
                        current['level'] as String,
                        style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        current['word'] as String,
                        style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        current['definition'] as String,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Example Sentence
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF9F0),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFFFE0B2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Example Sentence',
                      style: TextStyle(color: Color(0xFFE65100), fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      current['example'] as String,
                      style: const TextStyle(color: Color(0xFF5D4037), fontSize: 14, fontStyle: FontStyle.italic, height: 1.4),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              const Text(
                'SYNONYMS',
                style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (current['synonyms'] as List<String>).map((s) => _buildSynonymChip(s)).toList(),
              ),
              
              const SizedBox(height: 24),
              
              // Speaking/Writing Challenge Box
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F2FF),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Vocabulary Challenge',
                      style: TextStyle(color: Color(0xFF534AE3), fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Use "${current['word']}" in your own sentence.',
                      style: const TextStyle(color: Color(0xFF1A1A1A), fontSize: 13),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _controller,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: isListening
                            ? 'Listening... speak your sentence now'
                            : 'Type or speak a sentence using "${current['word']}"...',
                        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: const EdgeInsets.all(14),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                      ),
                    ),
                    if (sessionProvider.liveTranscript.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Live Speech: ${sessionProvider.liveTranscript}',
                        style: const TextStyle(color: Color(0xFF534AE3), fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Buttons Row
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 54,
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final micGranted = await Permission.microphone.isGranted;
                          if (!micGranted) {
                            final status = await Permission.microphone.request();
                            if (!status.isGranted) return;
                          }

                          if (isListening) {
                            await sessionProvider.stopRecording();
                            if (sessionProvider.liveTranscript.isNotEmpty) {
                              _controller.text = sessionProvider.liveTranscript;
                            }
                          } else {
                            await sessionProvider.startRecording();
                          }
                        },
                        icon: Icon(isListening ? Icons.stop_rounded : Icons.mic_rounded, size: 18, color: isListening ? Colors.redAccent : const Color(0xFF534AE3)),
                        label: Text(isListening ? 'Stop Mic' : 'Speak Answer'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: isListening ? Colors.redAccent : const Color(0xFF534AE3),
                          side: BorderSide(color: isListening ? Colors.redAccent : const Color(0xFF534AE3)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (isListening) {
                            await sessionProvider.stopRecording();
                          }
                          final text = _controller.text.trim().isNotEmpty
                              ? _controller.text.trim()
                              : (sessionProvider.liveTranscript.isNotEmpty
                                  ? sessionProvider.liveTranscript
                                  : 'Vocabulary sentence using ${current['word']}.');
                          
                          final result = EvaluationEngine.instance.evaluate(
                            transcript: text,
                            durationSeconds: 30,
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
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE65100),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        child: const Text('Submit & Evaluate', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              SizedBox(
                width: double.infinity,
                height: 52,
                child: TextButton.icon(
                  onPressed: _nextWord,
                  icon: const Icon(Icons.refresh_rounded, size: 18, color: Color(0xFFE65100)),
                  label: const Text('Next Word', style: TextStyle(color: Color(0xFFE65100), fontWeight: FontWeight.bold)),
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: Color(0xFFFFE0B2))),
                  ),
                ),
              ),
              
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSynonymChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Text(
        label,
        style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }
}
