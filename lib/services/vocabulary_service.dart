import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/character.dart';

class VocabularyService {
  // Charge un fichier CSV depuis assets/data/
  Future<List<Character>> loadVocabulary(String level) async {
    final String data = await rootBundle.loadString('assets/data/$level');
    final List<Character> vocabulary = [];

    List<String> lines = const LineSplitter().convert(data);
    for (int i = 1; i < lines.length; i++) { // On saute l'en-tête
      final line = lines[i];
      // On sépare en trois parties max pour gérer les traductions avec virgule
      final parts = line.split(RegExp(r',(?=(?:[^"]*"[^"]*")*[^"]*$)'));

      if (parts.length >= 3) {
        vocabulary.add(Character(
          char: parts[0].trim(),
          pinyin: parts[1].trim(),
          translation: parts[2].trim(),
        ));
      }
    }

    return vocabulary;
  }

  // Retourne la liste des lettres disponibles dans le vocabulaire
  List<String> getAvailableLetters(List<Character> vocabulary) {
    final letters = vocabulary
        .map((c) => c.pinyin.isNotEmpty ? c.pinyin[0].toLowerCase() : '')
        .where((l) => l.isNotEmpty)
        .toSet()
        .toList()
      ..sort();
    return letters;
  }

  // Filtre le vocabulaire par lettre
  List<Character> filterByLetter(List<Character> vocabulary, String letter) {
    return vocabulary
        .where((c) => c.pinyin.toLowerCase().startsWith(letter.toLowerCase()))
        .toList();
  }
}
