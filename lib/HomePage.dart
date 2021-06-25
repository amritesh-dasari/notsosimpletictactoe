import 'dart:math';
import 'package:flutter/material.dart';
import 'package:notsosimpletictactoe/GameButton.dart';
import 'package:notsosimpletictactoe/custom_dialog.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<GameButton> buttonsList;
  var player1;
  var player2;
  var activeplayer;
  var board;

  @override
  void initState() {
    super.initState();
    buttonsList = doInit();
  }

  List<GameButton> doInit() {
    board = [
      ['_', '_', '_'],
      ['_', '_', '_'],
      ['_', '_', '_']
    ];
    player1 = [];
    player2 = [];
    activeplayer = 1;
    var gameButtons = <GameButton>[
      new GameButton(id: 1),
      new GameButton(id: 2),
      new GameButton(id: 3),
      new GameButton(id: 4),
      new GameButton(id: 5),
      new GameButton(id: 6),
      new GameButton(id: 7),
      new GameButton(id: 8),
      new GameButton(id: 9),
    ];
    return gameButtons;
  }

  void playGame(GameButton gb) {
    setState(() {
      if (activeplayer == 1) {
        gb.text = "X";
        gb.bg = Colors.red.shade500;
        activeplayer = 2;
        player1.add(gb.id);
        boardupdate(gb.id, 1);
      } else if (activeplayer == 2) {
        gb.text = "O";
        gb.bg = Colors.black45;
        activeplayer = 1;
        player2.add(gb.id);
        boardupdate(gb.id, 2);
      }
      gb.enabled = false;
      int winner = checkWinner();
      if (winner == -1) {
        if (buttonsList.every((element) => element.text != "")) {
          showDialog(
              context: context,
              builder: (_) => new CustomDialog(
                  "Game Tied!", "Press reset to play again", resetGame));
        } else {
          activeplayer == 2 ? autoPlay() : null;
        }
      }
    });
  }

  boardupdate(int pos, int player) {
    if (player == 1) {
      if (pos >= 1 && pos <= 3) {
        board[0][pos - 1] = 'X';
      } else if (pos >= 4 && pos <= 6) {
        board[1][pos - 4] = 'X';
      } else if (pos >= 7 && pos <= 9) {
        board[2][pos - 7] = 'X';
      }
    } else if (player == 2) {
      if (pos >= 1 && pos <= 3) {
        board[0][pos - 1] = 'O';
      } else if (pos >= 4 && pos <= 6) {
        board[1][pos - 4] = 'O';
      } else if (pos >= 7 && pos <= 9) {
        board[2][pos - 7] = 'O';
      }
    }
    print(board);
  }

  void autoPlay() {
    var bestval = -1000;
    var bestMove = [-1, -1];
    for (var i = 0; i < 3; i++) {
      for (var j = 0; j < 3; j++) {
        if (board[i][j] == '_') {
          board[i][j] = 'O';
          var moveVal = minimax(0, false);
          board[i][j] = '_';
          if (moveVal > bestval) {
            bestMove = [i, j];
            bestval = moveVal;
          }
        }
      }
    }
    if (bestMove[0] == 0 && bestMove[1] == 0) {
      board[0][0] = 'O';
      playGame(buttonsList[0]);
    } else if (bestMove[0] == 0 && bestMove[1] == 1) {
      board[0][1] = 'O';
      playGame(buttonsList[1]);
    } else if (bestMove[0] == 0 && bestMove[1] == 2) {
      board[0][2] = 'O';
      playGame(buttonsList[2]);
    } else if (bestMove[0] == 1 && bestMove[1] == 0) {
      board[1][0] = 'O';
      playGame(buttonsList[3]);
    } else if (bestMove[0] == 1 && bestMove[1] == 1) {
      board[1][1] = 'O';
      playGame(buttonsList[4]);
    } else if (bestMove[0] == 1 && bestMove[1] == 2) {
      board[1][2] = 'O';
      playGame(buttonsList[5]);
    } else if (bestMove[0] == 2 && bestMove[1] == 0) {
      board[2][0] = 'O';
      playGame(buttonsList[6]);
    } else if (bestMove[0] == 2 && bestMove[1] == 1) {
      board[2][1] = 'O';
      playGame(buttonsList[7]);
    } else if (bestMove[0] == 2 && bestMove[1] == 2) {
      board[2][2] = 'O';
      playGame(buttonsList[8]);
    }
  }

  int minimax(int depth, bool isMax) {
    int score = evaluateBoard(depth, board);
    if (score == 10) {
      return score;
    }
    if (score == -10) {
      return score;
    }
    if (isMoveLeft() == false) {
      return 0;
    }
    if (isMax) {
      var best = -1000;
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          if (board[i][j] == '_') {
            board[i][j] = 'O';
            best = max(best, minimax(depth + 1, !isMax));
            board[i][j] = '_';
          }
        }
      }
      return best;
    } else {
      var best = 1000;
      for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
          if (board[i][j] == '_') {
            board[i][j] = 'X';
            best = min(best, minimax(depth + 1, !isMax));
            board[i][j] = '_';
          }
        }
      }
      return best;
    }
  }

  isMoveLeft() {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j] == '_') {
          return true;
        }
      }
    }
    return false;
  }

  int evaluateBoard(int depth, var board) {
    for (int i = 0; i < 3; i++) {
      if ((board[i][0] == board[i][1]) && (board[i][1] == board[i][2])) {
        if (board[i][0] == 'O') {
          return 10;
        } else if (board[i][0] == 'X') {
          return -10;
        }
      }
    }

    for (int i = 0; i < 3; i++) {
      if ((board[0][i] == board[1][i]) && (board[1][i] == board[2][i])) {
        if (board[0][i] == 'O') {
          return 10;
        } else if (board[0][1] == 'X') {
          return -10;
        }
      }
    }

    if ((board[0][0] == board[1][1]) && (board[1][1] == board[2][2])) {
      if (board[0][0] == 'O') {
        return 10;
      } else if (board[0][0] == 'X') {
        return -10;
      }
    }

    if ((board[0][2] == board[1][1]) && (board[1][1] == board[2][0])) {
      if (board[0][2] == 'O') {
        return 10;
      } else if (board[0][2] == 'X') {
        return -10;
      }
    }

    return 0;
  }

  int checkWinner() {
    var winner = -1;
    //row 1
    if (player1.contains(1) && player1.contains(2) && player1.contains(3)) {
      winner = 1;
    }
    if (player2.contains(1) && player2.contains(2) && player2.contains(3)) {
      winner = 2;
    }

    //row 2
    if (player1.contains(4) && player1.contains(5) && player1.contains(6)) {
      winner = 1;
    }
    if (player2.contains(4) && player2.contains(5) && player2.contains(6)) {
      winner = 2;
    }

    //row 3
    if (player1.contains(7) && player1.contains(8) && player1.contains(9)) {
      winner = 1;
    }
    if (player2.contains(7) && player2.contains(8) && player2.contains(9)) {
      winner = 2;
    }

    //col 1
    if (player1.contains(1) && player1.contains(4) && player1.contains(7)) {
      winner = 1;
    }
    if (player2.contains(1) && player2.contains(4) && player2.contains(7)) {
      winner = 2;
    }

    //col 2
    if (player1.contains(2) && player1.contains(5) && player1.contains(8)) {
      winner = 1;
    }
    if (player2.contains(2) && player2.contains(5) && player2.contains(8)) {
      winner = 2;
    }

    //col 3
    if (player1.contains(3) && player1.contains(6) && player1.contains(9)) {
      winner = 1;
    }
    if (player2.contains(3) && player2.contains(6) && player2.contains(9)) {
      winner = 2;
    }

    //diagonal 1
    if (player1.contains(1) && player1.contains(5) && player1.contains(9)) {
      winner = 1;
    }
    if (player2.contains(1) && player2.contains(5) && player2.contains(9)) {
      winner = 2;
    }

    //diagonal 2
    if (player1.contains(3) && player1.contains(5) && player1.contains(7)) {
      winner = 1;
    }
    if (player2.contains(3) && player2.contains(5) && player2.contains(7)) {
      winner = 2;
    }

    if (winner != -1) {
      if (winner == 1) {
        showDialog(
            context: context,
            builder: (_) => new CustomDialog(
                "Player 1 Won!", "Press reset to play again", resetGame));
      } else {
        showDialog(
            context: context,
            builder: (_) => new CustomDialog(
                "Computer Won!", "Press reset to play again", resetGame));
      }
    }
    return winner;
  }

  void resetGame() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
    setState(() {
      buttonsList = doInit();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Not So Simple Tic-Tac-Toe"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: GridView.builder(
                itemCount: buttonsList.length,
                padding: const EdgeInsets.all(10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 9.0,
                    mainAxisSpacing: 9.0),
                itemBuilder: (context, i) => new SizedBox(
                      width: 100,
                      height: 100,
                      child: RaisedButton(
                        padding: const EdgeInsets.all(8.0),
                        onPressed: buttonsList[i].enabled
                            ? () => playGame(buttonsList[i])
                            : null,
                        child: Text(
                          buttonsList[i].text,
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        color: buttonsList[i].bg,
                        disabledColor: buttonsList[i].bg,
                      ),
                    )),
          ),
          RaisedButton(
            onPressed: resetGame,
            child: Text(
              "Reset Game",
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
            color: Colors.red,
            padding: EdgeInsets.all(20.0),
          ),
          SizedBox(
            height: 15,
          )
        ],
      ),
    );
  }
}
