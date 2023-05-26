// import 'package:codexplore_game/game_design_screen.dart';
import 'dart:async';
import 'dart:io';

import 'package:codexplore_game/loaders/load_game_points.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/image_composition.dart';
import 'package:flame/input.dart';
import 'package:flame_audio/audio_pool.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_tiled/flame_tiled.dart' as ft;
// import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'elements/map_pointer_component.dart';
import 'overlays/overlay_controller.dart';
import 'overlays/dialog_overlay.dart';
import 'package:http/http.dart' as http;
import 'codexplore_game.dart';
import 'dart:convert';

//List of prorgrammable options - base class
abstract class ListItem {
  Widget buildTitle(BuildContext context);
  Widget buildSubTitle(BuildContext context);
}

class ProgrammableOption implements ListItem {
  final String Category;
  final String Name;

  ProgrammableOption(this.Category, this.Name);

  @override
  Widget buildSubTitle(BuildContext context) {
    // TODO: implement buildSubTitle
    throw UnimplementedError();
  }

  @override
  Widget buildTitle(BuildContext context) {
    return(Text(
      Name,
      style: TextStyle(
                  color: Color.fromARGB(255, 47, 79, 79),
                  fontWeight: FontWeight.w500,
                  fontSize: 30)));
  }
}

//Creating Dropdown for Vehicle Design
// List<String> test_list = <String>['immovable', 'passage', 'portable'];
class DropdownButtonOptions extends StatefulWidget {
  List<String> list;
  DropdownButtonOptions({super.key, required this.list}){
    print(this.list);
  }

  @override
  State<DropdownButtonOptions> createState() => _DropdownButtonState();
}

class _DropdownButtonState extends State<DropdownButtonOptions> {
  // String dropdownValue = test_list.first;
  String dropdownValue = "portable";

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple, fontSize: 20),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        print(value);
        setState(() {
          dropdownValue = value!;
        });
      },
      items: widget.list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class VehicleDesignScreen extends StatelessWidget {
  

  // late final DesignScreen dscreenRef;
  static const String _title = 'Design Vehicle';
  static const _primaryColor = Color.fromARGB(255, 10, 40, 40);
  late final _GameDesignScreen desCreen;
  late final userCommands;

  late String gameStartInfo;

  VehicleDesignScreen(String value, _GameDesignScreen curr, {Key? key}) : super(key: key){
    gameStartInfo = value;
    desCreen = curr;
  }
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: gameStartInfo,
      theme: ThemeData(
        primaryColor: _primaryColor,
      ),
    //   routes: {
    //       '/game': (context) => desCreen,
    // // When navigating to the "/second" route, build the SecondScreen widget.
    //       '/design': (context) => this,
    //     },
      home: Scaffold(
        appBar: AppBar(
          title: const Text(_title),
          backgroundColor: _primaryColor,
          ),
        body: MyStatefulWidget(p: gameStartInfo, ds: desCreen),
      ),
    );
  }


}

enum UIScreen {
  gamescreen,
  designscreen
}

class GameDesignScreen extends StatefulWidget {

  final UIScreen currIndex = UIScreen.gamescreen;
  final String session_id;

  GameDesignScreen({required this.session_id}){
  }

  final _GameDesignScreen state = _GameDesignScreen();

  State<StatefulWidget> createState() => state;
}


class _GameDesignScreen extends State<GameDesignScreen> with WidgetsBindingObserver {
  
  static const String _title = 'Design Vehicle';
  static const _primaryColor = Color.fromARGB(255, 10, 40, 40);
  late final _designScreen = DesignScreen(vd: this); //Map

  UIScreen currentScreen = UIScreen.designscreen;
 
  late final GameWidget gw = GameWidget(game: _designScreen);
  late final _vehicleDesignScreen = VehicleDesignScreen("user", this);

  late String gameStartInfo;

  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    currentScreen = widget.currIndex;
  }

  void update() {
    setState(() {});
  }

  _GameDesignScreen({Key? key}) {
    // gameStartInfo = value;
  }
 
  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     debugShowCheckedModeBanner: false,
  //     title: _title,
  //     theme: ThemeData(
  //       primaryColor: _primaryColor,
  //     ),
  //     home: Scaffold(
  //       appBar: AppBar(
  //         title: const Text(_title),
  //         backgroundColor: _primaryColor,
  //         ),
  //       body: MyStatefulWidget(p: gameStartInfo),
  //     ),
  //   );
  // }

  //New Widget using game for gestures
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      theme: ThemeData(
        primaryColor: _primaryColor,
      ),
      home: Scaffold(
        
        body: IndexedStack(
          sizing: StackFit.expand,
          children: [
            Positioned.fill(child: gw),
            Positioned.fill(child: _vehicleDesignScreen)
          ],
          index: currentScreen.index,
        )
      ),
    );
  }
}
 
