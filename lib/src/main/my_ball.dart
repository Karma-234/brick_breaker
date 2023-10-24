import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

class MyBall extends StatelessWidget {
  const MyBall({
    super.key,
    this.isGameStarted = false,
  });
  final bool isGameStarted;

  @override
  Widget build(BuildContext context) {
    return AvatarGlow(
      endRadius: 20,
      repeat: !isGameStarted,
      glowColor: Colors.blue[400]!,
      child: Container(
        height: 10,
        width: 10,
        decoration: BoxDecoration(
          color: Colors.blue[700],
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
