import 'dart:math';
import 'package:flame/camera.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'ball.dart';
import 'player.dart';

class BallDodgeGame extends FlameGame with HasCollisionDetection, TapDetector {
  late Player player;
  final ValueNotifier<int> scoreNotifier = ValueNotifier<int>(0);
  int score = 0;
  double spawnTimer = 0;
  double scoreTimer = 0.0;
  final Random random = Random();

  void Function()? onGameOver;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.viewport = FixedResolutionViewport(
      resolution: Vector2(400, 700),
    );

    add(RectangleComponent(
      position: Vector2.zero(),
      size: Vector2(400, 700),
      paint: Paint()..color = Colors.black,
    ));

    player = Player(180, 650, 40, 20);
    add(player);
  }

  //@override
  // void update(double dt) {
  //   super.update(dt);

  //   spawnTimer += dt;
  //   if (spawnTimer > 1.0 && size.x > 0) {
  //     spawnTimer = 0;
  //     final x = (size.x - 20) * random.nextDouble();
  //     add(Ball(x, -20, 20));
  //   }

  //   score += (dt * 10).toInt();
  //   scoreNotifier.value = score;
  // }

  @override
  void update(double dt) {
    super.update(dt);

    // Spawn balls every second
    spawnTimer += dt;
    if (spawnTimer > 1.0 && size.x > 0) {
      spawnTimer = 0;
      final x = (size.x - 20) * random.nextDouble();
      add(Ball(x, -20, 20)); // Correct usage
    }

    scoreTimer += dt;
    if (scoreTimer >= 5.0) {
      score += 1; // +1 per 5 seconds
      scoreNotifier.value = score;
      scoreTimer = 0.0; // reset timer
    }
  }
    
  void reset() {
    children.whereType<Ball>().forEach((ball) => ball.removeFromParent());
    player.position = Vector2(180, 650);
    score = 0;
    spawnTimer = 0;
    scoreNotifier.value = score;
  }

  @override
  void onTapDown(TapDownInfo info) {
    final tapX = info.eventPosition.widget.x;
    if (tapX < size.x / 2) {
      player.moveLeft(30);
    } else {
      player.moveRight(30);
    }
  }

  void gameOver() {
    pauseEngine();
    if (onGameOver != null) {
      onGameOver!();
    }
  }
}
