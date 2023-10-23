import 'package:flutter/material.dart';

class MyBall extends StatelessWidget {
  const MyBall({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      width: 10,
      decoration: BoxDecoration(
        color: Colors.blue[700],
        shape: BoxShape.circle,
      ),
    );
  }
}
