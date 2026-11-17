import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../models/environment_model.dart';
import '../models/evaluation_result.dart';
import '../models/question_evaluation.dart';
import '../models/session_model.dart';
import '../services/evaluation_engine.dart';
import '../services/speech_service.dart';
import '../services/storage_service.dart';
import '../services/sync_service.dart';
import '../utils/environment_question_bank.dart';
import '../utils/interview_question_bank.dart';

enum RecordingState { idle, listening, evaluating, done }

/// Orchestrates practice & evaluation sessions, recording voice per-question,
/// applying unanswered 0-score penalties, and storing full per-question JSON results into SQLite.
class SessionProvider extends ChangeNotifier {
  final SpeechService _speechService = SpeechService.instance;
  final StorageService _storage = StorageService.instance;
  final Uuid _uuid = const Uuid();

  EnvironmentModel? selectedEnvironment;
  String? selectedScenarioTopic;
  String? selectedType;
  String? selectedDifficulty;
  String? selectedDuration;
  int selectedQuestionCount = 5;

  List<String> currentInterviewQuestions = [];
  int currentQuestionIndex = 0;
  List<QuestionEvaluation> currentQuestionEvaluations = [];

  RecordingState state = RecordingState.idle;
  String liveTranscript = '';
  int elapsedSeconds = 0;
  EvaluationResult? lastResult;

  StreamSubscription<String>? _transcriptSub;
  StreamSubscription<bool>? _listeningSub;
  Timer? _ticker;

  void selectEnvironment(EnvironmentModel env) {
    configureSessionSetup(env: env);
  }

  void configureSessionSetup({
    required EnvironmentModel env,
    String? topic,
    String? type,
    String? difficulty,
    String? duration,
    int? questionCount,
  }) {
    selectedEnvironment = env;
    selectedScenarioTopic = topic;
    selectedType = type;
    selectedDifficulty = difficulty;
    selectedDuration = duration;
    selectedQuestionCount = questionCount ?? 5;
    currentQuestionEvaluations = [];

    if (env.id == 'interview') {
      currentInterviewQuestions = InterviewQuestionBank.getQuestions(
        type: type ?? 'HR Interview',
        difficulty: difficulty ?? 'Medium',
        count: selectedQuestionCount,
      );
    } else {
      currentInterviewQuestions = EnvironmentQuestionBank.getQuestionsForEnvironment(
        environmentId: env.id,
        count: selectedQuestionCount,
      );
    }
    currentQuestionIndex = 0;

    resetSession();
    notifyListeners();
  }

  String get activeInterviewQuestion {
    if (currentInterviewQuestions.isNotEmpty &&
        currentQuestionIndex >= 0 &&
        currentQuestionIndex < currentInterviewQuestions.length) {
      return currentInterviewQuestions[currentQuestionIndex];
    }
    return activePrompt;
  }

  void nextInterviewQuestion() {
    if (currentQuestionIndex < currentInterviewQuestions.length - 1) {
      currentQuestionIndex++;
      resetSession();
      notifyListeners();
    }
  }

  void previousInterviewQuestion() {
    if (currentQuestionIndex > 0) {
      currentQuestionIndex--;
      resetSession();
      notifyListeners();
    }
  }

  String get activePrompt {
    if (currentInterviewQuestions.isNotEmpty &&
        currentQuestionIndex < currentInterviewQuestions.length) {
      return currentInterviewQuestions[currentQuestionIndex];
    }
    return selectedEnvironment?.samplePrompt ?? 'Speak into the microphone to begin your evaluation.';
  }

