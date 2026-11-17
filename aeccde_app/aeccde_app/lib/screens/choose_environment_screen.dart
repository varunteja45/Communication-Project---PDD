import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../models/environment_model.dart';
import '../widgets/environment_card.dart';
import 'interview_setup_screen.dart';
import 'presentation_setup_screen.dart';
import 'public_speaking_setup_screen.dart';
import 'group_discussion_setup_screen.dart';

class ChooseEnvironmentScreen extends StatelessWidget {
  const ChooseEnvironmentScreen({super.key});

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
          'Choose Environment',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Text(
              'Select the communication context you want to be evaluated in.',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              itemCount: EnvironmentModel.all.length,
              itemBuilder: (context, index) {
                final env = EnvironmentModel.all[index];
                return FadeInUp(
                  duration: const Duration(milliseconds: 400),
                  delay: Duration(milliseconds: index * 60),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: EnvironmentCard(
                      environment: env,
                      onTap: () {
                        if (env.id == 'interview') {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => InterviewSetupScreen(environment: env),
                            ),
                          );
                        } else if (env.id == 'presentation') {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => PresentationSetupScreen(environment: env),
                            ),
                          );
                        } else if (env.id == 'public_speaking') {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => PublicSpeakingSetupScreen(environment: env),
                            ),
                          );
                        } else if (env.id == 'group_discussion') {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => GroupDiscussionSetupScreen(environment: env),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Starting ${env.name} evaluation...')),
                          );
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
