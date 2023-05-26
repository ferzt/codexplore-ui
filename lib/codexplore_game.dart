
import 'package:codexplore_game/loaders/load_game_points.dart';
import 'package:codexplore_game/loaders/load_portables.dart';
import 'package:codexplore_game/overlays/dialog_overlay.dart';
import 'package:directed_graph/directed_graph.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/image_composition.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/audio_pool.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'elements/gamepoints.dart';
import 'elements/vehicle_component.dart';
import './models/Nodes.dart';
// import 'loaders/add_baked_goods.dart';
// import 'loaders/load_friends.dart';
// import 'loaders/load_obstacles.dart';



class CodexploreGame extends FlameGame with TapDetector, HasCollisionDetection {
  late VehicleComponent vehicle;
  late double mapWidth;
  late double mapHeight;
  late TiledComponent homeMap;
  late Vector2 startPoint;
  List<Component> componentList = [];
  List<TiledObject> gamePointsComponent = [];

  late String testInfo;

  CodexploreGame(String value){
    this.testInfo = value;
  }

  int comparator(String s1, String s2) => s1.compareTo(s2);
  int inverseComparator(String s1, String s2) => -comparator(s1, s2);

  // Constructing a graph from vertices.
  final path = DirectedGraph<Nodes>(
    {
      Nodes(Vector2(41.64,27.76)): {Nodes(Vector2(943.79,955.36))},
    }
  );

  // direction of Vehicle
  // 0=idle, 1=down, 2= left, 3= up, 4=right
  int direction = 0;
  // if collisionDirection is -1, there is no collision
  int collisionDirection = -1;
  //Location of vehicle in game - Node
  int currentLocation = 0;

  final double characterSize = 64;
  final double vehicleSpeed = 20;
  String soundTrackName = 'ukulele';

  int friendNumber = 0;
  int maxPortables = 0;
  int sceneNumber = 1;

  int bakedGoodsInventory = 0;
  int gemInventory = 0;

  late AudioPool yummy;
  late AudioPool applause;
  // late DialogBox dialogBox;
  bool showDialog = true;
  // bool showDialog = context.watch<>;

  String dialogMessage = 'Hi. Welcome to the Codexplore.';

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    homeMap = await TiledComponent.load('environment4.tmx', Vector2.all(32));
    add(homeMap);

    mapWidth = homeMap.tileMap.map.width * 32.0;
    mapHeight = homeMap.tileMap.map.height * 32.0;

    // load characters and players
    // addBakedGoods(homeMap, this);
    loadGamePoints(homeMap, this);
    loadPortables(homeMap, this);

    // loadObstacles(homeMap, this);

    // yummy = await AudioPool.create('yummy.mp3');
    // applause = await AudioPool.create('applause.mp3');

    // FlameAudio.bgm.initialize();
    // FlameAudio.audioCache.load('music.mp3');
    // FlameAudio.bgm.play('music.mp3');
    overlays.add('ButtonController');
    

    vehicle = VehicleComponent(game: this)
      ..position = startPoint //Vector2(529, 128)
      ..debugMode = true
      ..size = Vector2.all(characterSize);
      // ..velocity = 
      

    add(vehicle);

    // var nextPoint = gpcomponent[currentLocation];
    // var nPvalue = nextPoint.properties["nextNode"]!.value;

    // for (var p in gpcomponent) {
      
    //   //Change to switch to trigger different patterns Object vs default vs User, in Vehicle Component
    //   if(p.properties["order"]!.value == nPvalue) {
    //     //
    //     print("Debugging.....");
    //     print(p.properties["order"]!.value);
    //     print(nPvalue);
    //     print("____________");
    //     vehicle.move(Vector2(p.x, p.y));
    //   }
    // }
    
    // vehicle.move(Vector2(nextPoint.x,nextPoint.y));
    // currentLocation++;

    print(testInfo);

    camera.followComponent(vehicle,
        worldBounds: Rect.fromLTRB(0, 0, mapWidth, mapHeight));
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // 0=idle, 1=down, 2= left, 3= up, 4=right
  }

  @override
  void onTapUp(TapUpInfo info) {
    direction += 1;
    if (direction > 4) {
      direction = 0;
    }
  }

  void newScene() async {
    String mapFile = 'other_map.tmx';
    print('change to a new scene');
    // remove old scene
    remove(homeMap);
    bakedGoodsInventory = 0;
    friendNumber = 0;
    maxPortables = 0;
    FlameAudio.bgm.stop();
    removeAll(componentList);
    componentList = [];
    showDialog = false;
    remove(vehicle);
    vehicle = VehicleComponent(game: this)
      ..position = Vector2(300, 128)
      // ..debugMode = true
      ..size = Vector2.all(characterSize);
    if (sceneNumber == 2) {
      print('moving to map2');
    } else if (sceneNumber == 3) {
      print('moving to scene 3');
      mapFile = 'scene3.tmx';
    } else if (sceneNumber == 4) {
      print('moving to scene 4');
      mapFile = 'scene4.tmx';
    }

    homeMap = await TiledComponent.load(mapFile, Vector2.all(16));
    add(homeMap);

    mapWidth = homeMap.tileMap.map.width * 16;
    mapHeight = homeMap.tileMap.map.height * 16;

    add(vehicle);
    camera.followComponent(vehicle,
        worldBounds: Rect.fromLTRB(0, 0, mapWidth, mapHeight));
  }
}
