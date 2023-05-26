import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'overlays/overlay_controller.dart';
import 'package:http/http.dart' as http;
import 'codexplore_game.dart';
import 'vehicle_design_screen.dart';
import 'overlays/dialog_overlay.dart';
import '';

//Dummy class to test return from backend server
class Test {
  static String status = "";
}

//loads data returned from server about game state
class GameBuildData {
  late final Map data;

  GameBuildData({required this.data});

  factory GameBuildData.fromJson(Map<String, dynamic> json) {
    return GameBuildData(
      data: json["data"]
    );
  }

}

//Sends data to server on initialization 
class GameData {
  final String playerA;
  var playerB;
  var numPlayers;

  GameData({required this.playerA, this.playerB,  this.numPlayers});

  String getPlayerA() {
    return playerA;
  }

  String getNumPlayers() {
    return numPlayers.toString();
  }

}

class CodeGameWidget extends GameWidget {

  late Game game;

  CodeGameWidget({required Game game}) : super(game: game) {
    this.game = game;
  }

  // const CodeGameWidget({Key? game}): super(game: MyVehicleGame());

  // @override
  // Widget(BuildContext context){
  //   game: MyVehicleGame(),
  //     overlayBuilderMap: {
  //       'ButtonController': (BuildContext context, MyVehicleGame game) {
  //         return OverlayController(
  //           game: game,
  //         );
  //       }
  //     }
  // }
  
  // @override
  // Widget build(BuildContext context) {
  //   // TODO: implement build
  //   return(GameWidget(
  //         game: this.game,
  //         overlayBuilderMap: {
  //           'ButtonController': (BuildContext context, MyVehicleGame game) {
  //             return OverlayController(
  //               game: game,
  //             );
  //           }
  //         },
  //       )
  //   );
  // }
}

//test
Future<bool> myFunc(bool b) async {

    return b;

}


Future<dynamic> myFunc2(http.Client client, GameData data) async {
  final response = await client.get(
    Uri.parse('http://localhost:3000/api/v1/user/validate-user?user=' + data.playerA),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    }
  );

    // print(response.body);
    return response;

}

//Init Game Call
Future<dynamic> initGame(http.Client client, var data) async {
  print("INIT DATA");
  print("___________________");
  print(jsonDecode(data["session_id"])["data"]);
  var sendData = {
    "session_id": jsonDecode(data["session_id"])["data"],
    "players": data["players"],
    "play_mode": data["play_mode"]
  };
  print(sendData);
  final response = await client.post(
    Uri.parse('http://localhost:3000/api/v1/game/create_game'),
    headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(sendData)
  );
  print(response.body);
  return response;

  // if (response.statusCode == 200) {
  //   return GameBuildData.fromJson(jsonDecode(response.body));
  // } 
  // else {
  //   print("Failed request");
  //   throw Exception('Failed to initialize game.');
  // }
}

//Creates Game request to be sent to server
Future<dynamic> createGameInit(http.Client client, var data) async {
  print(data);
  final response = await client.post(
    Uri.parse('http://localhost:3000/api/v1/user/user_game_init'),
    headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: data
  );
  print(response.body);
  return response;

  // if (response.statusCode == 200) {
  //   return GameBuildData.fromJson(jsonDecode(response.body));
  // } 
  // else {
  //   print("Failed request");
  //   throw Exception('Failed to initialize game.');
  // }
}


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();

  runApp(MyApp());
}

//Widget to toggle visibility - used for input on main screen
// and vehicle design screen
class MyToggleableInputWidget extends StatefulWidget {
  // final Function isVisible;
  late var visible;
  MyToggleableInputWidget({super.key, required this.visible});

  // late Function onVisChange;
  void onVisChange() {
  }
  
  @override
  _MyToggleableInputWidgetState createState() => _MyToggleableInputWidgetState();
}

//Implementation of state for Toggleable widget
class _MyToggleableInputWidgetState extends State<MyToggleableInputWidget> {
  
  bool _isVisible = true;
  TextEditingController secondNameController = TextEditingController();
  
  _MyToggleableInputWidgetState(); 

