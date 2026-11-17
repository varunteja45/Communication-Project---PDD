import 'question_evaluation.dart';

/// Immutable output of the [EvaluationEngine] for a single practice
/// attempt. Holds every sub-competency score (0-100), the derived
/// overall score, raw speech metrics, generated feedback strings,
/// and question-by-question evaluations.
class EvaluationResult {
  final double overallScore;
  final double fluencyScore;
  final double vocabularyScore;
  final double grammarScore;
  final double paceScore;
  final double confidenceScore;
  final double clarityScore;

  final int wordCount;
  final int fillerCount;
  final int durationSeconds;
  final double wordsPerMinute;
  final double typeTokenRatio;

  final String transcript;
  final List<String> strengths;
  final List<String> improvements;
  final List<QuestionEvaluation> questionEvaluations;

  const EvaluationResult({
    required this.overallScore,
    required this.fluencyScore,
    required this.vocabularyScore,
    required this.grammarScore,
    required this.paceScore,
    required this.confidenceScore,
    required this.clarityScore,
    required this.wordCount,
    required this.fillerCount,
    required this.durationSeconds,
    required this.wordsPerMinute,
    required this.typeTokenRatio,
    required this.transcript,
    required this.strengths,
    required this.improvements,
    this.questionEvaluations = const [],
  });

  Map<String, double> get radarData => {
        'Fluency': fluencyScore,
        'Vocabulary': vocabularyScore,
        'Grammar': grammarScore,
        'Pace': paceScore,
        'Confidence': confidenceScore,
        'Clarity': clarityScore,
      };

  String get band {
    if (overallScore < 50) return 'Beginner';
    if (overallScore < 70) return 'Developing';
    if (overallScore < 85) return 'Proficient';
    return 'Advanced';
  }

  static const mock = EvaluationResult(
    overallScore: 82,
    fluencyScore: 84,
    vocabularyScore: 79,
    grammarScore: 78,
    paceScore: 88,
    confidenceScore: 80,
    clarityScore: 86,
    wordCount: 154,
    fillerCount: 3,
    durationSeconds: 65,
    wordsPerMinute: 142,
    typeTokenRatio: 0.65,
    transcript:
        "Actually, let me tell you about a time I had to lead a team through a difficult transition. We were moving from a manual tracking system to a fully automated one, and there was a lot of resistance.",
    strengths: [
      'Speech flowed smoothly with minimal disfluency markers.',
      'Delivery came across as assured and composed.',
    ],
    improvements: [
      'Vary word choice more; watch for repeating the same terms like "communication".',
      'Watch sentence length — aim for clear, complete thoughts of 8-20 words.',
    ],
    questionEvaluations: [],
  );
}
