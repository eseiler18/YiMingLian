import 'package:flutter/material.dart';
import '../services/vocabulary_service.dart';
import '../models/character.dart';
import 'dart:math';

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
  String? selectedLetter;

  final VocabularyService service = VocabularyService();
  final Random random = Random();
  List<String> availableLetters = [];

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
      setState(() {
        currentChar =
        filteredVocabulary[random.nextInt(filteredVocabulary.length)];
        showAnswer = false;
      });
    }
  }

  void _revealAnswer() => setState(() => showAnswer = true);

  void _filterByLetter(String? letter) {
    setState(() {
      selectedLetter = letter;
      filteredVocabulary = (letter == null)
          ? List.from(vocabulary)
          : service.filterByLetter(vocabulary, letter);
      _nextCharacter();
    });
  }

  int _countCharsForLetter(String letter) {
    return vocabulary
        .where((c) => c.pinyin.toLowerCase().startsWith(letter))
        .length;
  }

  void _showLetterFilterSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              // Bouton "Tous"
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _filterByLetter(null);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedLetter == null ? Colors.blue : null,
                  minimumSize: const Size(60, 60),
                ),
                child: const Text("Tous"),
              ),
              ...availableLetters.map((letter) {
                final count = _countCharsForLetter(letter);
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _filterByLetter(letter);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        selectedLetter == letter ? Colors.blue : null,
                        minimumSize: const Size(60, 60),
                      ),
                      child: Text(letter.toUpperCase()),
                    ),
                    Text(
                      "$count",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                );
              }).toList(),
            ],
          ),
        );
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
            // Caractère
            Text(
              currentChar!.char,
              style: const TextStyle(
                fontSize: 200,
                fontWeight: FontWeight.w300,
              ),
            ),

            const SizedBox(height: 90),

            // Réponse (avec espace réservé fixe)
            SizedBox(
              height: 160, // réserve l’espace pour pinyin + traduction
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (showAnswer) ...[
                    Text(
                      currentChar!.pinyin,
                      style: const TextStyle(
                        fontSize: 38,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      currentChar!.translation,
                      style: const TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 90),

            // Bouton
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