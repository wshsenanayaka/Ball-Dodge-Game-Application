import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'ball_dodge_game.dart';
import 'player.dart';

class Ball extends CircleComponent
    with CollisionCallbacks, HasGameRef<BallDodgeGame> {
  final double speed = 150;

  Ball(double x, double y, double radius)
      : super(
          position: Vector2(x, y),
          radius: radius,
          paint: Paint()..color = Colors.redAccent,
        ) {
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += speed * dt;
    if (position.y > gameRef.size.y) {
      removeFromParent();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Player) {
      gameRef.gameOver();
    }
  }
}
