class Character {
  final String char;
  final String pinyin;
  final String translation;
  int score; // pour suivi progression

  Character({
    required this.char,
    required this.pinyin,
    required this.translation,
    this.score = 0,
  });
}