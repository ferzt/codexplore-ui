import 'package:codexplore_game/vehicle_design_screen.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'vehicle_component.dart';
import '../codexplore_game.dart';
import '../vehicle_design_screen.dart';

class GamePointsComponent extends PositionComponent with CollisionCallbacks, ChangeNotifier, HasGameRef {
  final CodexploreGame game;
  GamePointsComponent({required this.game});

  @override
  Future<dynamic> onLoad() async {
    add(RectangleHitbox());
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    
    super.onCollision(intersectionPoints, other);
    if (other is VehicleComponent) {
      // var message = '';
        print("Collision with game point");
        game.dialogMessage =
            'Engaging pattern';

        
        
        //Possibly pull start point from game table env info
        var nextPoint = game.gamePointsComponent[game.currentLocation];
        late var nPvalue;
        try {
          nPvalue = nextPoint.properties["nextNode"]!.value;
        } catch(ex){
          print(ex);
          game.dialogMessage = "You completed the game!";
          game.showDialog = true;
          game.direction = 0;
          var _on = game.buildContext!.read<OverlayNotifier>();
          // (ActiveOverlays); game.overlays
          // var _on = context.read<OverlayNotifier>();
          _on.sendNotification();

          //Send to router 
          Navigator.of(game.buildContext!).push(
      MaterialPageRoute(builder: (context) {
    
   
    
     
     

            return GameDesignScreen(session_id: "Blank"); //"repeat"
          
     
   

      }
      

      
      ,

      settings: RouteSettings(arguments: "game state")
  )
  );

        }
        
        var indexOfNext = 0;
        
        for (var p in game.gamePointsComponent) {
          //Change to switch to trigger different patterns Object vs default vs User, in Vehicle Component
          if(p.properties["order"]!.value == nPvalue) {
            //
            print("Debugging.....");
            print(p.properties["order"]!.value);
            print(nPvalue);
            print("____________");
            other.move(Vector2(p.x, p.y));
            game.currentLocation = indexOfNext;
          }
          indexOfNext++;
        }

        game.showDialog = true;
        game.direction = 0;
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
}
