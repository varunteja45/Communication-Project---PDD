import 'dart:math';

import '../models/environment_model.dart';
import '../models/evaluation_result.dart';
import '../utils/constants.dart';
import '../utils/filler_words.dart';

/// On-device heuristic NLP engine that turns a raw transcript + timing
/// data into a full communication-competency evaluation.
class EvaluationEngine {
  EvaluationEngine._();
  static final EvaluationEngine instance = EvaluationEngine._();

  EvaluationResult evaluate({
    required String transcript,
    required int durationSeconds,
    required EnvironmentModel environment,
  }) {
    final cleaned = transcript.trim();
    final words = _tokenize(cleaned);
    final wordCount = words.length;

    final fillerCount = _countFillers(cleaned);
    final uniqueWords = words.map((w) => w.toLowerCase()).toSet();
    final ttr = wordCount == 0 ? 0.0 : uniqueWords.length / wordCount;

    final safeDuration = max(durationSeconds, AppConstants.minRecordingSeconds);
    final wpm = wordCount == 0 ? 0.0 : (wordCount / safeDuration) * 60;

    final lengthMultiplier = _calculateLengthMultiplier(wordCount);

    final rawFluency = _scoreFluency(wordCount, fillerCount);
    final rawVocabulary = _scoreVocabulary(ttr, wordCount);
    final rawGrammar = _scoreGrammar(cleaned, words);
    final rawPace = _scorePace(wpm);
    final rawConfidence = _scoreConfidence(fillerCount, wordCount, wpm);
    final rawClarity = _scoreClarity(rawVocabulary, rawGrammar, fillerCount, wordCount);

    final fluency = _clamp(rawFluency * lengthMultiplier);
    final vocabulary = _clamp(rawVocabulary * lengthMultiplier);
    final grammar = _clamp(rawGrammar * lengthMultiplier);
    final pace = _clamp(rawPace * lengthMultiplier);
    final confidence = _clamp(rawConfidence * lengthMultiplier);
    final clarity = _clamp(rawClarity * lengthMultiplier);

    final weights = environment.competencyWeights;
    final overall = (fluency * (weights['fluency'] ?? 0) +
        vocabulary * (weights['vocabulary'] ?? 0) +
        grammar * (weights['grammar'] ?? 0) +
        pace * (weights['pace'] ?? 0) +
        confidence * (weights['confidence'] ?? 0) +
        clarity * (weights['clarity'] ?? 0));

    final scores = {
      'Fluency': fluency,
      'Vocabulary': vocabulary,
      'Grammar': grammar,
      'Pace': pace,
      'Confidence': confidence,
      'Clarity': clarity,
    };

    final strengths = _topN(scores, 2, highest: true);
    final improvements = _topN(scores, 2, highest: false);

    return EvaluationResult(
      overallScore: _clamp(overall),
      fluencyScore: fluency,
      vocabularyScore: vocabulary,
      grammarScore: grammar,
      paceScore: pace,
      confidenceScore: confidence,
      clarityScore: clarity,
      wordCount: wordCount,
      fillerCount: fillerCount,
      durationSeconds: durationSeconds,
      wordsPerMinute: wpm,
      typeTokenRatio: ttr,
      transcript: cleaned,
      strengths: _buildFeedback(strengths, positive: true, wpm: wpm, fillerCount: fillerCount, wordCount: wordCount),
      improvements: _buildFeedback(improvements, positive: false, wpm: wpm, fillerCount: fillerCount, wordCount: wordCount),
    );
  }

  // ---------------------------------------------------------------------
  // Length Multiplier Curve
  // ---------------------------------------------------------------------

  double _calculateLengthMultiplier(int wordCount) {
    if (wordCount == 0) return 0.0;
    if (wordCount < 3) return 0.25;  // 1-2 words caps at ~25%
    if (wordCount < 7) return 0.45;  // 3-6 words caps at ~45%
    if (wordCount < 15) return 0.65; // 7-14 words caps at ~65%
    if (wordCount < 25) return 0.82; // 15-24 words caps at ~82%
    return 1.0;                      // 25+ words full potential
  }

  // ---------------------------------------------------------------------
  // Tokenization & filler detection
  // ---------------------------------------------------------------------

  List<String> _tokenize(String text) {
    if (text.isEmpty) return [];
    final matches = RegExp(r"[A-Za-z']+").allMatches(text);
    return matches.map((m) => m.group(0)!).toList();
  }

  int _countFillers(String text) {
    final lower = text.toLowerCase();
    int count = 0;
    for (final filler in FillerWords.all) {
      final pattern = RegExp(r'\b' + RegExp.escape(filler) + r'\b');
      count += pattern.allMatches(lower).length;
    }
    return count;
  }

