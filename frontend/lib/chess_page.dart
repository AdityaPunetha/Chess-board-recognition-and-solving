import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';

class ChessPage extends StatefulWidget {
  const ChessPage({Key? key, required String fen}) : super(key: key);

  @override
  _ChessPageState createState() => _ChessPageState();
}

class _ChessPageState extends State<ChessPage> {
  ChessBoardController controller = ChessBoardController();
  var toMove = <bool>[true, false];
  var castlingAvailibility = <bool>[true, true, true, true];
  var nextColorFEN = 'w';
  var cAvalFEN = '';

  void loadFen() {
    controller.loadFen(
        'r3kbnr/pbp3pp/p2p4/3Ppq2/2P5/2N2N2/PP3PPP/R1BQ1RK1 w kq - 0 11');
  }

  @override
  Widget build(BuildContext context) {
    if (toMove[0]) {
      nextColorFEN = 'w';
    } else {
      nextColorFEN = 'b';
    }
    for (int button = 0; button < 4; button++) {
      const _map = ['K', 'Q', 'k', 'q'];
      if (castlingAvailibility[button]) {
        cAvalFEN = cAvalFEN + _map[button];
      }
    }
    var fen =
        'r3kbnr/pbp3pp/p2p4/3Ppq2/2P5/2N2N2/PP3PPP/R1BQ1RK1 $nextColorFEN $cAvalFEN - 0 1';

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
          // Expanded(
          //   child: ValueListenableBuilder<Chess>(
          //     valueListenable: controller,
          //     builder: (context, game, _) {
          //       return Text(
          //         controller.getSan().fold(
          //               '',
          //               (previousValue, element) =>
          //                   previousValue + '\n' + (element ?? ''),
          //             ),
          //       );
          //     },
          //   ),
          // ),
          ElevatedButton(
              onPressed: loadFen, child: const Text('Calculate Next Move')),
          const Text('To Move'),
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
          const Text('Castling Availibility'),
          ToggleButtons(
            children: const <Widget>[
              Text('K'),
              Text('Q'),
              Text('k'),
              Text('q')
            ],
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
