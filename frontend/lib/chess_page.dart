// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';
import 'package:stockfish/stockfish.dart';

class ChessPage extends StatefulWidget {
  final String fen;
  const ChessPage({Key? key, required this.fen}) : super(key: key);

  @override
  _ChessPageState createState() => _ChessPageState();
}

class _ChessPageState extends State<ChessPage> {
  // Stockfish init
  late Stockfish stockfish;

  @override
  void initState() {
    super.initState();
    stockfish = Stockfish();
  }

  // Chessboard init
  ChessBoardController controller = ChessBoardController();

  // Metadata
  var toMove = <bool>[true, false];
  var castlingAvailibility = <bool>[true, true, true, true];

  // FEN stuff
  var nextColorFEN = 'w';
  var cAvalFEN = '';

  //
  void loadFen() {
    controller.loadFen(
        'r3kbnr/pbp3pp/p2p4/3Ppq2/2P5/2N2N2/PP3PPP/R1BQ1RK1 w kq - 0 11');
  }

  //
  String _constructFEN(posi) {
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
    return '$posi $nextColorFEN $cAvalFEN - 0 1';
  }

  void _calculateMove() {
    String rawGetFen = controller.getFen();
    String processedFen = _constructFEN(rawGetFen.split(' ')[0]);
    String command = 'position fen $processedFen';
    stockfish.stdin = command;
    stockfish.stdin = 'go movetime 3000';
  }

  var stockfishOutput = 'ready';

  @override
  Widget build(BuildContext context) {
    //
    stockfish.stdout.listen((value) {
      setState(() {
        stockfishOutput = value;
      });
    });

    //
    String debugFEN =
        'r3kbnr/pbp3pp/p2p4/3Ppq2/2P5/2N2N2/PP3PPP/R1BQ1RK1 w kq - 0 11';
    controller.loadFen(debugFEN);
    var positionalFEN = widget.fen;

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
          Expanded(child: Text(stockfishOutput)),
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