  /// Processes the response for the current question.
  /// If [transcript] is empty or < 2 words, evaluates as Unanswered (Score: 0).
  /// Returns whether the question was answered.
  Future<QuestionEvaluation> recordQuestionAnswer({
    required String transcript,
    required int durationSeconds,
  }) async {
    final cleaned = transcript.trim();
    final env = selectedEnvironment ?? EnvironmentModel.all.first;
    final questionText = activeInterviewQuestion;

    QuestionEvaluation qEval;

    if (cleaned.isEmpty || cleaned.split(RegExp(r'\s+')).length < 2) {
      // Unanswered question penalty: Score = 0
      qEval = QuestionEvaluation(
        questionIndex: currentQuestionIndex + 1,
        questionText: questionText,
        transcript: cleaned.isNotEmpty ? cleaned : '[Unanswered]',
        score: 0.0,
        isAnswered: false,
        feedback: 'Question unanswered — assigned 0/100 penalty.',
        fluencyScore: 0.0,
        vocabularyScore: 0.0,
        grammarScore: 0.0,
        paceScore: 0.0,
        confidenceScore: 0.0,
        clarityScore: 0.0,
        wordCount: 0,
        fillerCount: 0,
        durationSeconds: durationSeconds,
        wordsPerMinute: 0.0,
      );
    } else {
      // Evaluate actual response using EvaluationEngine
      final result = EvaluationEngine.instance.evaluate(
        transcript: cleaned,
        durationSeconds: durationSeconds > 0 ? durationSeconds : 10,
        environment: env,
      );

      qEval = QuestionEvaluation(
        questionIndex: currentQuestionIndex + 1,
        questionText: questionText,
        transcript: cleaned,
        score: result.overallScore,
        isAnswered: true,
        feedback: result.improvements.isNotEmpty
            ? result.improvements.first
            : 'Good response delivery.',
        fluencyScore: result.fluencyScore,
        vocabularyScore: result.vocabularyScore,
        grammarScore: result.grammarScore,
        paceScore: result.paceScore,
        confidenceScore: result.confidenceScore,
        clarityScore: result.clarityScore,
        wordCount: result.wordCount,
        fillerCount: result.fillerCount,
        durationSeconds: result.durationSeconds,
        wordsPerMinute: result.wordsPerMinute,
      );
    }

    // Replace or append
    if (currentQuestionIndex < currentQuestionEvaluations.length) {
      currentQuestionEvaluations[currentQuestionIndex] = qEval;
    } else {
      currentQuestionEvaluations.add(qEval);
    }

    notifyListeners();
    return qEval;
  }

  /// Calculates overall session score as the exact arithmetic average
  /// across all question scores (including 0 for unanswered questions) and saves to SQLite.
  Future<EvaluationResult> finalizeSessionEvaluation() async {
    final env = selectedEnvironment ?? EnvironmentModel.all.first;
    final totalQuestions = currentInterviewQuestions.isNotEmpty
        ? currentInterviewQuestions.length
        : selectedQuestionCount;

    // Fill missing questions as unanswered 0s
    while (currentQuestionEvaluations.length < totalQuestions) {
      final idx = currentQuestionEvaluations.length;
      final qText = idx < currentInterviewQuestions.length
          ? currentInterviewQuestions[idx]
          : 'Question ${idx + 1}';
      currentQuestionEvaluations.add(
        QuestionEvaluation(
          questionIndex: idx + 1,
          questionText: qText,
          transcript: '[Unanswered]',
          score: 0.0,
          isAnswered: false,
          feedback: 'Question unanswered — assigned 0/100 penalty.',
          fluencyScore: 0.0,
          vocabularyScore: 0.0,
          grammarScore: 0.0,
          paceScore: 0.0,
          confidenceScore: 0.0,
          clarityScore: 0.0,
          wordCount: 0,
          fillerCount: 0,
          durationSeconds: 0,
          wordsPerMinute: 0.0,
        ),
      );
    }

    // Formula: Overall Score = Sum(q.score) / Total Questions
    final totalSum = currentQuestionEvaluations.fold<double>(0, (sum, q) => sum + q.score);
    final overallScore = (totalSum / totalQuestions).clamp(0.0, 100.0);

    // Compute average sub-scores across answered questions
    double f = 0, v = 0, g = 0, p = 0, c = 0, cl = 0;
    int wordSum = 0, fillerSum = 0, durationSum = 0;

    for (final q in currentQuestionEvaluations) {
      f += q.fluencyScore;
      v += q.vocabularyScore;
      g += q.grammarScore;
      p += q.paceScore;
      c += q.confidenceScore;
      cl += q.clarityScore;
      wordSum += q.wordCount;
      fillerSum += q.fillerCount;
      durationSum += q.durationSeconds;
    }

    final N = totalQuestions.toDouble();
    final avgF = f / N;
    final avgV = v / N;
    final avgG = g / N;
    final avgP = p / N;
    final avgC = c / N;
    final avgCl = cl / N;

    final combinedTranscript = currentQuestionEvaluations
        .map((e) => 'Q${e.questionIndex}: ${e.transcript}')
        .join('\n\n');

    final result = EvaluationResult(
      overallScore: overallScore,
      fluencyScore: avgF,
      vocabularyScore: avgV,
      grammarScore: avgG,
      paceScore: avgP,
      confidenceScore: avgC,
      clarityScore: avgCl,
      wordCount: wordSum,
      fillerCount: fillerSum,
      durationSeconds: durationSum,
      wordsPerMinute: durationSum > 0 ? (wordSum / durationSum) * 60 : 0.0,
      typeTokenRatio: 0.65,
      transcript: combinedTranscript,
      strengths: [
        if (avgF > 60) 'Speech maintained steady flow across answered questions.',
        if (avgV > 60) 'Good vocabulary variety demonstrated in response.',
        if (avgC > 60) 'Confident vocal delivery during recorded answers.',
        if (avgF <= 60 && avgV <= 60 && avgC <= 60) 'Completed evaluation session.',
      ],
      improvements: [
        if (currentQuestionEvaluations.any((q) => !q.isAnswered))
          'Answer all questions completely — unanswered questions receive 0/100 score penalties.',
        if (avgF < 60) 'Reduce filler words and speech pauses to boost fluency.',
        if (avgG < 60) 'Structure your answers using complete sentences.',
      ],
      questionEvaluations: currentQuestionEvaluations,
    );

    lastResult = result;

    final session = SessionModel(
      id: _uuid.v4(),
      environmentId: env.id,
      timestamp: DateTime.now(),
      transcript: result.transcript,
      overallScore: result.overallScore,
      fluencyScore: result.fluencyScore,
      vocabularyScore: result.vocabularyScore,
      grammarScore: result.grammarScore,
      paceScore: result.paceScore,
      confidenceScore: result.confidenceScore,
      clarityScore: result.clarityScore,
      wordCount: result.wordCount,
      fillerCount: result.fillerCount,
      durationSeconds: result.durationSeconds,
      wordsPerMinute: result.wordsPerMinute,
      strengths: result.strengths,
      improvements: result.improvements,
      questionEvaluations: currentQuestionEvaluations,
    );

    await _storage.saveSession(session);
    SyncService.instance.syncSession(session);
    state = RecordingState.done;
    notifyListeners();
    return result;
  }

