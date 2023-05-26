// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:codexplore_game/elements/map_pointer_component.dart';
import 'package:codexplore_game/game_design_screen.dart';
import 'package:codexplore_game/vehicle_design_screen.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:codexplore_game/main.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mockito/annotations.dart';

import 'package:mockito/mockito.dart';
import 'httptest.mocks.mocks.dart' as m;

@GenerateMocks([http.Client])
void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('Username'), findsOneWidget);
    // expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    // await tester.tap(find.byIcon(Icons.add));
    // await tester.pump();

    // // Verify that our counter has incremented.
    // expect(find.text('0'), findsNothing);
    // expect(find.text('1'), findsOneWidget);
  }
  );

  testWidgets('Test 2 player mode toggle', (WidgetTester tester) async {
    // Build our app and trigger a frame.

   
      await tester.pumpWidget(const MyApp());

      // Verify that our counter starts at 0.
      // expect(find.text('0'), findsOneWidget);
      // expect(find.text('1'), findsNothing);

      final radioFinder = find.byWidgetPredicate(
            (widget) => widget is Radio<int>,
          );

      expect(radioFinder, findsNWidgets(2));


    // await tester.pumpWidget(const MyApp());

    // // Verify that our counter starts at 0.
    // // expect(find.text('0'), findsOneWidget);
    // // expect(find.text('1'), findsNothing);

    // final radioFinder = find.byWidgetPredicate(
    //       (widget) => widget is Radio<int>,
    //     );

    // expect(radioFinder, findsNWidgets(2));



    await tester.enterText(find.byType(TextField), 'player1');

    expect(find.text("player1"), findsOneWidget);

    // // Tap the '+' icon and trigger a frame.
    // await tester.tap(find.byIcon(Icons.add));
    // await tester.pump();

    // // Verify that our counter has incremented.
    // expect(find.text('0'), findsNothing);
    // expect(find.text('1'), findsOneWidget);
  }
  );

  test('Http request mocking test', () async {
    // Build our app and trigger a frame.
    // MockClientHandler req;
    final client = m.MockClient();

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(client
              .get(Uri.parse('http://localhost:3000/api/v1/user/validate-user?user=playerA'),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                }
              ))
          .thenAnswer((_) async =>
              http.Response('{"success":true,"status":200,"data":{"message":"User information not found"}}', 200));

      final gameData = GameData(playerA: "playerA");
      expect(await createGameInit(client, gameData), isA<GameBuildData>());
    // await tester.enterText(find.byType(TextField), 'player1');

  }
  );


  testWidgets('Test image tap on Design Screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // MockClientHandler req;
    final client = m.MockClient();

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(client
              .get(Uri.parse('http://localhost:3000/api/v1/user/validate-user?user=playerA'),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                }
              ))
          .thenAnswer((_) async =>
              http.Response('{"success":true,"status":200,"data":{"message":"User information not found"}}', 200));

      const testKey = Key('K');
      await tester.pumpWidget(GameDesignScreen(session_id:""));

      // Verify that our counter starts at 0.
      // expect(find.text('0'), findsOneWidget);
      // expect(find.text('1'), findsNothing);

      tester.tap(find.byType(GameWidget));

      // tester.tap(find.byType(ElevatedButton));

      // expect(radioFinder, findsNWidgets(2));
      // await tester.pumpWidget(const MyApp());

      // final radioFinder = find.byWidgetPredicate(
      //       (widget) => widget is Radio<int>,
      //     );

      // expect(radioFinder, findsNWidgets(2));
    // await tester.enterText(find.byType(TextField), 'player1');

  }
  );

  testWidgets('Verify number of buttons on Vehicle Design Screen', (WidgetTester tester) async {

      var gds = GameDesignScreen(session_id: "session_id");

      await tester.pumpWidget(GameDesignScreen(session_id: "session_id"));

      expect(find.byType(ElevatedButton), findsNWidgets(2));

  }
  );

  

  
}
