import 'package:codexplore_game/codexplore_game.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import '../elements/portables.dart';
import '../codexplore_game.dart';

void loadPortables(TiledComponent homeMap, CodexploreGame game) {
  final PortableGroup = homeMap.tileMap.getLayer<ObjectGroup>('Flower');
  
  for (var portableBox in PortableGroup!.objects) {
    print(portableBox);
    var portable = PortableComponent(game: game)
      ..position = Vector2(portableBox.x, portableBox.y)
      ..width = portableBox.width
      ..height = portableBox.height
      ..debugMode = true;
    game.maxPortables++;
    game.componentList.add(portable);
    game.add(portable);
    print(game.maxPortables);
  }
}