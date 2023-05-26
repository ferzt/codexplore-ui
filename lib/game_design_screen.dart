

// import 'dart:async';

// import 'package:codexplore_game/elements/map_pointer_component.dart';
// import 'package:codexplore_game/vehicle_design_screen.dart';
// import 'package:flame/events.dart';
// import 'package:flame/experimental.dart';
// import 'package:flame/game.dart';
// import 'package:flame/game.dart' as fg;
// import 'package:flame_tiled/flame_tiled.dart';
// import 'package:flutter/material.dart';

// // import _GameDesignScreen from './vehicle_design_screen.dart'

// class DesignScreen extends FlameGame with TapDetector, DragCallbacks, HasCollisionDetection {
//   late final homeMap;
//   late MapPointerComponent mapPointer;
//   late GameDesignScreen vd;

//   DesignScreen({required this.vd});

//   late final RouterComponent router;

//   // @override
//   // void onLoad() {
    
//   // }

//   @override
//   FutureOr<void> onLoad() async {
//     // add(
//     //   router = RouterComponent(
//     //     routes: {
//     //       'home': fg.Route(HomePage.new),
//     //       'design': fg.Route(vd),
//     //       // 'settings': fg.Route(SettingsPage.new, transparent: true),
//     //       // 'pause': fg.PauseRoute(),
//     //       // 'confirm-dialog': fg.OverlayRoute.existing(),
//     //     },
//     //     initialRoute: 'home',
//     //   ),
//     // );

//     homeMap = await TiledComponent.load('environment4.tmx', Vector2.all(32));
//     add(homeMap);
//     // print(homeMap.toString());

//     mapPointer = MapPointerComponent(Vector2(0,0));
//     add(mapPointer);


//     print(homeMap);
//     // print(homeMap);
//     camera.followComponent(mapPointer,
//         worldBounds: Rect.fromLTRB(0, 0, homeMap.tileMap.map.width * 32.0, homeMap.tileMap.map.height * 32.0));
//   }

//   @override
//    void onDragStart(DragStartEvent event) {
//      // Do something in response to a drag event
//      print(event.localPosition);
//     mapPointer.updatePosition(event.localPosition);
//     //  homeMap.
//    }

//   @override
//   void onDragUpdate(DragUpdateEvent event) {
//     // TODO: implement onDragUpdate
//     print(event);
//     mapPointer.updatePosition(event.localPosition);
//   }

//    @override
//    void onDragEnd(DragEndEvent event) {
//     // TODO: implement onDragEnd
//     print(event);
//   }

//   @override
//   void onTap() {
//     // TODO: implement onTap
//     print(buildContext!.widget);
//     Navigator.of(buildContext!).pushNamed("/design");
//     // Navigator.of(buildContext!).push(
//     //   // 'design'
//     //   // return Scaffold(
//     //   //   appBar: AppBar(
//     //   //     title: const Text(_title),
//     //   //     backgroundColor: _primaryColor,
//     //   //     ),
//     //   //   body: MyStatefulWidget(p: gameStartInfo, ds: dscreenRef)
//     //   // )

//     //   MaterialPageRoute(builder: (buildContext) {
//     //     return VehicleDesignScreen("Design");
//     //   }
//     //   )
//     // );
    
//   }
// }