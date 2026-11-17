import 'dart:convert';
import 'question_evaluation.dart';

/// Record of one completed practice session, combining
/// the raw transcript/metrics with evaluated scores and per-question evaluations.
class SessionModel {
  final String id;
  final String userId;
  final String environmentId;
  final DateTime timestamp;
  final String transcript;
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
  final List<String> strengths;
  final List<String> improvements;
  final List<QuestionEvaluation> questionEvaluations;

  SessionModel({
    required this.id,
    this.userId = 'guest_user',
    required this.environmentId,
    required this.timestamp,
    required this.transcript,
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'environmentId': environmentId,
      'timestamp': timestamp.toIso8601String(),
      'transcript': transcript,
      'overallScore': overallScore,
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
      'strengths': jsonEncode(strengths),
      'improvements': jsonEncode(improvements),
      'questionEvaluations': jsonEncode(
        questionEvaluations.map((q) => q.toMap()).toList(),
      ),
    };
  }

  factory SessionModel.fromMap(Map<String, dynamic> map) {
    List<QuestionEvaluation> qEvals = [];
    if (map['questionEvaluations'] != null && map['questionEvaluations'].toString().isNotEmpty) {
      try {
        final List parsed = jsonDecode(map['questionEvaluations'] as String) as List;
        qEvals = parsed.map((e) => QuestionEvaluation.fromMap(e as Map<String, dynamic>)).toList();
      } catch (_) {}
    }

    return SessionModel(
      id: map['id'] as String,
      userId: map['userId'] as String? ?? 'guest_user',
      environmentId: map['environmentId'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
      transcript: map['transcript'] as String,
      overallScore: (map['overallScore'] as num).toDouble(),
      fluencyScore: (map['fluencyScore'] as num).toDouble(),
      vocabularyScore: (map['vocabularyScore'] as num).toDouble(),
      grammarScore: (map['grammarScore'] as num).toDouble(),
      paceScore: (map['paceScore'] as num).toDouble(),
      confidenceScore: (map['confidenceScore'] as num).toDouble(),
      clarityScore: (map['clarityScore'] as num).toDouble(),
      wordCount: map['wordCount'] as int,
      fillerCount: map['fillerCount'] as int,
      durationSeconds: map['durationSeconds'] as int,
      wordsPerMinute: (map['wordsPerMinute'] as num).toDouble(),
      strengths: List<String>.from(jsonDecode(map['strengths'] as String) as List),
      improvements: List<String>.from(jsonDecode(map['improvements'] as String) as List),
      questionEvaluations: qEvals,
    );
  }
}