class MyStatefulWidget extends StatefulWidget {
  final String p;
  _GameDesignScreen ds;

  // updateScreen(val){
  //   ds = val;
  // }

  MyStatefulWidget({Key? key, required this.p, required this.ds}) : super(key: key);
  
 
  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

// class GameApp extends StatelessWidget {

//   @override
//   Widget build(BuildContext context){
//     GameWidget(
//       game: CodexploreGame(ModalRoute.of(context)!.settings.arguments as String),
//       overlayBuilderMap: {
//         'ButtonController': (BuildContext context, CodexploreGame game) {
//           return OverlayController(
//             game: game,
//           );
//         }
//       },
//     );
//   }

    
//   }

//Implements Notifier for Game
class OverlayNotifier extends ChangeNotifier {

  sendNotification() {
    notifyListeners();
  }
}

//Implements Notifier for Game
class GameElementsNotifier extends ChangeNotifier {

  notification() {
    notifyListeners();
  }
}

class NotifierApp extends StatelessWidget {

  // NotifierApp(super.value);
  // CodexploreGame(ModalRoute.of(context)!.settings.arguments as String)
  final String inputData = "";
  CodexploreGame game = CodexploreGame("New Game");

  NotifierApp({super.key, required inputData});

  @override
  MaterialApp build(BuildContext context) {
    // return (
    //   ChangeNotifierProvider(
    //   create: (context) => DialogOverlay(game: game,),
    //   builder: (context, child) {
         return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body:
            Consumer<OverlayNotifier>( builder:(context, dialogOverlay, child) =>  
             GameWidget(
              game: game,
              overlayBuilderMap: {
                'ButtonController': (BuildContext context, CodexploreGame game) {
                  // ChangeNotifierProvider(create: (_) => DialogOverlay(game: game),
                  // game = this.game;
                  return (OverlayController(
                    
                    game: this.game,
                  )
                  );
                  // );
                }
              },
            ),
          ),
          ),
        );
      // }
    // )
    // );


      

      // MaterialPageRoute(
      //   builder: (context) => 


    //     MaterialApp(
    //       debugShowCheckedModeBanner: false,
    //       home: Scaffold(
    //         body: GameWidget(
    //           game: CodexploreGame(ModalRoute.of(context)!.settings.arguments as String),
    //           overlayBuilderMap: {
    //             'ButtonController': (BuildContext context, CodexploreGame game) {
    //               // ChangeNotifierProvider(create: (_) => DialogOverlay(game: game),
    //               return (OverlayController(
    //                 game: game,
    //               )
    //               );
    //               // );
    //             }
    //           },
    //         ),
    //       ),
    //     )
    // );
    // );
  }
}
 
class _MyStatefulWidgetState extends State<MyStatefulWidget> with WidgetsBindingObserver{
  
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  int _choice = 1;
  String dummy = "dummy";
  static const _primaryColor = Color.fromARGB(255, 10, 40, 40);
  late Map userCommands;
  late final _GameDesignScreen gds;
  final http.Client _httpClient = http.Client();

