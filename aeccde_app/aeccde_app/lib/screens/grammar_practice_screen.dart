import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';

import '../models/environment_model.dart';
import '../providers/session_provider.dart';
import '../services/evaluation_engine.dart';
import 'evaluation_completed_screen.dart';

class GrammarPracticeScreen extends StatefulWidget {
  const GrammarPracticeScreen({super.key});

  @override
  State<GrammarPracticeScreen> createState() => _GrammarPracticeScreenState();
}

class _GrammarPracticeScreenState extends State<GrammarPracticeScreen> {
  int currentQuestionIndex = 0;
  int? selectedIndex;
  int correctAnswers = 0;

  final List<Map<String, dynamic>> questions = [
    {
      'question': '"She go to college every day."',
      'options': [
        'She goes to college every day.',
        'She going to college every day.',
        'She go college every day.',
      ],
      'correctIndex': 0,
    },
    {
      'question': '"He don\'t know the answer."',
      'options': [
        'He not knowing the answer.',
        'He doesn\'t know the answer.',
        'He don\'t knows the answer.',
      ],
      'correctIndex': 1,
    },
    {
      'question': '"I am agree with your proposal."',
      'options': [
        'I am agreed with your proposal.',
        'I agreeing with your proposal.',
        'I agree with your proposal.',
      ],
      'correctIndex': 2,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final sessionProvider = context.read<SessionProvider>();
    final q = questions[currentQuestionIndex];

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
          'Grammar Practice',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              // Progress Section
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: (currentQuestionIndex + 1) / questions.length,
                        backgroundColor: Colors.grey.shade100,
                        color: const Color(0xFF7A6FFF),
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Q ${currentQuestionIndex + 1} / ${questions.length}',
                      style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Question Card
              FadeInDown(
                key: ValueKey(currentQuestionIndex),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F0FF),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'FIND AND CORRECT THE ERROR',
                        style: TextStyle(
                          color: Color(0xFF9C27B0),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        q['question'] as String,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Options
              ...List.generate(
                (q['options'] as List<String>).length,
                (index) => _buildOption(index, (q['options'] as List<String>)[index]),
              ),
              
              const SizedBox(height: 24),
              
              // Action Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: selectedIndex != null ? () async {
                    if (selectedIndex == q['correctIndex']) {
                      correctAnswers++;
                    }

                    if (currentQuestionIndex < questions.length - 1) {
                      setState(() {
                        currentQuestionIndex++;
                        selectedIndex = null;
                      });
                    } else {
                      final sampleTranscript = "Grammar Practice Session: Answered $correctAnswers of ${questions.length} questions correctly.";
                      final result = EvaluationEngine.instance.evaluate(
                        transcript: sampleTranscript,
                        durationSeconds: 45,
                        environment: EnvironmentModel.byId('classroom'),
                      );
                      
                      await sessionProvider.addManualEvaluation(
                        result: result,
                        environment: EnvironmentModel.byId('classroom'),
                      );

                      if (mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const EvaluationCompletedScreen()),
                        );
                      }
                    }
                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedIndex != null ? const Color(0xFF534AE3) : const Color(0xFFF5F5F5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: Text(
                    currentQuestionIndex < questions.length - 1 ? 'Next Question' : 'Finish & Get Results',
                    style: TextStyle(
                      color: selectedIndex != null ? Colors.white : Colors.grey.shade400,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
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

  Widget _buildOption(int index, String text) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => selectedIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(18),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF534AE3) : Colors.grey.shade100,
            width: 1.5,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(color: const Color(0xFF534AE3).withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? const Color(0xFF1A1A1A) : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }
}
