/// Lexicon used by the evaluation engine to detect disfluency markers
/// (filler words / hedges) inside a transcript. Grouped so the engine
/// can weight "hard" fillers (um, uh) more heavily than soft hedges
/// (kind of, sort of) when computing the fluency score.
class FillerWords {
  FillerWords._();

  static const List<String> hardFillers = [
    'um', 'umm', 'ummm', 'uh', 'uhh', 'er', 'erm', 'hmm',
  ];

  static const List<String> softFillers = [
    'like', 'you know', 'i mean', 'actually', 'basically',
    'literally', 'sort of', 'kind of', 'so yeah', 'right',
    'okay so', 'well',
  ];

  static List<String> get all => [...hardFillers, ...softFillers];
}