  @override
  onVisChange() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  @override
  void initState() {

    super.initState();
    _isVisible = widget.visible;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: widget.visible,
          child: TextField(
            controller: secondNameController,
            decoration: InputDecoration(
              labelText: 'Second Player Name',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}


class ErrorMessage extends StatefulWidget {

  late var visible;
  ErrorMessage({super.key, required this.visible});

  // late Function onVisChange;
  void onVisChange() {
  }
  
  @override
  _ErrorMessageState createState() => _ErrorMessageState();
}

//Implementation of state for Error Message
class _ErrorMessageState extends State<ErrorMessage> {
  bool _isVisible = true;
  TextEditingController secondNameController = TextEditingController();
  _ErrorMessageState(); 

  @override
  onVisChange() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  @override
  void initState() {
    super.initState();
    _isVisible = widget.visible;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: widget.visible,
          child: Text(
            "Username not found",
            style: TextStyle(color: Colors.redAccent, fontSize: 20),
            ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
 
  static const String _title = 'Codexplore';
  static const _primaryColor = Color.fromARGB(255, 10, 40, 40);
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      theme: ThemeData(
        primaryColor: _primaryColor,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(_title),
          backgroundColor: _primaryColor,
          ),
        body: const LaunchScreen(),
      ),
    );
  }
}
 
class LaunchScreen extends StatefulWidget {
  const LaunchScreen({Key? key}) : super(key: key);
 
  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}


 
class _LaunchScreenState extends State<LaunchScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  int _choice = 1;
  String dummy = "dummy";
  late GameData gameData;
  late Future<dynamic> gbd;
  var visibilityInput = false;
  late Future<bool> errorMsg;
  late bool erM;

  @override
  void initState() {
    super.initState();
    gameData = GameData(playerA: "cyclist");
    gbd = myFunc2(http.Client(), gameData);
    // var anon = Future<bool>(){return false};
    errorMsg = myFunc(false);
    erM = false;
    // secondPlayer = const MyToggleableInputWidget(visible: false);
  }
   

  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: GameWidget(
            game: CodexploreGame(ModalRoute.of(context)!.settings.arguments as String),
            overlayBuilderMap: {
              'ButtonController': (BuildContext context, CodexploreGame game) {
                return OverlayController(
                  game: game,
                );
              }
            },
          ),
        ),
      ),
      settings: RouteSettings(arguments: "role")
  )
  );
  }

  void _navigateToVehicleDesignScreen(BuildContext context, String session_id) {
    Navigator.of(context).push(
      MaterialPageRoute(  
        builder: (_) => 
        MaterialApp(
          debugShowCheckedModeBanner: false,
          // builder: (context, child) => VehicleScreen(ModalRoute.of(_)!.settings.arguments as String),
          initialRoute: '/game',
          routes: {
            '/game': (context) => GameDesignScreen(session_id: ModalRoute.of(_)!.settings.arguments as String), //ModalRoute.of(_)!.settings.arguments as String
          // When navigating to the "/second" route, build the SecondScreen widget.
          },
        ),
        settings: RouteSettings(arguments: 
          session_id
          
          )
      )
  );
  }

  @override
  Widget build(BuildContext context)  {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Codexplore',
                  style: TextStyle(
                      color: Color.fromARGB(255, 47, 79, 79),
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                )),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Teaching to code through exploration',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 1,color: MyApp._primaryColor),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal)
                  ),
                  labelText: 'User Name',
                ),
              ),
            )
            ,
        ListTile(
          title: const Text('1 Player'),
          leading: Radio<int>(
            value: 1,
            groupValue: _choice,
            onChanged: (int? value) {
              setState(() {
                _choice= value!;
              });
              visibilityInput = !visibilityInput;
            },
          ),
        )
        ,
        ListTile(
          title: const Text('2 Players'),
          leading: Radio<int>(
            value: 2,
            groupValue: _choice,
            onChanged: (int? value) {
              setState(() {
                _choice= value!;
              });
              visibilityInput = !visibilityInput;
            },
          ),
        )
            ,
            SizedBox(height: 20)
            ,
            MyToggleableInputWidget(visible: visibilityInput,)
            ,
            SizedBox(height: 20)
            ,
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  child: const Text('Start Game'),
                  onPressed: () {
                    setState(() {
                        
                          gameData = GameData(playerA: nameController.text);
                        gameData.numPlayers = _choice;  
                        myFunc2(http.Client() ,gameData).then((savedResponse)=>{
                          print(savedResponse.body),
                          if(savedResponse.statusCode == 200) {

                          createGameInit(http.Client(), savedResponse.body).then((sessionVal) => {
                            print("checking game session id"),
                            print(sessionVal),
                            // var gg = sessionVal.body,
                            if (sessionVal.statusCode == 200) {
                              print("inside call to session id"),
                              // GameBuildData.fromJson(jsonDecode(savedResponse.body)),
                              
                              //call to game init 
                              print(sessionVal.body),
                              print(_choice),
                              print({"players":[nameController]}),
                              initGame(http.Client(), {"session_id":sessionVal.body,"players":[{"S":nameController.text}],"play_mode":_choice}).then((initData)=>{
                                print("inside call to init Game"),
                                print(initData.body),
                                if(initData.statusCode == 200){
                                  _navigateToVehicleDesignScreen(context, jsonDecode(sessionVal.body)["data"])
                                }

                              }),
                              
                              
                              
                              //reset error message
                                errorMsg = myFunc(false),

                            } 
                            else {
                              print("Failed request"),
                              throw Exception('Failed to initialize game.')
                            }
                          }).then((value) => {
                            print("Value check"),
                            print(value),
                          
                          }).catchError((e) => {
                          // Can update using both, only using errorMsg currently
                            setState(() {
                              erM = true;
                            }),
                            errorMsg = myFunc(true),
                          })
                          } else {
                            setState(() {
                              erM = true;
                            }),
                            errorMsg = myFunc(true),

                          }
                        }).catchError((e) => {
                          // Can update using both, only using errorMsg currently
                          setState(() {
                            erM = true;
                          }),
                          errorMsg = myFunc(true),
                        }
                    );
                      
                    });

                  },
                )
            )
            ,
            Row(
              children: <Widget>[
                
                Container(
                  child: FutureBuilder<dynamic>(
                    future: gbd,
                    builder: (context, snapshot) {
                      if (snapshot.hasData || snapshot.data != null) {
                        var d = snapshot.data!;
                        return Container(
                          child: Text("")
                          );
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      // By default, show a loading spinner.
                      return const CircularProgressIndicator();
                    },
                  )
                ),
                Container(
                  child: FutureBuilder<bool>(
                    future: errorMsg,
                    builder: (context, snapshot) {
                      if (snapshot.hasData || snapshot.data != null) {
                        return Container(
                          child: ErrorMessage(visible: snapshot.data!)
                        );
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      //Return empty text if no data or error
                      return Text(" not found");
                    },
                  )
                )

              ]
              ,
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ],
        ));
  }
  
}
