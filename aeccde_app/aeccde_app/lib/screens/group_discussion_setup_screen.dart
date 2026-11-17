import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';

import '../models/environment_model.dart';
import '../providers/session_provider.dart';
import '../widgets/setup_widgets.dart';
import 'permissions_screen.dart';

class GroupDiscussionSetupScreen extends StatefulWidget {
  final EnvironmentModel environment;

  const GroupDiscussionSetupScreen({super.key, required this.environment});

  @override
  State<GroupDiscussionSetupScreen> createState() => _GroupDiscussionSetupScreenState();
}

class _GroupDiscussionSetupScreenState extends State<GroupDiscussionSetupScreen> {
  final TextEditingController _topicController = TextEditingController(
    text: 'Social Media Impact on Youth',
  );
  int aiParticipantsCount = 3;
  String selectedDifficulty = 'Medium';
  String selectedDuration = '10 min';

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
        title: Text(
          widget.environment.name,
          style: const TextStyle(
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

            const SetupSectionTitle(title: 'DISCUSSION TOPIC'),
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

            const SetupSectionTitle(title: 'AI PARTICIPANTS COUNT'),
            const SizedBox(height: 12),
            Row(
              children: [2, 3, 4].map((count) => Padding(
                padding: const EdgeInsets.only(right: 12),
                child: SetupChoiceChip(
                  label: count.toString(),
                  isSelected: aiParticipantsCount == count,
                  onSelected: (_) => setState(() => aiParticipantsCount = count),
                ),
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
            const SizedBox(height: 32),

            const SetupSectionTitle(title: 'DURATION'),
            const SizedBox(height: 12),
            Row(
              children: ['5 min', '10 min', '15 min'].map((duration) => Padding(
                padding: const EdgeInsets.only(right: 12),
                child: SetupChoiceChip(
                  label: duration,
                  isSelected: selectedDuration == duration,
                  onSelected: (_) => setState(() => selectedDuration = duration),
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
                    'Start Discussion',
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
