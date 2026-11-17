import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:permission_handler/permission_handler.dart';

import 'practice_session_screen.dart';
import 'ai_interviewer_screen.dart';
import 'permissions_screen.dart';
import '../models/environment_model.dart';

class PreEvaluationCheckScreen extends StatelessWidget {
  final EnvironmentModel? environment;
  const PreEvaluationCheckScreen({super.key, this.environment});

  Future<void> _handleBeginEvaluation(BuildContext context) async {
    final micGranted = await Permission.microphone.isGranted;
    final camGranted = await Permission.camera.isGranted;

    if (!micGranted || !camGranted) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Camera and Microphone access are required to proceed.'),
            backgroundColor: Colors.redAccent,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => PermissionsScreen(environment: environment),
          ),
        );
      }
      return;
    }

    if (!context.mounted) return;

    if (environment?.id == 'interview') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AiInterviewerScreen(environment: environment!)),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PracticeSessionScreen()),
      );
    }
  }

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
          'Pre-Evaluation Check',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 16),
              FadeIn(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9).withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      width: 90,
                      height: 90,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE8F5E9),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const Icon(Icons.check_box_rounded, size: 46, color: Color(0xFF2E7D32)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Ready to Start!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32)),
              ),
              const SizedBox(height: 28),
              _buildCheckItem('Microphone permission granted', Icons.mic_rounded),
              const SizedBox(height: 12),
              _buildCheckItem('Camera permission granted', Icons.camera_alt_rounded),
              const SizedBox(height: 12),
              _buildCheckItem('Speech engine initialized', Icons.psychology_rounded),
              const SizedBox(height: 12),
              _buildCheckItem('Local SQLite database connected', Icons.storage_rounded),
              const SizedBox(height: 12),
              _buildCheckItem('AI Environment ready', Icons.check_circle_outline_rounded),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => _handleBeginEvaluation(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00897B),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Begin Evaluation',
                    style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
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

  Widget _buildCheckItem(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F8F1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade600, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF2E7D32), fontSize: 13),
            ),
          ),
          const Icon(Icons.check_rounded, color: Color(0xFF2E7D32), size: 18),
        ],
      ),
    );
  }
}
