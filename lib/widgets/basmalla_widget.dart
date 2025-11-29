import 'package:al_quran/al_quran.dart';

import 'package:flutter/material.dart';

class BasmalaWidget extends StatelessWidget {
  const BasmalaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Ensure it takes full width to force new line
      padding: const EdgeInsets.only(top: 45, bottom: 35),
      alignment: Alignment.center,
      child: Text(
        AlQuran.getBismillah.unicode,
        style: const TextStyle(
          fontFamily: "Amiri", // Or Uthmanic if available
          fontSize: 24,
          color: Color(0xFFA47E3B), // Brown/Gold color
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
