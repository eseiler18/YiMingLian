import 'package:flutter/material.dart';

typedef OnSelectionChanged = void Function(Set<String>);

void showLetterFilterSheet({
  required BuildContext context,
  required List<String> availableLetters,
  required Set<String> selectedLetters,
  required int Function(String) countCharsForLetter,
  required OnSelectionChanged onSelectionChanged,
}) {
  showModalBottomSheet(
    context: context,
    builder: (_) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setModalState(() {
                      selectedLetters.clear();
                    });
                    onSelectionChanged(selectedLetters);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    selectedLetters.isEmpty ? Colors.blue : null,
                    minimumSize: const Size(60, 60),
                  ),
                  child: const Text("Tous"),
                ),
                ...availableLetters.map((letter) {
                  final count = countCharsForLetter(letter);
                  final isSelected = selectedLetters.contains(letter);

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setModalState(() {
                            if (isSelected) {
                              selectedLetters.remove(letter);
                            } else {
                              selectedLetters.add(letter);
                            }
                          });
                          onSelectionChanged(selectedLetters);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected ? Colors.blue : null,
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
                }),
              ],
            ),
          );
        },
      );
    },
  );
}
