class BreathingPattern {
  final int inhale;
  final int holdAfterInhale;
  final int exhale;
  final int holdAfterExhale;

  const BreathingPattern({
    required this.inhale,
    required this.holdAfterInhale,
    required this.exhale,
    required this.holdAfterExhale,
  });
}
final patterns = {
  0: BreathingPattern(inhale: 5, holdAfterInhale: 0, exhale: 5, holdAfterExhale: 0),
  1: BreathingPattern(inhale: 5, holdAfterInhale: 5, exhale: 5, holdAfterExhale: 5),
  2: BreathingPattern(inhale: 4, holdAfterInhale: 7, exhale: 8, holdAfterExhale: 0),
};