  // ---------------------------------------------------------------------
  // Sub-competency scoring
  // ---------------------------------------------------------------------

  double _scoreFluency(int wordCount, int fillerCount) {
    if (wordCount == 0) return 0;
    final ratio = fillerCount / wordCount;
    final score = 100 - (ratio * 10 * 24);
    return _clamp(score);
  }

  double _scoreVocabulary(double ttr, int wordCount) {
    if (wordCount == 0) return 0;
    final expected = wordCount < 40 ? 0.75 : 0.75 - (log(wordCount / 40) * 0.08);
    final relative = ttr / expected;
    return _clamp(relative * 85);
  }

  double _scoreGrammar(String text, List<String> words) {
    if (words.isEmpty) return 0;
    double score = 90;

    int repeats = 0;
    for (int i = 1; i < words.length; i++) {
      if (words[i].toLowerCase() == words[i - 1].toLowerCase()) repeats++;
    }
    score -= repeats * 10;

    final sentences = text.split(RegExp(r'[.!?]+')).where((s) => s.trim().isNotEmpty).length;
    final avgSentenceLen = sentences > 0 ? words.length / sentences : words.length.toDouble();
    if (avgSentenceLen < 5 || avgSentenceLen > 28) score -= 12;

    return _clamp(score);
  }

  double _scorePace(double wpm) {
    if (wpm <= 0) return 0;
    if (wpm >= AppConstants.idealWpmLow && wpm <= AppConstants.idealWpmHigh) {
      return 95;
    }
    final distance = wpm < AppConstants.idealWpmLow
        ? AppConstants.idealWpmLow - wpm
        : wpm - AppConstants.idealWpmHigh;
    return _clamp(95 - distance * 1.3);
  }

  double _scoreConfidence(int fillerCount, int wordCount, double wpm) {
    if (wordCount == 0) return 0;
    final fillerPenalty = (fillerCount / wordCount) * 100 * 2.5;
    final paceStability = wpm < 70 ? (70 - wpm) * 0.7 : 0.0;
    final score = 100 - fillerPenalty - paceStability;
    return _clamp(score);
  }

  double _scoreClarity(double vocabulary, double grammar, int fillerCount, int wordCount) {
    final base = (vocabulary * 0.5) + (grammar * 0.5);
    final fillerPenalty = wordCount == 0 ? 0 : (fillerCount / wordCount) * 100 * 1.0;
    return _clamp(base - fillerPenalty);
  }

  // ---------------------------------------------------------------------
  // Feedback generation
  // ---------------------------------------------------------------------

  List<String> _topN(Map<String, double> scores, int n, {required bool highest}) {
    final entries = scores.entries.toList()
      ..sort((a, b) => highest ? b.value.compareTo(a.value) : a.value.compareTo(b.value));
    return entries.take(n).map((e) => e.key).toList();
  }

  List<String> _buildFeedback(
    List<String> competencies, {
    required bool positive,
    required double wpm,
    required int fillerCount,
    required int wordCount,
  }) {
    final messages = <String>[];
    for (final c in competencies) {
      switch (c) {
        case 'Fluency':
          messages.add(positive
              ? 'Speech flowed smoothly with minimal disfluency markers.'
              : 'Elaborate your ideas with longer sentences and reduce hesitation words like "um".');
          break;
        case 'Vocabulary':
          messages.add(positive
              ? 'Strong lexical variety — few repeated words for the response length.'
              : 'Expand your word choice and avoid repeating basic terms.');
          break;
        case 'Grammar':
          messages.add(positive
              ? 'Sentence construction was clean and well-formed.'
              : 'Construct complete thoughts with proper subject-verb structure.');
          break;
        case 'Pace':
          messages.add(positive
              ? 'Speaking pace sat right in the ideal conversational range.'
              : wpm < AppConstants.idealWpmLow
                  ? 'Speaking pace was slow — practice speaking continuously with clear energy.'
                  : 'Pace was faster than ideal — slow down slightly for clarity.');
          break;
        case 'Confidence':
          messages.add(positive
              ? 'Delivery came across as assured and composed.'
              : 'Speak with deliberate emphasis and complete full sentences to build confidence.');
          break;
        case 'Clarity':
          messages.add(positive
              ? 'Message was easy to follow and well-articulated.'
              : 'Provide more details in your answer so the core message stands out clearly.');
          break;
      }
    }
    return messages;
  }

  double _clamp(double v) => v.clamp(0, 100).toDouble();
}
