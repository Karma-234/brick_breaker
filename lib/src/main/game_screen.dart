import 'dart:async';

import 'package:brick_breaker/src/main/brick.dart';
import 'package:brick_breaker/src/main/info_view.dart';
import 'package:brick_breaker/src/main/models/brick_model.dart';
import 'package:brick_breaker/src/main/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'game_over_prompt.dart';
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
  static double brickWidth = 0.5;
  static double brickHeight = 0.05;
  static int noOfBricks = 3;
  static double gap = 0.01;
  static double wallGap =
      0.5 * (2 - noOfBricks * brickWidth - (noOfBricks - 1) * gap);
  // Game timer
  Timer? _gameTimer;
  var myBricks = List.generate(
      noOfBricks,
      (i) => MyBrickModel(
          (brickX + i * (brickWidth + gap)) >= 1
              ? brickX - i * (brickWidth - gap)
              : brickX + i * (brickWidth + gap),
          (brickX + i * (brickWidth + gap)) >= 1
              ? brickY + brickHeight
              : brickY,
          false));
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
        ballDirection = BallDirection.up;
      } else if (ballY <= -0.85) {
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

          double left = (myBricks[i].xAxis - ballX).abs();
          double right = (myBricks[i].xAxis + brickWidth - ballX).abs();
          double top = (myBricks[i].xAxis - ballY).abs();
          double bottom = (myBricks[i].xAxis + brickHeight - ballY).abs();
          String min = findMinimumDistance(left, right, top, bottom);
          switch (min) {
            case 'left':
              ballXDirection = BallDirection.left;
              break;
            case 'right':
              ballXDirection = BallDirection.right;
              break;
            case 'top':
              ballDirection = BallDirection.up;
              break;
            case 'bottom':
              ballDirection = BallDirection.down;
              break;
            default:
              ballDirection = BallDirection.down;
          }
        });
      }
    }
  }

  String findMinimumDistance(double a, double b, double c, double d) {
    var myDistances = [a, b, c, d];
    var currentMinimum = a;
    for (var i = 0; i < myDistances.length; i++) {
      if (myDistances[i] < currentMinimum) {
        currentMinimum = myDistances[i];
      }
    }
    if ((currentMinimum - a).abs() > 0.01) {
      return 'left';
    } else if ((currentMinimum - b).abs() > 0.01) {
      return 'right';
    } else if ((currentMinimum - c).abs() > 0.01) {
      return 'top';
    } else {
      return 'bottom';
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
                child: MyBall(
                  isGameStarted: isStarted,
                ),
              ),
              GestureDetector(
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
                child: RawKeyboardListener(
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
            ],
          ),
        ),
      ),
    );
  }
}
