import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';

class WaterReflect extends PositionComponent with HasGameRef {
  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Load individual images and create sprites
    final sprite1 = await loadSprite('Background/Water Reflect Big 01.png');
    final sprite2 = await loadSprite('Background/Water Reflect Big 02.png');
    final sprite3 = await loadSprite('Background/Water Reflect Big 03.png');
    final sprite4 = await loadSprite('Background/Water Reflect Big 04.png');

    // Create a SpriteAnimation from the sprites
    final spriteAnimation = SpriteAnimation.spriteList(
      [sprite1, sprite2, sprite3, sprite4],
      stepTime: 0.2, // Time between frames in seconds
    );

    // Create a SpriteAnimationComponent
    final animationComponent = SpriteAnimationComponent(
      animation: spriteAnimation,
      position: Vector2(90, 350), // Position relative to WaterReflect component
      size: Vector2(170, 10), // Size of the component
    );

    // Add the animation component to WaterReflect
    add(animationComponent);
  }

  Future<Sprite> loadSprite(String imagePath) async {
    return Sprite(await gameRef.images.load(imagePath));
  }
}