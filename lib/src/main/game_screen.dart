import 'dart:async';

import 'package:brick_breaker/src/main/brick.dart';
import 'package:brick_breaker/src/main/info_view.dart';
import 'package:brick_breaker/src/main/models/brick_model.dart';
import 'package:brick_breaker/src/main/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'my_ball.dart';

enum BallDirection { up, down, right, left }

class GameView extends StatefulWidget {
  const GameView({super.key});

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  // Ball Position
  double ballX = 0;
  double ballY = 0;
  var ballDirection = BallDirection.down;
  var ballXDirection = BallDirection.right;
  // PlayerX Position
  double playerXXaxis = 0;
  double playerXYaxis = 0.9;
  double playerWidth = 0.4;
  // PlayerY Position
  double playerYXaxis = 0;
  double playerYYaxis = 0;
  // Track game status
  bool isStarted = false;
  bool isGameOver = false;
  //Brick position
  static double brickX = -1 + wallGap;
  static double brickY = -0.88;
  static bool isBrickBroken = false;
  static double brickWidth = 0.3;
  static double brickHeight = 0.05;
  static int noOfBricks = 4;
  static double gap = 0.01;
  static double wallGap =
      0.5 * (2 - noOfBricks * brickWidth - (noOfBricks - 1) * gap);
  // Game timer
  Timer? _gameTimer;
  var myBricks = List.generate(noOfBricks,
      (i) => MyBrickModel(brickX + i * (brickWidth + gap), brickY, false));
  var myBricksPositions = List.generate(
      noOfBricks, (i) => [brickX + i * (brickWidth * gap), brickY, false]);

  void startGame() {
    if (!isStarted) {
      setState(() {
        isStarted = true;
        isGameOver = false;
      });
      _gameTimer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
        updateDirection();
        // updateXDirection();
        moveBall();
        breakBrick();
        endGame();
      });
    }
  }

  void endGame() {
    if (ballY > playerXYaxis) {
      _gameTimer?.cancel();
      setState(() {
        isStarted = false;
        isGameOver = true;
        ballY = 0;
        ballX = 0;
      });
      for (var i = 0; i < myBricks.length; i++) {
        setState(() {
          myBricks[i].isBroken = false;
        });
      }
    }
  }

  void moveBall() {
    if (ballXDirection == BallDirection.right) {
      ballX += 0.005;
    } else if (ballXDirection == BallDirection.left) {
      ballX -= 0.005;
    }
    if (ballDirection == BallDirection.down) {
      ballY += 0.006;
    } else if (ballDirection == BallDirection.up) {
      ballY -= 0.006;
    }
  }

  void updateDirection() {
    setState(() {
      if (ballY >= 0.85 &&
          ballX >= playerXXaxis - playerWidth &&
          ballX <= playerXXaxis + playerWidth) {
        // ballX += playerXXaxis;
        ballDirection = BallDirection.up;
      } else if (ballY <= -0.85) {
        // ballX += brickX;
        ballDirection = BallDirection.down;
      }
      if (ballX >= 1) {
        ballXDirection = BallDirection.left;
      } else if (ballX <= -0.9) {
        ballXDirection = BallDirection.right;
      }
    });
  }

  void breakBrick() {
    for (var i = 0; i < myBricks.length; i++) {
      if (ballY <= myBricks[i].yAxis + brickHeight &&
          ballX >= myBricks[i].xAxis &&
          ballX <= myBricks[i].xAxis + brickWidth) {
        setState(() {
          myBricks[i].isBroken = true;
          ballDirection = BallDirection.down;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: startGame,
      child: Scaffold(
        backgroundColor: Colors.blue[100],
        body: Center(
          child: Stack(
            children: [
              InfoView(
                isStarted: isStarted,
              ),
              GameOverPrompt(
                isGameOver: isGameOver,
              ),
              Align(
                alignment: Alignment(ballX, ballY),
                child: const MyBall(),
              ),
              RawKeyboardListener(
                focusNode: FocusNode(),
                onKey: (value) {
                  if (isStarted) {
                    if (value.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
                      playerXXaxis + playerWidth > -1
                          ? playerXXaxis -= 0.1
                          : null;
                    } else if (value
                        .isKeyPressed(LogicalKeyboardKey.arrowRight)) {
                      playerXXaxis < 1 ? playerXXaxis += 0.1 : null;
                    }
                  }
                },
                child: GestureDetector(
                  onPanUpdate: (details) {
                    if (isStarted) {
                      double x = details.delta.dx;
                      setState(() {
                        if (x < 0) {
                          playerXXaxis + playerWidth > -1
                              ? playerXXaxis -= 0.02
                              : null;
                        } else {
                          playerXXaxis < 1 ? playerXXaxis += 0.02 : null;
                        }
                      });
                    }
                  },
                  child: MyPlayer(
                    playerX: playerXXaxis,
                    playerWidth: playerWidth,
                  ),
                ),
              ),
              ...myBricks
                  .map((e) => MyBrick(
                        brickX: e.xAxis,
                        brickY: e.yAxis,
                        isBroken: e.isBroken,
                        brickWidth: brickWidth,
                        brickHeight: brickHeight,
                      ))
                  .toList(),
              // MyBrick(
              //   brickX: brickX,
              //   brickY: brickY,
              //   brickWidth: brickWidth,
              //   isBroken: isBrickBroken,
              // )
            ],
          ),
        ),
      ),
    );
  }
}

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
              'G A M E O V E R!',
              style: TextStyle(
                  color: Colors.red[700],
                  fontSize: 36,
                  fontWeight: FontWeight.w600),
            ));
  }
}
