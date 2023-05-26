import 'package:flutter/material.dart';
import '../codexplore_game.dart';

class ScoreOverlay extends StatelessWidget {
  const ScoreOverlay({
    Key? key,
    required this.game,
  }) : super(key: key);

  final CodexploreGame game;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          color: const Color.fromARGB(167, 218, 218, 218),
          child: Image.asset(
            'assets/images/flower-overlay.png',
            scale: 8,
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        Container(
          color: const Color.fromARGB(167, 218, 218, 218),
          child: Text(
            '${game.maxPortables}',
            style: const TextStyle(fontSize: 28, color: Colors.black45),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Container(
          color: const Color.fromARGB(167, 218, 218, 218),
          child: Image.asset(
            'assets/images/door-overlay.png',
            scale: 10,
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        Container(
          color: const Color.fromARGB(167, 218, 218, 218),
          child: Text(
            '${game.bakedGoodsInventory}',
            style: const TextStyle(fontSize: 28, color: Colors.black45),
          ),
        ),
      ],
    );
  }
}
