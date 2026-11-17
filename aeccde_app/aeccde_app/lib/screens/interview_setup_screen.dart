import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';

import '../models/environment_model.dart';
import '../providers/session_provider.dart';
import '../widgets/setup_widgets.dart';
import 'permissions_screen.dart';

class InterviewSetupScreen extends StatefulWidget {
  final EnvironmentModel environment;

  const InterviewSetupScreen({super.key, required this.environment});

  @override
  State<InterviewSetupScreen> createState() => _InterviewSetupScreenState();
}

class _InterviewSetupScreenState extends State<InterviewSetupScreen> {
  String selectedType = 'HR Interview';
  String selectedDifficulty = 'Medium';
  int selectedQuestions = 5;

  @override
  Widget build(BuildContext context) {
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
          'Interview Evaluation',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            SetupHeader(
              title: '${widget.environment.name} Mode',
              subtitle: widget.environment.description,
              icon: widget.environment.icon,
              color: widget.environment.color,
            ),
            const SizedBox(height: 32),

            const SetupSectionTitle(title: 'INTERVIEW TYPE'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                'HR Interview',
                'Technical Interview',
                'Behavioral Interview',
                'Self Introduction'
              ].map((type) => SetupChoiceChip(
                label: type,
                isSelected: selectedType == type,
                onSelected: (_) => setState(() => selectedType = type),
              )).toList(),
            ),
            const SizedBox(height: 32),

            const SetupSectionTitle(title: 'DIFFICULTY LEVEL'),
            const SizedBox(height: 12),
            Row(
              children: ['Easy', 'Medium', 'Hard'].map((diff) => Padding(
                padding: const EdgeInsets.only(right: 12),
                child: SetupChoiceChip(
                  label: diff,
                  isSelected: selectedDifficulty == diff,
                  onSelected: (_) => setState(() => selectedDifficulty = diff),
                ),
              )).toList(),
            ),
            const SizedBox(height: 32),

            const SetupSectionTitle(title: 'NUMBER OF QUESTIONS'),
            const SizedBox(height: 12),
            Row(
              children: ['5', '10', '15'].map((q) => Padding(
                padding: const EdgeInsets.only(right: 12),
                child: SetupChoiceChip(
                  label: q,
                  isSelected: selectedQuestions.toString() == q,
                  onSelected: (_) => setState(() => selectedQuestions = int.parse(q)),
                ),
              )).toList(),
            ),
            const SizedBox(height: 32),

            FadeInUp(
              duration: const Duration(milliseconds: 500),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F2FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'What AI will evaluate:',
                      style: TextStyle(
                        color: Color(0xFF534AE3),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        _buildBulletPoint('Speech clarity & fluency'),
                        _buildBulletPoint('Answer relevance'),
                        _buildBulletPoint('Confidence & tone'),
                        _buildBulletPoint('Grammar & vocabulary'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),

            FadeInUp(
              duration: const Duration(milliseconds: 500),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<SessionProvider>().configureSessionSetup(
                      env: widget.environment,
                      type: selectedType,
                      difficulty: selectedDifficulty,
                      questionCount: selectedQuestions,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PermissionsScreen(environment: widget.environment)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF534AE3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Start Interview Evaluation',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          '• ',
          style: TextStyle(color: Color(0xFF534AE3), fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          text,
          style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
