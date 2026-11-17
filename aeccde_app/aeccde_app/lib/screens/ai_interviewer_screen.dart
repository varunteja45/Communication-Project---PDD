import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../models/environment_model.dart';
import '../providers/session_provider.dart';
import 'results_screen.dart';

class AiInterviewerScreen extends StatefulWidget {
  final EnvironmentModel environment;

  const AiInterviewerScreen({super.key, required this.environment});

  @override
  State<AiInterviewerScreen> createState() => _AiInterviewerScreenState();
}

class _AiInterviewerScreenState extends State<AiInterviewerScreen> {
  @override
  Widget build(BuildContext context) {
    final sessionProvider = context.watch<SessionProvider>();
    final isListening = sessionProvider.state == RecordingState.listening;

    final questions = sessionProvider.currentInterviewQuestions;
    final totalQuestions = questions.isNotEmpty ? questions.length : sessionProvider.selectedQuestionCount;
    final currentIndex = sessionProvider.currentQuestionIndex;
    final currentNumber = currentIndex + 1;
    final activeQuestionText = sessionProvider.activeInterviewQuestion;
    final isLastQuestion = currentNumber >= totalQuestions;

    final hasAnsweredCurrent = sessionProvider.currentQuestionEvaluations.length > currentIndex;

    return Scaffold(
      backgroundColor: const Color(0xFF1B1845),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Question $currentNumber of $totalQuestions',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                '${sessionProvider.elapsedSeconds}s',
                style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 12),
              
              // Progress Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: LinearProgressIndicator(
                  value: currentNumber / totalQuestions,
                  backgroundColor: Colors.white10,
                  color: const Color(0xFF00BFA5),
                  minHeight: 6,
                ),
              ),

              const SizedBox(height: 20),
              
              // AI Avatar
              FadeInDown(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: const Color(0xFF7A6FFF).withOpacity(0.4),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const CircleAvatar(
                      radius: 42,
                      backgroundColor: Color(0xFFEDEEFC),
                      child: Text('🤖', style: TextStyle(fontSize: 34)),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Color(0xFF00BFA5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.auto_awesome, color: Colors.white, size: 14),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 10),
              Text(
                '${sessionProvider.selectedType ?? 'HR'} INTERVIEW (${sessionProvider.selectedDifficulty ?? 'Medium'})',
                style: const TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1),
              ),
              
              const SizedBox(height: 20),
              
              // Question Bubble
              FadeIn(
                key: ValueKey(currentIndex),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Text(
                    '"$activeQuestionText"',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      height: 1.4,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Transcript & Response Status Display
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: hasAnsweredCurrent ? const Color(0xFF00BFA5).withOpacity(0.15) : Colors.black26,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: hasAnsweredCurrent ? const Color(0xFF00BFA5) : Colors.white10,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            hasAnsweredCurrent ? Icons.check_circle_rounded : Icons.mic_rounded,
                            size: 16,
                            color: hasAnsweredCurrent ? const Color(0xFF00BFA5) : Colors.white54,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            hasAnsweredCurrent
                                ? 'Response Processed (Score: ${sessionProvider.currentQuestionEvaluations[currentIndex].score.toInt()}/100)'
                                : (isListening ? 'Recording voice answer...' : 'Tap Mic button to answer'),
                            style: TextStyle(
                              color: hasAnsweredCurrent ? const Color(0xFF00BFA5) : Colors.white70,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      if (sessionProvider.liveTranscript.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          sessionProvider.liveTranscript,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ],
                  ),
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
                        color: (isListening ? Colors.redAccent : const Color(0xFF534AE3)).withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    isListening ? Icons.stop_rounded : Icons.mic_rounded,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                isListening ? 'Tap to Stop Recording' : 'Tap to Record Answer',
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
              
              const SizedBox(height: 28),
              
              // Control Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 54,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (isListening) {
                              await sessionProvider.stopRecording();
                            }

                            // Strict Response Check: Must have answered current question!
                            if (!hasAnsweredCurrent) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please record your voice answer before proceeding to the next question.'),
                                  backgroundColor: Colors.redAccent,
                                  duration: Duration(seconds: 3),
                                ),
                              );
                              return;
                            }

                            if (!isLastQuestion) {
                              sessionProvider.nextInterviewQuestion();
                            } else {
                              // Confirmation modal before finalizing final evaluation
                              _showFinishConfirmationModal(context, sessionProvider);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF534AE3),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                isLastQuestion ? 'Finish Evaluation' : 'Next Question',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                isLastQuestion ? Icons.check_circle_outline_rounded : Icons.arrow_forward_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _showFinishConfirmationModal(BuildContext context, SessionProvider sessionProvider) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Complete Evaluation?', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text(
          'You have answered all questions in this session. Generate your AI evaluation report now?',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Review Answers', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final result = await sessionProvider.finalizeSessionEvaluation();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ResultsScreen(result: result),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF534AE3),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Generate Report', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
