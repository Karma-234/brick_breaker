import 'package:flutter/material.dart';

class MyPlayer extends StatelessWidget {
  final playerX;
  final playerWidth;
  const MyPlayer({super.key, this.playerX, this.playerWidth});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(playerX, 0.9),
      child: Container(
        height: 20,
        width: MediaQuery.sizeOf(context).width * playerWidth / 2,
        decoration: BoxDecoration(
            color: Colors.red, borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
