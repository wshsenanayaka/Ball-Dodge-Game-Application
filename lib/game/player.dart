import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'ball_dodge_game.dart';

class Player extends RectangleComponent
    with CollisionCallbacks, HasGameRef<BallDodgeGame> {
  Player(double x, double y, double w, double h)
      : super(
          position: Vector2(x, y),
          size: Vector2(w, h),
          paint: Paint()..color = Colors.greenAccent,
        ) {
    add(RectangleHitbox());
  }

  void moveLeft(double distance) {
    position.x = (position.x - distance).clamp(0, gameRef.size.x - size.x);
  }

  void moveRight(double distance) {
    position.x = (position.x + distance).clamp(0, gameRef.size.x - size.x);
  }
}
