import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ChessBoardController controller = ChessBoardController();
  var toMove = <bool>[true, false];
  var castlingAvailibility = <bool>[true, true, true, true];

  void loadFen() {
    controller.loadFen(
        'r3kbnr/pbp3pp/p2p4/3Ppq2/2P5/2N2N2/PP3PPP/R1BQ1RK1 w kq - 0 11');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chess Demo'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: ChessBoard(
                controller: controller,
                boardColor: BoardColor.orange,
                boardOrientation: PlayerColor.white,
              ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<Chess>(
              valueListenable: controller,
              builder: (context, game, _) {
                return Text(
                  controller.getSan().fold(
                        '',
                        (previousValue, element) =>
                            previousValue + '\n' + (element ?? ''),
                      ),
                );
              },
            ),
          ),
          ElevatedButton(onPressed: loadFen, child: const Text('test')),
          ToggleButtons(
            children: const <Widget>[
              Text('White'),
              Text('Black'),
            ],
            onPressed: (int index) {
              setState(() {
                for (int buttonIndex = 0;
                    buttonIndex < toMove.length;
                    buttonIndex++) {
                  if (buttonIndex == index) {
                    toMove[buttonIndex] = true;
                  } else {
                    toMove[buttonIndex] = false;
                  }
                }
              });
            },
            isSelected: toMove,
          ),
          ToggleButtons(
            children: <Widget>[Text('K'), Text('Q'), Text('k'), Text('q')],
            onPressed: (int index) {
              setState(() {
                castlingAvailibility[index] = !castlingAvailibility[index];
              });
            },
            isSelected: castlingAvailibility,
          ),
        ],
      ),
    );
  }
}
