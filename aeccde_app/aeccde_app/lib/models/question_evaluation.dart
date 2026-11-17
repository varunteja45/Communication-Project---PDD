import 'dart:convert';

/// Data model representing an evaluation of a single question
/// answered during an evaluation session.
class QuestionEvaluation {
  final int questionIndex;
  final String questionText;
  final String transcript;
  final double score;
  final bool isAnswered;
  final String feedback;
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

  QuestionEvaluation({
    required this.questionIndex,
    required this.questionText,
    required this.transcript,
    required this.score,
    required this.isAnswered,
    required this.feedback,
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
  });

  Map<String, dynamic> toMap() {
    return {
      'questionIndex': questionIndex,
      'questionText': questionText,
      'transcript': transcript,
      'score': score,
      'isAnswered': isAnswered ? 1 : 0,
      'feedback': feedback,
      'fluencyScore': fluencyScore,
      'vocabularyScore': vocabularyScore,
      'grammarScore': grammarScore,
      'paceScore': paceScore,
      'confidenceScore': confidenceScore,
      'clarityScore': clarityScore,
      'wordCount': wordCount,
      'fillerCount': fillerCount,
      'durationSeconds': durationSeconds,
      'wordsPerMinute': wordsPerMinute,
    };
  }

  factory QuestionEvaluation.fromMap(Map<String, dynamic> map) {
    return QuestionEvaluation(
      questionIndex: map['questionIndex'] as int? ?? 0,
      questionText: map['questionText'] as String? ?? '',
      transcript: map['transcript'] as String? ?? '',
      score: (map['score'] as num?)?.toDouble() ?? 0.0,
      isAnswered: (map['isAnswered'] == 1 || map['isAnswered'] == true),
      feedback: map['feedback'] as String? ?? '',
      fluencyScore: (map['fluencyScore'] as num?)?.toDouble() ?? 0.0,
      vocabularyScore: (map['vocabularyScore'] as num?)?.toDouble() ?? 0.0,
      grammarScore: (map['grammarScore'] as num?)?.toDouble() ?? 0.0,
      paceScore: (map['paceScore'] as num?)?.toDouble() ?? 0.0,
      confidenceScore: (map['confidenceScore'] as num?)?.toDouble() ?? 0.0,
      clarityScore: (map['clarityScore'] as num?)?.toDouble() ?? 0.0,
      wordCount: map['wordCount'] as int? ?? 0,
      fillerCount: map['fillerCount'] as int? ?? 0,
      durationSeconds: map['durationSeconds'] as int? ?? 0,
      wordsPerMinute: (map['wordsPerMinute'] as num?)?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory QuestionEvaluation.fromJson(String source) =>
      QuestionEvaluation.fromMap(json.decode(source) as Map<String, dynamic>);
}
