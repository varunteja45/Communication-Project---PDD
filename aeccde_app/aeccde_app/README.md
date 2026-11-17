# AECCDE
## Automatic Evaluation of Communication Competency in Diverse Environments

A Flutter app that records a spoken response, transcribes it on-device via
speech-to-text, and scores it across six competencies — **Fluency,
Vocabulary, Grammar, Pace, Confidence, Clarity** — using a rule-based NLP
evaluation engine. Scoring is weighted differently per practice
**environment** (Job Interview, Public Speaking, Group Discussion,
Customer Service, Academic Presentation, Cross-Cultural Exchange), so the
same transcript is judged against different real-world expectations.

## Features
- 6 practice environments with distinct competency weighting
- Live on-device speech-to-text transcription while recording
- Deterministic, explainable scoring engine (`lib/services/evaluation_engine.dart`)
  — every score traces back to a concrete linguistic signal (filler-word
  ratio, type-token vocabulary ratio, words-per-minute, sentence-length
  heuristics, etc.)
- Radar chart competency breakdown + strengths/improvements feedback
- Local session history (Hive) — nothing leaves the device
- Progress tracking with score trend line chart + running competency averages
- Light/dark theme, interactive onboarding flow

## Project Structure
```
lib/
  main.dart                 - entry point, Hive init
  app.dart                  - MaterialApp + theming
  theme/app_theme.dart      - design system
  models/                   - EnvironmentModel, EvaluationResult, SessionModel (Hive)
  services/
    evaluation_engine.dart  - the scoring engine
    speech_service.dart     - speech_to_text wrapper
    storage_service.dart    - Hive CRUD
  providers/                - SessionProvider, ThemeProvider (ChangeNotifier)
  screens/                  - splash, onboarding, welcome, signup, signin, 
                               home, notifications, choose_environment, 
                               interview_setup, classroom_setup, meeting_setup,
                               presentation_setup, public_speaking_setup, 
                               group_discussion_setup, conversation_setup,
                               permissions, pre_evaluation_check, 
                               practice_session, ai_interviewer, 
                               live_speech_analysis, emotion_analysis,
                               pronunciation_report, evaluation_completed,
                               overall_report, speech_analysis,
                               language_nlp_report, confidence_behavior,
                               strengths, areas_to_improve, ai_coach_feedback,
                               seven_day_plan, practice_dashboard, 
                               speaking_practice, pronunciation_practice,
                               fluency_practice, grammar_practice,
                               vocabulary_practice, confidence_practice,
                               analytics, history, performance_comparison,
                               achievements, profile, ai_coach_chat,
                               communication_journey,
                               results, language_selection, profile_setup, 
                               reset_password, set_goals
  widgets/                  - environment cards, radar chart, metric bars, 
                               animated buttons, history tiles
  utils/                    - constants, filler word lists
```

## Getting Started

This project contains full, ready-to-open Flutter source. To run it you need
the Flutter SDK installed locally.

```bash
# 1. Unzip and enter the project
cd aeccde_app

# 2. Fetch dependencies
flutter pub get

# 3. (Optional) regenerate the Hive adapter if you modify SessionModel:
dart run build_runner build --delete-conflicting-outputs

# 4. Run on a connected device/emulator
flutter run
```

### Platform notes
- **Android**: minSdkVersion 23, `RECORD_AUDIO` permission is declared in
  `android/app/src/main/AndroidManifest.xml`.
- **iOS**: `NSMicrophoneUsageDescription` and
  `NSSpeechRecognitionUsageDescription` are declared in
  `ios/Runner/Info.plist`.
- If `flutter create .` is run inside this folder, it will safely
  fill in any missing platform boilerplate without touching the `lib/` source.

## Extending the Evaluation Engine
`EvaluationEngine.evaluate()` is intentionally isolated from the UI. To
swap the heuristic scoring for a hosted ML model (e.g. a fine-tuned
transformer), replace the body of that method with an API call and keep the
same `EvaluationResult` contract — no other file needs to change.

## Tech Stack
Flutter, Dart, Provider (state management), Hive (local persistence),
speech_to_text, fl_chart, google_fonts, permission_handler, animate_do.