  void resetSession() {
    state = RecordingState.idle;
    liveTranscript = '';
    elapsedSeconds = 0;
    lastResult = null;
    notifyListeners();
  }

  Future<void> startRecording() async {
    liveTranscript = '';
    elapsedSeconds = 0;
    state = RecordingState.listening;
    notifyListeners();

    _transcriptSub?.cancel();
    _transcriptSub = _speechService.transcriptStream.listen((text) {
      liveTranscript = text;
      notifyListeners();
    });

    _listeningSub?.cancel();
    _listeningSub = _speechService.listeningStream.listen((isListening) {
      if (!isListening && state == RecordingState.listening) {
        _finishRecording();
      }
    });

    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      elapsedSeconds = _speechService.elapsedSeconds;
      notifyListeners();
    });

    await _speechService.startListening();
  }

  Future<void> stopRecording() async {
    if (state != RecordingState.listening) return;
    await _finishRecording();
  }

  Future<void> _finishRecording() async {
    _ticker?.cancel();
    final transcript = await _speechService.stopListening();
    liveTranscript = transcript;
    state = RecordingState.evaluating;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));
    await recordQuestionAnswer(transcript: transcript, durationSeconds: elapsedSeconds);
    state = RecordingState.done;
    notifyListeners();
  }

  /// Manually adds a completed practice evaluation directly into SQLite.
  Future<void> addManualEvaluation({
    required EvaluationResult result,
    EnvironmentModel? environment,
  }) async {
    lastResult = result;
    final env = environment ?? selectedEnvironment ?? EnvironmentModel.all.first;

    final session = SessionModel(
      id: _uuid.v4(),
      environmentId: env.id,
      timestamp: DateTime.now(),
      transcript: result.transcript,
      overallScore: result.overallScore,
      fluencyScore: result.fluencyScore,
      vocabularyScore: result.vocabularyScore,
      grammarScore: result.grammarScore,
      paceScore: result.paceScore,
      confidenceScore: result.confidenceScore,
      clarityScore: result.clarityScore,
      wordCount: result.wordCount,
      fillerCount: result.fillerCount,
      durationSeconds: result.durationSeconds,
      wordsPerMinute: result.wordsPerMinute,
      strengths: result.strengths,
      improvements: result.improvements,
      questionEvaluations: result.questionEvaluations,
    );
    await _storage.saveSession(session);
    SyncService.instance.syncSession(session);
    notifyListeners();
  }

  List<SessionModel> get history => _storage.getAllSessions();

  double get averageScore => _storage.averageOverallScore;

  int get totalSessions => _storage.totalSessions;

  Map<String, double> get competencyAverages => _storage.bestCompetencyAverages;

  Future<void> deleteSession(String id) async {
    await _storage.deleteSession(id);
    notifyListeners();
  }

  Future<void> clearAllHistory() async {
    await _storage.clearAll();
    notifyListeners();
  }

  @override
  void dispose() {
    _transcriptSub?.cancel();
    _listeningSub?.cancel();
    _ticker?.cancel();
    super.dispose();
  }
}
