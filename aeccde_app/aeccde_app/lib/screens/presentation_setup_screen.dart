import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';

import '../models/environment_model.dart';
import '../providers/session_provider.dart';
import '../widgets/setup_widgets.dart';
import 'permissions_screen.dart';

class PresentationSetupScreen extends StatefulWidget {
  final EnvironmentModel environment;

  const PresentationSetupScreen({super.key, required this.environment});

  @override
  State<PresentationSetupScreen> createState() => _PresentationSetupScreenState();
}

class _PresentationSetupScreenState extends State<PresentationSetupScreen> {
  final TextEditingController _topicController = TextEditingController(
    text: 'The Impact of Artificial Intelligence on Education',
  );
  String selectedAudience = 'Academic';
  String selectedDuration = '5 min';
  String selectedDifficulty = 'Medium';

  @override
  void dispose() {
    _topicController.dispose();
    super.dispose();
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
          'Presentation Mode',
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

            const SetupSectionTitle(title: 'PRESENTATION TOPIC'),
            const SizedBox(height: 12),
            TextField(
              controller: _topicController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF534AE3)),
                ),
              ),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),

            const SetupSectionTitle(title: 'AUDIENCE TYPE'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                'Academic',
                'Professional',
                'Technical',
                'General'
              ].map((type) => SetupChoiceChip(
                label: type,
                isSelected: selectedAudience == type,
                onSelected: (_) => setState(() => selectedAudience = type),
              )).toList(),
            ),
            const SizedBox(height: 32),

            const SetupSectionTitle(title: 'DURATION'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: ['3 min', '5 min', '10 min', '15 min'].map((duration) => SetupChoiceChip(
                label: duration,
                isSelected: selectedDuration == duration,
                onSelected: (_) => setState(() => selectedDuration = duration),
              )).toList(),
            ),
            const SizedBox(height: 32),

            const SetupSectionTitle(title: 'DIFFICULTY'),
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
            const SizedBox(height: 48),

            FadeInUp(
              duration: const Duration(milliseconds: 500),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<SessionProvider>().configureSessionSetup(
                      env: widget.environment,
                      topic: _topicController.text.trim(),
                      difficulty: selectedDifficulty,
                      duration: selectedDuration,
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
                    'Start Presentation',
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
}
