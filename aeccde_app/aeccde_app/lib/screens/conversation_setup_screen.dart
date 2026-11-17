import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';

import '../models/environment_model.dart';
import '../providers/session_provider.dart';
import '../widgets/setup_widgets.dart';
import 'permissions_screen.dart';

class ConversationSetupScreen extends StatefulWidget {
  final EnvironmentModel environment;

  const ConversationSetupScreen({super.key, required this.environment});

  @override
  State<ConversationSetupScreen> createState() => _ConversationSetupScreenState();
}

class _ConversationSetupScreenState extends State<ConversationSetupScreen> {
  String selectedScenario = 'Meeting a new person';
  String selectedDifficulty = 'Easy';

  final List<Map<String, dynamic>> scenarios = [
    {'label': 'Meeting a new person', 'icon': Icons.back_hand_rounded},
    {'label': 'Asking for directions', 'icon': Icons.map_rounded},
    {'label': 'Shopping', 'icon': Icons.shopping_bag_rounded},
    {'label': 'Travel', 'icon': Icons.flight_rounded},
    {'label': 'College conversation', 'icon': Icons.school_rounded},
    {'label': 'Workplace conversation', 'icon': Icons.business_center_rounded},
  ];

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

            const SetupSectionTitle(title: 'CHOOSE SCENARIO'),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 2.2,
              ),
              itemCount: scenarios.length,
              itemBuilder: (context, index) {
                final scenario = scenarios[index];
                return ScenarioCard(
                  label: scenario['label'],
                  icon: scenario['icon'],
                  isSelected: selectedScenario == scenario['label'],
                  onTap: () => setState(() => selectedScenario = scenario['label']),
                );
              },
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
                      topic: selectedScenario,
                      difficulty: selectedDifficulty,
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
                    'Start Conversation',
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
