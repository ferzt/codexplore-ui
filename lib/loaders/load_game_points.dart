import 'package:codexplore_game/codexplore_game.dart';
import 'package:codexplore_game/elements/gamepoints.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import '../elements/portables.dart';
import '../codexplore_game.dart';

void loadGamePoints(TiledComponent homeMap, CodexploreGame game) {
  final node = homeMap.tileMap.getLayer<ObjectGroup>('path');
  var index = 0;

  //Decide what screen player is coming from

  //get a subset of configurations for the game session 

  //During game play, get everything else, get specific attributes
  for (var obj in node!.objects) {
    if(index == 0){
      game.startPoint = Vector2(obj.x, obj.y);
    }
    print("Properties");
    print(obj.properties["order"]!.value);
    try {
      print(obj.properties["order"]!.value);
    } catch (ex){
      print(ex);
    }
    
    print(obj.x.toString() + " " + obj.y.toString());
    var portable = GamePointsComponent(game: game)
      ..position = Vector2(obj.x, obj.y)
      ..width = obj.width
      ..height = obj.height
      ..debugMode = true;
    game.gamePointsComponent.add(obj);
    game.add(portable);
    index++;
  }
}