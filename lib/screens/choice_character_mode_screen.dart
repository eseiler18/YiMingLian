import 'package:flutter/material.dart';

class ChoiceModeCharacter extends StatelessWidget {
  const ChoiceModeCharacter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mode Choice Character")),
      body: const Center(
        child: Text(
          "Hello World - Choice Mode Character",
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
