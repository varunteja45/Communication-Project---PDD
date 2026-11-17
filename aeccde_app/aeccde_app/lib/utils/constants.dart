/// App-wide static constants: local storage keys, ideal speaking-pace
/// bounds, and score-banding thresholds shared across the evaluation
/// engine and UI layer.
class AppConstants {
  AppConstants._();

  static const String sessionsBoxName = 'aeccde_sessions';
  static const String settingsBoxName = 'aeccde_settings';

  // Ideal conversational pace in words-per-minute, used as the target
  // band when scoring the "pace" competency.
  static const double idealWpmLow = 110;
  static const double idealWpmHigh = 160;

  static const double weakThreshold = 40;
  static const double developingThreshold = 70;

  static const int minRecordingSeconds = 8;
}
