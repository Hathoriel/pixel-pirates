import 'dart:async';

import 'package:flame/components.dart';

class WaterBackgroundTile extends SpriteComponent with HasGameRef {
  WaterBackgroundTile({
    position,
    size,
  }) : super(
          size: size,
          position: position,
        );

  @override
  FutureOr<void> onLoad() async {
    sprite = await gameRef.loadSprite('Background/Additional Water.png');
    return super.onLoad();
  }
}
