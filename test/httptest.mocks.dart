import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:codexplore_game/main.dart';
import 'package:http/testing.dart';
// import 'package:http/testing.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
// import './httptest.mocks.mocks.dart' as MockClient;
import 'httptest.mocks.mocks.dart' as m;

// Generate a MockClient using the Mockito package.
// Create new instances of this class in each test.
@GenerateMocks([http.Client])
void main() {
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
      // await tester.pumpWidget(const MyApp());

      // final radioFinder = find.byWidgetPredicate(
      //       (widget) => widget is Radio<int>,
      //     );

      // expect(radioFinder, findsNWidgets(2));
    // await tester.enterText(find.byType(TextField), 'player1');

  }
  );
  
}