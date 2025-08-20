class Character {
  final String char;
  final String pinyin;
  final String translation;
  int score; // pour suivi progression
  double weight; // pour les chances d'apparaitre

  Character({
    required this.char,
    required this.pinyin,
    required this.translation,
    this.score = 0,
    this.weight = 1.0
  });
}