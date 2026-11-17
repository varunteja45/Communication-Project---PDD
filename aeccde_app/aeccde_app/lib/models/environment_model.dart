import 'package:flutter/material.dart';

/// A communication environment the user can practice in.
/// Contains strictly 4 allowed environments: Interview, Presentation,
/// Public Speaking, and Group Discussion.
class EnvironmentModel {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final String samplePrompt;

  /// Weights sum to 1.0 across competencies
  final Map<String, double> competencyWeights;

  const EnvironmentModel({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.samplePrompt,
    required this.competencyWeights,
  });

  static const List<EnvironmentModel> all = [
    EnvironmentModel(
      id: 'interview',
      name: 'Interview',
      description: 'AI evaluates your interview communication',
      icon: Icons.business_center_rounded,
      color: Color(0xFF534AE3),
      samplePrompt: 'Tell me about a challenge you faced at work and how you handled it.',
      competencyWeights: {
        'fluency': 0.15,
        'vocabulary': 0.15,
        'grammar': 0.15,
        'pace': 0.15,
        'confidence': 0.25,
        'clarity': 0.15,
      },
    ),
    EnvironmentModel(
      id: 'presentation',
      name: 'Presentation',
      description: 'Deliver impactful presentations',
      icon: Icons.desktop_windows_rounded,
      color: Color(0xFFFF9100),
      samplePrompt: 'Deliver the opening statement for your project presentation.',
      competencyWeights: {
        'fluency': 0.15,
        'vocabulary': 0.25,
        'grammar': 0.20,
        'pace': 0.10,
        'confidence': 0.15,
        'clarity': 0.15,
      },
    ),
    EnvironmentModel(
      id: 'public_speaking',
      name: 'Public Speaking',
      description: 'Speeches & public address',
      icon: Icons.campaign_rounded,
      color: Color(0xFFFF5252),
      samplePrompt: 'Deliver a 1-minute opening for a speech on innovation and growth.',
      competencyWeights: {
        'fluency': 0.20,
        'vocabulary': 0.15,
        'grammar': 0.10,
        'pace': 0.15,
        'confidence': 0.25,
        'clarity': 0.15,
      },
    ),
    EnvironmentModel(
      id: 'group_discussion',
      name: 'Group Discussion',
      description: 'AI participants & debates',
      icon: Icons.forum_rounded,
      color: Color(0xFF00B0FF),
      samplePrompt: 'Share your view: should social media be regulated by governments?',
      competencyWeights: {
        'fluency': 0.20,
        'vocabulary': 0.15,
        'grammar': 0.10,
        'pace': 0.20,
        'confidence': 0.20,
        'clarity': 0.15,
      },
    ),
  ];

  static EnvironmentModel byId(String id) =>
      all.firstWhere((e) => e.id == id, orElse: () => all.first);
}
