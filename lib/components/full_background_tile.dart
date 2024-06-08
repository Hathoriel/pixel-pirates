import 'dart:async';

import 'package:flame/components.dart';

class FullBackgroundTile extends SpriteComponent with HasGameRef {
  FullBackgroundTile({
    position,
    size,
  }) : super(
          size: size,
          position: position,
        );

  @override
  FutureOr<void> onLoad() async {
    sprite = await gameRef.loadSprite('Background/Additional Sky.png');
    return super.onLoad();
  }
}
