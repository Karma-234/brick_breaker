import 'package:flutter/material.dart';

class InfoView extends StatelessWidget {
  const InfoView({super.key, this.isStarted = false});
  final bool isStarted;
  @override
  Widget build(BuildContext context) {
    return isStarted
        ? const SizedBox.shrink()
        : Align(
            alignment: const Alignment(0, -0.1),
            child: Text(
              'Tap to play',
              style: TextStyle(
                  color: Colors.blue[300], fontWeight: FontWeight.w600),
            ),
          );
  }
}
