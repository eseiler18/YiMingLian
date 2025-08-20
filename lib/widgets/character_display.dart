import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../models/character.dart';

class CharacterDisplay extends StatefulWidget {
  final Character character;
  final bool showAnswer;

  const CharacterDisplay({
    super.key,
    required this.character,
    required this.showAnswer,
  });

  @override
  State<CharacterDisplay> createState() => _CharacterDisplayState();
}

class _CharacterDisplayState extends State<CharacterDisplay> {
  final FlutterTts flutterTts = FlutterTts();

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage("zh-CN");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Caractère
        Text(
          widget.character.char,
          style: const TextStyle(
            fontSize: 200,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 90),
        // Réponse
        SizedBox(
          height: 160,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.showAnswer) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.character.pinyin,
                      style: const TextStyle(
                        fontSize: 38,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      icon: const Icon(Icons.volume_up, size: 32),
                      onPressed: () => _speak(widget.character.char),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Text(
                  widget.character.translation,
                  style: const TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ]
            ],
          ),
        ),
      ],
    );
  }
}
