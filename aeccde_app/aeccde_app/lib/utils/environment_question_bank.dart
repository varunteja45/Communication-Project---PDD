import 'dart:math';

/// Centralized repository providing non-repeating question pools
/// tailored strictly to the 4 allowed environments:
/// Interview, Presentation, Public Speaking, and Group Discussion.
class EnvironmentQuestionBank {
  static final Random _random = Random();

  static const Map<String, List<String>> _environmentQuestions = {
    'presentation': [
      'Deliver the opening hook for your presentation topic.',
      'Explain the primary problem your presentation solves.',
      'Present key statistical data supporting your main proposal.',
      'Address potential audience objections and technical challenges.',
      'Conclude your presentation with a memorable call to action.',
      'Explain how your proposal compares to existing industry solutions.',
      'Describe the implementation timeline and resource allocation.',
      'Demonstrate how your strategy impacts corporate growth.',
      'Explain the user or customer benefits of your proposal.',
      'Deliver an engaging response to a skeptical audience question.',
      'Summarize the core takeaways of your presentation in 30 seconds.',
      'Explain how your presentation topic aligns with future industry trends.',
      'Present the financial or return-on-investment analysis for your project.',
      'Explain the team responsibilities required for successful project execution.',
      'Deliver a compelling closing pitch that leaves a lasting impression.',
    ],

    'public_speaking': [
      'Deliver an inspiring 1-minute keynote speech opening.',
      'Explain why effective communication is vital in modern society.',
      'Address a large audience on overcoming fear and taking calculated risks.',
      'Deliver a persuasive call to action on environmental sustainability.',
      'Share a personal leadership lesson with a large auditorium audience.',
      'Explain how technological innovation can improve human lives.',
      'Address an audience on the importance of lifelong education.',
      'Deliver an uplifting speech on resilience during times of crisis.',
      'Explain how integrity and transparency shape strong communities.',
      'Deliver a speech celebrating team achievement and collective success.',
      'Inspire the audience to adopt a growth mindset in their daily careers.',
      'Explain why empathy and active listening make a powerful public speaker.',
      'Deliver a keynote address on shaping the workplace of the future.',
      'Address an audience on balancing technical progress with human values.',
      'Deliver a powerful closing statement that inspires long-term commitment.',
    ],

    'group_discussion': [
      'Share your opening viewpoint: Should social media platforms be strictly regulated?',
      'Respond constructively to a group member who opposes your viewpoint.',
      'Introduce a new perspective regarding remote work vs office productivity.',
      'Synthesize conflicting group arguments into a balanced compromise.',
      'Explain how artificial intelligence will impact entry-level job opportunities.',
      'Lead the group in evaluating the environmental impact of modern technology.',
      'Provide evidence supporting your position on digital privacy rights.',
      'Address a team member who interrupted you with composure and clarity.',
      'Explain the economic factors surrounding global supply chain challenges.',
      'Summarize the key agreement points reached by the group so far.',
      'Offer a pragmatic solution to a complex urban development debate.',
      'Explain how educational systems should adapt to emerging industry skills.',
      'Encourage a quiet group participant to share their perspective.',
      'Debate the ethical implications of genetic research and biotechnology.',
      'Deliver a concise concluding summary representing the consensus of the group.',
    ],
  };

  /// Returns [count] unique non-repeating questions for the given [environmentId].
  static List<String> getQuestionsForEnvironment({
    required String environmentId,
    required int count,
  }) {
    final pool = List<String>.from(_environmentQuestions[environmentId] ?? _environmentQuestions['presentation']!);
    pool.shuffle(_random);
    return pool.take(count.clamp(1, pool.length)).toList();
  }
}
