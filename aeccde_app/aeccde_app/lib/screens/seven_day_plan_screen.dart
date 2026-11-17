import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

import '../models/evaluation_result.dart';
import 'grammar_practice_screen.dart';
import 'vocabulary_practice_screen.dart';
import 'speaking_practice_screen.dart';
import 'fluency_practice_screen.dart';
import 'confidence_practice_screen.dart';

class SevenDayPlanScreen extends StatefulWidget {
  final EvaluationResult? result;

  const SevenDayPlanScreen({super.key, this.result});

  @override
  State<SevenDayPlanScreen> createState() => _SevenDayPlanScreenState();
}

class _SevenDayPlanScreenState extends State<SevenDayPlanScreen> {
  late List<Map<String, dynamic>> _days;

  @override
  void initState() {
    super.initState();
    _generatePlan();
  }

  void _generatePlan() {
    final res = widget.result;
    String primaryFocus = 'Fluency';

    if (res != null) {
      final List<MapEntry<String, double>> scores = [
        MapEntry('Fluency', res.fluencyScore),
        MapEntry('Vocabulary', res.vocabularyScore),
        MapEntry('Grammar', res.grammarScore),
        MapEntry('Pace', res.paceScore),
        MapEntry('Confidence', res.confidenceScore),
      ];
      scores.sort((a, b) => a.value.compareTo(b.value));
      primaryFocus = scores.first.key;
    }

    _days = [
      {
        'day': 'Day 1',
        'title': 'Speech Pacing & Breath Control',
        'subtitle': 'Target: Maintain 120-150 WPM without rushing',
        'focus': 'Pace',
        'done': true,
      },
      {
        'day': 'Day 2',
        'title': 'Disfluency & Filler Reduction',
        'subtitle': 'Target: Eliminate "um" and "like" in 60-second responses',
        'focus': 'Fluency',
        'done': true,
      },
      {
        'day': 'Day 3',
        'title': 'Sentence Structure & Grammar',
        'subtitle': 'Target: Correct complex subject-verb error patterns',
        'focus': 'Grammar',
        'done': false,
      },
      {
        'day': 'Day 4',
        'title': 'Advanced Vocabulary Expansion',
        'subtitle': 'Target: Incorporate 5 transition words into speech',
        'focus': 'Vocabulary',
        'done': false,
      },
      {
        'day': 'Day 5',
        'title': 'Confidence & Vocal Modulation',
        'subtitle': 'Target: Speak with clear vocal emphasis and projection',
        'focus': 'Confidence',
        'done': false,
      },
      {
        'day': 'Day 6',
        'title': 'Custom $primaryFocus Master Challenge',
        'subtitle': 'Target: Focus specifically on improving your $primaryFocus score',
        'focus': primaryFocus,
        'done': false,
      },
      {
        'day': 'Day 7',
        'title': 'Full Communication Assessment',
        'subtitle': 'Target: Achieve 85+ overall communication score',
        'focus': 'Overall',
        'done': false,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '7-Day Improvement Plan',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _days.length,
        itemBuilder: (context, index) {
          final item = _days[index];
          final isDone = item['done'] as bool;

          return FadeInUp(
            duration: const Duration(milliseconds: 300),
            delay: Duration(milliseconds: index * 50),
            child: Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDone ? const Color(0xFF00BFA5).withOpacity(0.4) : Colors.grey.shade100,
                ),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        item['done'] = !isDone;
                      });
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isDone ? const Color(0xFFF1F8F1) : const Color(0xFFF0F2FF),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          isDone ? Icons.check_circle_rounded : Icons.circle_outlined,
                          color: isDone ? const Color(0xFF00BFA5) : const Color(0xFF534AE3),
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${item['day']} • ${item['title']}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            decoration: isDone ? TextDecoration.lineThrough : null,
                            color: isDone ? Colors.grey : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['subtitle'] as String,
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.play_arrow_rounded, color: Color(0xFF534AE3)),
                    onPressed: () {
                      final focus = item['focus'] as String;
                      if (focus == 'Grammar') {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const GrammarPracticeScreen()));
                      } else if (focus == 'Vocabulary') {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const VocabularyPracticeScreen()));
                      } else if (focus == 'Fluency') {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const FluencyPracticeScreen()));
                      } else if (focus == 'Confidence') {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const ConfidencePracticeScreen()));
                      } else {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const SpeakingPracticeScreen()));
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
