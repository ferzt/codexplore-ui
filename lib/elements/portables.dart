import 'package:codexplore_game/vehicle_design_screen.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'vehicle_component.dart';
import '../codexplore_game.dart';

class PortableComponent extends PositionComponent with CollisionCallbacks, ChangeNotifier, HasGameRef {
  final CodexploreGame game;
  PortableComponent({required this.game});

  @override
  Future<dynamic> onLoad() async {
    add(RectangleHitbox());
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    
    super.onCollision(intersectionPoints, other);
    if (other is VehicleComponent) {
      // var message = '';
        print("Collision with portable");
        game.dialogMessage =
            'Just picked up a portable';

        game.showDialog = true;
        game.direction = 4;
        var _on = game.buildContext!.read<OverlayNotifier>();
        // (ActiveOverlays); game.overlays
        // var _on = context.read<OverlayNotifier>();
        _on.sendNotification();
        gameRef.remove(this);
        
      
    } else {
      print("Collision");
    }

    // remove(this);
    

    
  }


  @override
  void onCollisionEnd(PositionComponent other) {
    // TODO: implement onCollisionEnd
    super.onCollisionEnd(other);
  }
}
