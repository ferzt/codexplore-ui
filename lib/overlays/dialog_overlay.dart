import 'package:codexplore_game/codexplore_game.dart';
import 'package:codexplore_game/vehicle_design_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
// import '../codexplore_game.dart';
import 'package:codexplore_game/codexplore_game.dart';
import 'package:provider/provider.dart';

class DialogOverlay extends StatelessWidget with ChangeNotifier {
  DialogOverlay({Key? key, required this.game}) : super(key: key);

  final CodexploreGame game;

  @override
  Widget build(BuildContext context) {
    return game.showDialog
        ? Container(
            color: const Color.fromARGB(167, 218, 218, 218),
            child: AnimatedTextKit(
              animatedTexts: [
                TyperAnimatedText(
                  game.dialogMessage,
                  textStyle: const TextStyle(fontSize: 28, fontFamily: 'vt323'),
                  speed: const Duration(milliseconds: 100),
                ),
              ],
              isRepeatingAnimation: false,
              onFinished: () {
                print('text dialog is finished');
                game.showDialog = false;
                var _on = context.read<OverlayNotifier>();
                _on.sendNotification();

                // notifyListeners();
            
                // game.overlays.notifyListeners();
              },
            ),
          )
        : Container();
  }
}
