import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/widgets.dart';
import 'package:pixel_adventure/components/background_tile.dart';
import 'package:pixel_adventure/components/big_clouds_background_tile.dart';
import 'package:pixel_adventure/components/checkpoint.dart';
import 'package:pixel_adventure/components/chicken.dart';
import 'package:pixel_adventure/components/collision_block.dart';
import 'package:pixel_adventure/components/fruit.dart';
import 'package:pixel_adventure/components/full_background_tile.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/components/saw.dart';
import 'package:pixel_adventure/components/water_background_tile.dart';
import 'package:pixel_adventure/components/water_reflect.dart';
import 'package:pixel_adventure/pixel_adventure.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';

class Level extends World with HasGameRef<PixelAdventure> {
  final String levelName;
  final Player player;
  Level({required this.levelName, required this.player});
  late TiledComponent level;
  List<CollisionBlock> collisionBlocks = [];

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(32));

    add(level);

    _scrollingBackground();
    _spawningObjects();
    _addCollisions();

    return super.onLoad();
  }

  Future<void> _scrollingBackground() async {
    final backgroundLayer = level.tileMap.getLayer('Background');
    print(gameRef.size);
    if (backgroundLayer != null) {
      final height = (13 * 32).toDouble();

      final backgroundTile = BackgroundTile(
        size: Vector2(gameRef.size.x, height / 2),
        position: Vector2(0, height / 2),
      );

      final fullBackgroundTile = FullBackgroundTile(
        size: Vector2(gameRef.size.x, height / 1.5),
        position: Vector2(0, 0),
      );

      ParallaxComponent clouds  = await gameRef.loadParallaxComponent(
        [ParallaxImageData('Background/Big Clouds.png')],
        baseVelocity: Vector2(35, 0),
        position: Vector2(0, height / 2),
        size: Vector2(gameRef.size.x, height / 3),
      );

      final cloudOne = SingleCloudComponent(
        name: 'Small Cloud 1.png',
        position: Vector2(gameRef.size.x - 330, 80),
        size: Vector2(74, 24),
        speed: 15,
      );
      add(cloudOne .. priority = -3);

      final cloudTwo = SingleCloudComponent(
        name: 'Small Cloud 2.png',
        position: Vector2(gameRef.size.x - 530, 140),
        size: Vector2(74, 24),
        speed: 15,
      );
      add(cloudTwo .. priority = -3);

      final cloudThree = SingleCloudComponent(
        name: 'Small Cloud 3.png',
        position: Vector2(gameRef.size.x - 730, 180),
        size: Vector2(74, 24),
        speed: 15,
      );
      add(cloudThree .. priority = -3);


      final waterReflect = WaterReflect();
      add(waterReflect);

      add(clouds .. priority = -3);
      add(backgroundTile ..priority = -10);
      add(fullBackgroundTile ..priority = -20);
    }
  }

  void _spawningObjects() {
    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoints');

    if (spawnPointsLayer != null) {
      for (final spawnPoint in spawnPointsLayer.objects) {
        switch (spawnPoint.class_) {
          case 'Player':
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            player.scale.x = 1;
            add(player);
            break;
          case 'Fruit':
            final fruit = Fruit(
              fruit: spawnPoint.name,
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(fruit);
            break;
          case 'Saw':
            final isVertical = spawnPoint.properties.getValue('isVertical');
            final offNeg = spawnPoint.properties.getValue('offNeg');
            final offPos = spawnPoint.properties.getValue('offPos');
            final saw = Saw(
              isVertical: isVertical,
              offNeg: offNeg,
              offPos: offPos,
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(saw);
            break;
          case 'Checkpoint':
            final checkpoint = Checkpoint(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
            );
            add(checkpoint);
            break;
          case 'Chicken':
            final offNeg = spawnPoint.properties.getValue('offNeg');
            final offPos = spawnPoint.properties.getValue('offPos');
            final chicken = Chicken(
              position: Vector2(spawnPoint.x, spawnPoint.y),
              size: Vector2(spawnPoint.width, spawnPoint.height),
              offNeg: offNeg,
              offPos: offPos,
            );
            add(chicken);
            break;
          default:
        }
      }
    }
  }

  void _addCollisions() {
    final collisionsLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');

    if (collisionsLayer != null) {
      for (final collision in collisionsLayer.objects) {
        switch (collision.class_) {
          case 'Platform':
            final platform = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
              isPlatform: true,
            );
            collisionBlocks.add(platform);
            add(platform);
            break;
          default:
            final block = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
            );
            collisionBlocks.add(block);
            add(block);
        }
      }
    }
    player.collisionBlocks = collisionBlocks;
  }
}