  saveUserCommands(http.Client client, Map commands) async {

    final response = await client.post(
      Uri.parse('http://localhost:3000/api/v1/game/save_game'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(commands)
    );

    print("Call to save commands");
    print(response.body);

  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    userCommands = {};
    gds = widget.ds;
  }


  
   

  void _navigateToNextScreen(BuildContext _cont) {
    print(context.read());
    // Navigator.of(_cont).push(
    //   MaterialPageRoute(builder: (context) {
    //     return ChangeNotifierProvider(
    //       create: (context) => OverlayNotifier(),
    //       builder: (context, child) {
    //         return NotifierApp(inputData: "ModalRoute.of(_cont)!.settings.arguments" as String);
    //       });
    //   }

    Navigator.of(_cont).push(
      MaterialPageRoute(builder: (context) {
        return MultiProvider(
          providers: [
            Provider(create: (context) => GameElementsNotifier()),
            ChangeNotifierProvider(
          create: (context) => OverlayNotifier(),
          builder: (context, child) {
            return NotifierApp(inputData: "ModalRoute.of(_cont)!.settings.arguments" as String);
          }
          )
          ]
        );
      }
      

      
      ,
      // builder: (context) => MaterialApp(
      //   home: Scaffold(
      //     body: GameWidget(
      //       game: MyVehicleGame(),
      //       overlayBuilderMap: {
      //         'ButtonController': (BuildContext context, MyVehicleGame game) {
      //           return OverlayController(
      //             game: game,
      //           );
      //         }
      //       },
      //     ),
      //   ),
      // ),
      settings: RouteSettings(arguments: dummy)
  )
  );
  }
 
  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    return Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/vdes_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
          child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: Text(
                  widget.p,
                  style: TextStyle(
                      color: Color.fromARGB(255, 47, 79, 79),
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                )),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Configure Vehicle Behavior',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              height: 70,
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                style: style,
                onPressed: () {
                  //Write data to local storage
                  //Navigate to Map
                  print(context);

                  //add point to map
                  
                  
                  userCommands["1"] = nameController.text;
                  // userCommands.add(nameController.text); 
                  print(userCommands);

                  
                  
                  // Navigator.of(context).pushNamed("/game");
                  setState(() {
                    gds.currentScreen = UIScreen.gamescreen;
                    gds.update();
                  });
                  

                },
                child: const Text('Return To Map')

              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              // child: DropdownButtonOptions(
              //   list: const <String>['immovable', 'portable', 'passage'],
              // ),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 1,color: Color.fromARGB(2, 101, 220, 90)),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal)
                  ),
                  labelText: 'Comma seperated directions: N, E, W, S',
                ),
              ),
            )
            
       
            // ,
            // TextButton(
            //   onPressed: () {
            //     //forgot password screen
            //   },
            //   child: const Text('Forgot Password',),
            // )
            ,
            Container(
                height: 70,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: ElevatedButton(
                  style: style,
                  child: const Text('Play'),
                  onPressed: () {
                    print(nameController.text);
                    print(passwordController.text);

                    //Send user commands to database
                    saveUserCommands(_httpClient, userCommands);

        
                    _navigateToNextScreen(context);
                  },
                )
            ),
            Row(
              children: <Widget>[
                Container(
                  child: Text ("codexplore")
                ),
                // FutureBuilder<GameBuildData>(
                //   future: gbd,
                //   builder: (context, snapshot) {
                //     if (snapshot.hasData) {
                //       return Text(snapshot.data!.role);
                //     } else if (snapshot.hasError) {
                //       return Text('${snapshot.error}');
                //     }

                //     // By default, show a loading spinner.
                //     return const CircularProgressIndicator();
                //   },
                // )
                // ,
      
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ],
        )
        )
        );
  }
}


class DesignScreen extends FlameGame with TapDetector, DragCallbacks, HasCollisionDetection {
  late final homeMap;
  late MapPointerComponent mapPointer;
  late _GameDesignScreen vd;

  DesignScreen({required this.vd});

  late final RouterComponent router;

  // @override
  // void onLoad() {
    
  // }

  @override
  FutureOr<void> onLoad() async {
    // add(
    //   router = RouterComponent(
    //     routes: {
    //       'home': fg.Route(HomePage.new),
    //       'design': fg.Route(vd),
    //       // 'settings': fg.Route(SettingsPage.new, transparent: true),
    //       // 'pause': fg.PauseRoute(),
    //       // 'confirm-dialog': fg.OverlayRoute.existing(),
    //     },
    //     initialRoute: 'home',
    //   ),
    // );

    homeMap = await ft.TiledComponent.load('environment4.tmx', Vector2.all(32));
    add(homeMap);
    // print(homeMap.toString());

    mapPointer = MapPointerComponent(Vector2(0,0));
    add(mapPointer);


    print(homeMap);
    // print(homeMap);
    camera.followComponent(mapPointer,
        worldBounds: Rect.fromLTRB(0, 0, homeMap.tileMap.map.width * 32.0, homeMap.tileMap.map.height * 32.0));
  }

  @override
   void onDragStart(DragStartEvent event) {
    //  print(event.localPosition);
    // mapPointer.updatePosition(event.localPosition);
    //  homeMap.
   }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    // print(event);
    // mapPointer.updatePosition(event.localPosition);
  }

   @override
   void onDragEnd(DragEndEvent event) {
    print(event);
    vd.currentScreen = UIScreen.designscreen;
    vd.update();
  }

  @override
  void onTap() {
    // TODO: implement onTap
    print(buildContext!.widget);


    // vd.currentScreen = UIScreen.designscreen;
    // vd.update();



    // Navigator.of(buildContext!).pushNamed("/design");

    // Navigator.of(buildContext!).push(
    //   // 'design'
    //   // return Scaffold(
    //   //   appBar: AppBar(
    //   //     title: const Text(_title),
    //   //     backgroundColor: _primaryColor,
    //   //     ),
    //   //   body: MyStatefulWidget(p: gameStartInfo, ds: dscreenRef)
    //   // )

    //   MaterialPageRoute(builder: (buildContext) {
    //     return VehicleDesignScreen("Design");
    //   }
    //   )
    // );
    
  }
}