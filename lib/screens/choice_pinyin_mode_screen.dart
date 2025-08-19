import 'package:flutter/material.dart';

class ChoiceModePinyin extends StatelessWidget {
  const ChoiceModePinyin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mode Choice Pinyin")),
      body: const Center(
        child: Text(
          "Hello World - Choice Mode Pinyin",
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
