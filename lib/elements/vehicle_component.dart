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

class VehicleComponent extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef {
  final CodexploreGame game;
  VehicleComponent({required this.game});
  
  late SpriteAnimation downAnimation;
  late SpriteAnimation leftAnimation;
  late SpriteAnimation rightAnimation;
  late SpriteAnimation upAnimation;
  late SpriteAnimation idleAnimation;
  final double animationSpeed = .1;

  late Vector2 _vehicleVelocity;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final spriteSheet = SpriteSheet(
        image: await gameRef.images.load('car-posture.png'),
        srcSize: Vector2(48, 48));

    add(RectangleHitbox(size: Vector2.all(100)));
    downAnimation =
        spriteSheet.createAnimation(row: 0, stepTime: animationSpeed, to: 4);
    leftAnimation =
        spriteSheet.createAnimation(row: 1, stepTime: animationSpeed, to: 4);
    upAnimation =
        spriteSheet.createAnimation(row: 2, stepTime: animationSpeed, to: 4);
    rightAnimation =
        spriteSheet.createAnimation(row: 3, stepTime: animationSpeed, to: 4);
    idleAnimation =
        spriteSheet.createAnimation(row: 0, stepTime: animationSpeed, to: 1);
    animation = idleAnimation;
  }

  @override
  void update(double dt) {
    if (!game.showDialog) {
      // print(vVelocity);
      // print(vVelocity.x);
      if (y < game.mapHeight - height && x > 0 && y > 0 && x < game.mapWidth - width) {
        x += dt * _vehicleVelocity.x * game.vehicleSpeed; //game.vehicleSpeed;
        y += dt * _vehicleVelocity.y * game.vehicleSpeed; //game.vehicleSpeed;
      }
      

      switch (game.direction) {
        case 0:
          animation = idleAnimation;
          break;
        case 1:
          animation = downAnimation;
          if (y < game.mapHeight - height) {
            if (game.collisionDirection != 1) {
              y += dt * game.vehicleSpeed;
            }

          }
          break;
        case 2:
          animation = leftAnimation;
          if (x > 0) {
            if (game.collisionDirection != 2) {
              x -= dt * game.vehicleSpeed;
            }
          }

          break;
        case 3:
          animation = upAnimation;
          if (y > 0) {
            if (game.collisionDirection != 3) {
              y -= dt * game.vehicleSpeed;
            }
          }

          break;
        case 4:
          animation = rightAnimation;
          if (x < game.mapWidth - width) {
            if (game.collisionDirection != 4) {
              x += dt * game.vehicleSpeed;
            }
          }
          break;
      }
    }
    super.update(dt);
  }

  void move(targetPosition) {
    print("Original Positions");
    print(targetPosition);
    print(this.position);
    Vector2 diff = Vector2((targetPosition.x - position.x), (targetPosition.y - position.y));
    var mVelocity = sqrt((diff.x * diff.x - diff.y * diff.y).abs());
    
    _vehicleVelocity = Vector2(diff.x/mVelocity, diff.y/mVelocity);
    var checkVal = sqrt((_vehicleVelocity.x * _vehicleVelocity.x - _vehicleVelocity.y * _vehicleVelocity.y).abs());
    print("Calculated Positions");
    print(checkVal);
    print(diff);
    print(mVelocity);
    print(_vehicleVelocity);
  }

  void moveVehicle(targetPosition) {

    Vector2 diff = Vector2((targetPosition.x - position.x), (targetPosition.y - position.y));
    var mVelocity = sqrt((diff.x * diff.x - diff.y * diff.y).abs());
    
    _vehicleVelocity = Vector2(diff.x/mVelocity, diff.y/mVelocity);
    var checkVal = sqrt((_vehicleVelocity.x * _vehicleVelocity.x - _vehicleVelocity.y * _vehicleVelocity.y).abs());
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is PortableComponent) {
      // var message = '';
        // print("Collision with portable");
        // game.dialogMessage =
        //     'Just picked up a portable';
      
    }

    print("Collision");

    super.onCollision(intersectionPoints, other);
  }
}
