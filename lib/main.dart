import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz Chinois',
      theme: ThemeData.dark(),
      home: const QuizPage(),
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Map<String, String>> vocabulaire = [];
  List<Map<String, String>> filteredVocab = [];
  Set<String> validatedChars = {};
  String mode = "francais";
  Map<String, String>? current;

  String letterFilter = "all";
  bool answered = false;

  final TextEditingController controller = TextEditingController();
  String feedback = "";

  @override
  void initState() {
    super.initState();
    loadVocab();
  }

  Future<void> loadVocab() async {
    try {
      final csvData = await rootBundle.loadString('assets/HSK1_vocabulaire.csv');
      final lines = LineSplitter.split(csvData).toList();
      final headers = lines.first.split(',');

      vocabulaire = lines.skip(1).map((line) {
        final values = line.split(',');
        return {
          "caractere": values[0],
          "pinyin": values[1],
          "francais": values[2],
        };
      }).toList();

      filterByLetter("all");
    } catch (e) {
      setState(() {
        feedback = "❌ Fichier CSV introuvable";
      });
    }
  }

  void filterByLetter(String letter) {
    setState(() {
      letterFilter = letter;
      if (letter == "all") {
        filteredVocab = vocabulaire.where((v) => !validatedChars.contains(v['caractere'])).toList();
      } else {
        filteredVocab = vocabulaire
            .where((v) =>
        v['pinyin']!.startsWith(letter) && !validatedChars.contains(v['caractere']))
            .toList();
      }
      nextQuestion();
    });
  }

  void nextQuestion() {
    if (filteredVocab.isEmpty) {
      current = null;
      feedback = "Aucun caractère trouvé pour cette sélection.";
      controller.text = "";
      answered = false;

    } else {
      current = filteredVocab[Random().nextInt(filteredVocab.length)];
      controller.text = "";
      answered = false;
      feedback = "";
    }
  }

  void checkAnswer() {
    if (current == null) return;

    final reponse = controller.text.trim().toLowerCase();
    final attendu = current![mode]!.toLowerCase();

    setState(() {
      // Affiche le feedback
      if (reponse == attendu) {
        feedback =
        "✅ Correct !\n${current!['caractere']} = ${current!['pinyin']} / ${current!['francais']}";
        validatedChars.add(current!['caractere']!);
      } else {
        feedback =
        "❌ Faux.\n${current!['caractere']} = ${current!['pinyin']} / ${current!['francais']}";
      }

      // On ne change pas encore la question, on attend que l'utilisateur appuie sur "Suivant"
      answered = true;
    });
  }
  void setMode(String newMode) {
    setState(() {
      mode = newMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final letters = vocabulaire.map((v) => v['pinyin']![0].toUpperCase()).toSet().toList();
    letters.sort();

    return Scaffold(
      appBar: AppBar(title: const Text("HSK1")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Letters row
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () => filterByLetter("all"),
                    child: const Text("All"),
                  ),
                  ...letters.map((l) => ElevatedButton(
                    onPressed: () => filterByLetter(l.toLowerCase()),
                    child: Text(l),
                  )),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Mode toggles
            Row(
              children: [
                ChoiceChip(
                  label: const Text("Français"),
                  selected: mode == "francais",
                  onSelected: (_) => setMode("francais"),
                ),
                const SizedBox(width: 10),
                ChoiceChip(
                  label: const Text("Pinyin"),
                  selected: mode == "pinyin",
                  onSelected: (_) => setMode("pinyin"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Character display
            Expanded(
              child: Center(
                child: Text(
                  current?['caractere'] ?? "",
                  style: const TextStyle(fontSize: 120, fontFamily: 'Noto', color: Colors.redAccent),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              feedback,
              style: const TextStyle(fontSize: 20),
            ),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: "Votre réponse",
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 70), // largeur max, hauteur 70
                textStyle: const TextStyle(fontSize: 28),     // texte plus grand
              ),
              onPressed: () {
                setState(() {
                  if (!answered) {
                    checkAnswer(); // Affiche le feedback
                  } else {
                    nextQuestion(); // Charge la question suivante
                  }
                });
              },
              child: Text(answered ? "Suivant" : "Valider"),
            ),
            SizedBox(height: 20), // ajoute 30 pixels en bas
          ],
        ),
      ),
    );
  }
}
