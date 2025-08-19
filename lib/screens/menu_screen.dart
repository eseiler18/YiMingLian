import 'package:flutter/material.dart';
import '../utils/constants.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late String selectedHSK;

  @override
  void initState() {
    super.initState();
    selectedHSK = availableHSK.first; // premier fichier par défaut
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Menu Principal")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 90),
            const Text(
              "Sélectionne ton niveau HSK",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            // Menu déroulant
            DropdownButton<String>(
              value: selectedHSK,
              items: availableHSK.map((file) {
                final level = file.replaceAll(".csv", "").toUpperCase();
                return DropdownMenuItem<String>(
                  value: file,
                  child: Text(level, style: TextStyle(fontSize: 30)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedHSK = value;
                  });
                }
              },
            ),

            const SizedBox(height: 90),

            // Boutons vers les modes
            _buildModeButton(context, "Mode Rapide", '/fast'),
            const SizedBox(height: 90),
            _buildModeButton(context, "Choix du Caractère", '/choiceCharacter'),
            const SizedBox(height: 90),
            _buildModeButton(context, "Choix Pinyin/Français", '/choicePinyin'),
            const SizedBox(height: 90),
          ],
        ),
      ),
    );
  }




  Widget _buildModeButton(BuildContext context, String label, String route) {
    return SizedBox(
      width: 340,
      height: 90,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            route,
            arguments: selectedHSK, // on passe le fichier CSV sélectionné
          );
        },
        child: Text(
          label,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

