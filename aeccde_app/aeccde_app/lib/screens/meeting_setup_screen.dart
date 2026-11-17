import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';

import '../models/environment_model.dart';
import '../providers/session_provider.dart';
import '../widgets/setup_widgets.dart';
import 'permissions_screen.dart';

class MeetingSetupScreen extends StatefulWidget {
  final EnvironmentModel environment;

  const MeetingSetupScreen({super.key, required this.environment});

  @override
  State<MeetingSetupScreen> createState() => _MeetingSetupScreenState();
}

class _MeetingSetupScreenState extends State<MeetingSetupScreen> {
  String selectedType = 'Team Discussion';
  String selectedDuration = '10 min';
  String selectedObjective = 'Problem Solving';
  int aiParticipants = 2;

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
          'Meeting Evaluation',
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

            const SetupSectionTitle(title: 'MEETING TYPE'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                'Team Discussion',
                'Project Discussion',
                'Problem Solving',
                'Leadership'
              ].map((type) => SetupChoiceChip(
                label: type,
                isSelected: selectedType == type,
                onSelected: (_) => setState(() => selectedType = type),
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
            const SizedBox(height: 32),

            const SetupSectionTitle(title: 'SPEAKING OBJECTIVE'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                'Problem Solving',
                'Persuasion',
                'Reporting',
                'Brainstorming'
              ].map((obj) => SetupChoiceChip(
                label: obj,
                isSelected: selectedObjective == obj,
                onSelected: (_) => setState(() => selectedObjective = obj),
              )).toList(),
            ),
            const SizedBox(height: 32),

            const SetupSectionTitle(title: 'PARTICIPANT SIMULATION'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: SetupChoiceChip(
                    label: '2 AI Participants',
                    icon: const Text('🤖', style: TextStyle(fontSize: 14)),
                    isSelected: aiParticipants == 2,
                    onSelected: (_) => setState(() => aiParticipants = 2),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SetupChoiceChip(
                    label: '4 AI Participants',
                    icon: const Text('🤖', style: TextStyle(fontSize: 14)),
                    isSelected: aiParticipants == 4,
                    onSelected: (_) => setState(() => aiParticipants = 4),
                  ),
                ),
              ],
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
                      type: selectedType,
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
                    'Start Meeting Evaluation',
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
