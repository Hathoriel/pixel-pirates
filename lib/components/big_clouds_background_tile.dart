import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

class SingleCloudComponent extends SpriteComponent with HasGameRef {
  final double speed;
  final String name;

  SingleCloudComponent({
    required Vector2 position,
    required Vector2 size,
    required this.name,
    this.speed = 100,
  }) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('Background/$name');
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.x -= speed * dt;

    // If the cloud goes off-screen to the left, reset its position to the right
    if (position.x + size.x < 0) {
      position.x = gameRef.size.x;
    }
  }
}
