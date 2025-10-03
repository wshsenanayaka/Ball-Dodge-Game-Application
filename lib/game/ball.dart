import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'player.dart';
import 'ball_dodge_game.dart';

class Ball extends CircleComponent
    with CollisionCallbacks, HasGameRef<BallDodgeGame> {
  final double speed = 150;

  Ball(double x, double y, double radius)
      : super(
          position: Vector2(x, y),
          radius: radius,
          paint: Paint()..color = const Color(0xFFFF4444),
        ) {
    // Add collision hitbox
    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.y += speed * dt;

    // Remove ball if it goes out of screen
    if (position.y > gameRef.size.y) {
      removeFromParent();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    // If ball hits the player, trigger game over
    if (other is Player) {
      gameRef.gameOver();
    }
  }
}
