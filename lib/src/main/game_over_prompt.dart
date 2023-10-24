import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GameOverPrompt extends StatelessWidget {
  final bool isGameOver;
  const GameOverPrompt({
    super.key,
    this.isGameOver = false,
  });

  @override
  Widget build(BuildContext context) {
    return !isGameOver
        ? const SizedBox.shrink()
        : Align(
            alignment: const Alignment(0, -0.3),
            child: Text(
              'GAME OVER!',
              style: GoogleFonts.pressStart2p(
                  color: Colors.red[700],
                  fontSize: 28,
                  fontWeight: FontWeight.w600),
            ));
  }
}
