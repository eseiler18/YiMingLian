import 'package:flutter/material.dart';
import 'dart:math';
import '../services/vocabulary_service.dart';
import '../models/character.dart';
import '../widgets/character_display.dart';
import '../widgets/letter_filter_sheet.dart';

class FastModeScreen extends StatefulWidget {
  const FastModeScreen({super.key});

  @override
  State<FastModeScreen> createState() => _FastModeScreenState();
}

class _FastModeScreenState extends State<FastModeScreen> {
  late String hskFile;
  List<Character> vocabulary = [];
  List<Character> filteredVocabulary = [];
  Character? currentChar;
  bool showAnswer = false;

  final VocabularyService service = VocabularyService();
  final Random random = Random();
  List<String> availableLetters = [];
  Set<String> selectedLetters = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      hskFile = ModalRoute.of(context)!.settings.arguments as String;
      _loadVocabulary();
    });
  }

  Future<void> _loadVocabulary() async {
    final vocab = await service.loadVocabulary(hskFile);
    setState(() {
      vocabulary = vocab;
      filteredVocabulary = List.from(vocabulary);
      availableLetters = service.getAvailableLetters(vocabulary);
      _nextCharacter();
    });
  }

  void _nextCharacter() {
    if (filteredVocabulary.isNotEmpty) {
      double totalWeight = filteredVocabulary.fold(0.0, (sum, c) => sum + c.weight);
      double r = random.nextDouble() * totalWeight;
      double accum = 0;
      Character selected = filteredVocabulary.first;

      for (var c in filteredVocabulary) {
        accum += c.weight;
        if (r <= accum) {
          selected = c;
          break;
        }
      }

      setState(() {
        currentChar = selected;
        showAnswer = false;
        selected.weight *= 0.05; // réduire son poids pour qu’il ait moins de chance
      });
    }
  }

  void _revealAnswer() => setState(() => showAnswer = true);

  void _applyFilter() {
    setState(() {
      if (selectedLetters.isEmpty) {
        filteredVocabulary = List.from(vocabulary);
      } else {
        filteredVocabulary = vocabulary
            .where((c) => selectedLetters.any(
                (letter) => c.pinyin.toLowerCase().startsWith(letter)))
            .toList();
      }
      _nextCharacter();
    });
  }

  int _countCharsForLetter(String letter) {
    return vocabulary
        .where((c) => c.pinyin.toLowerCase().startsWith(letter))
        .length;
  }

  void _showLetterFilterSheet() {
    showLetterFilterSheet(
      context: context,
      availableLetters: availableLetters,
      selectedLetters: selectedLetters,
      countCharsForLetter: _countCharsForLetter,
      onSelectionChanged: (letters) {
        setState(() {
          selectedLetters = letters;
        });
        _applyFilter();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
        Text("Mode Rapide - ${hskFile.replaceAll('.csv', '').toUpperCase()}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: "Filtrer par lettre",
            onPressed: _showLetterFilterSheet,
          ),
        ],
      ),
      body: currentChar == null
          ? const Center(child: CircularProgressIndicator())
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CharacterDisplay(
              character: currentChar!,
              showAnswer: showAnswer,
            ),
            const SizedBox(height: 90),
            SizedBox(
              width: 300,
              height: 80,
              child: ElevatedButton(
                onPressed: showAnswer ? _nextCharacter : _revealAnswer,
                child: Text(
                  showAnswer ? "Suivant" : "Réponse",
                  style: const TextStyle(fontSize: 32),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
