import 'package:flutter/material.dart';

class MyBrick extends StatelessWidget {
  final brickX;
  final brickWidth;
  final brickHeight;
  final brickY;
  const MyBrick(
      {super.key,
      this.brickX,
      this.brickWidth,
      this.brickY = -0.9,
      this.isBroken = false,
      this.brickHeight});
  final bool isBroken;

  @override
  Widget build(BuildContext context) {
    return isBroken
        ? const SizedBox.shrink()
        : Align(
            alignment:
                Alignment((2 * brickX + brickWidth) / (2 - brickWidth), brickY),
            child: Container(
              height: MediaQuery.sizeOf(context).height * brickHeight / 2,
              width: MediaQuery.sizeOf(context).width * brickWidth / 2,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(8)),
            ),
          );
  }
}
