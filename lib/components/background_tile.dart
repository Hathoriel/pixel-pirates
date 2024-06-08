import 'dart:async';

import 'package:flame/components.dart';

class BackgroundTile extends SpriteComponent with HasGameRef {
  BackgroundTile({
    position,
    size,
  }) : super(
    size: size,
    position: position,
  );

  @override
  FutureOr<void> onLoad() async {
    sprite = await gameRef.loadSprite('Background/background.png');
    return super.onLoad();
  }
}
