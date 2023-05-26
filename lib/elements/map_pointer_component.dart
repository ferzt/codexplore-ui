import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/sprite.dart';
import '../codexplore_game.dart';
import 'portables.dart';

import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';

class MapPointerComponent extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef {

  MapPointerComponent(Vector2 pos) {
    // super.velocity = 
    position = pos;
  }

  final double animationSpeed = .1;

  late Vector2 vVelocity;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final spriteSheet = SpriteSheet(
        image: await gameRef.images.load('pin-icon_48x48.jpeg'),
        srcSize: Vector2(48, 48));

    add(RectangleHitbox(size: Vector2.all(100)));

    var idleAnimation =
        spriteSheet.createAnimation(row: 0, stepTime: animationSpeed, to: 1);
    animation = idleAnimation;
    // new

    // position = Vector2(x, y);
 
  }

  @override
  void update(double dt) {
    
  }


  updatePosition(Vector2 newPos){
    position = newPos;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is PortableComponent) {
      
    }

    print("Collision");

    super.onCollision(intersectionPoints, other);
  }
}
