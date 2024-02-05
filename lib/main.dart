import 'package:flutter/material.dart';

void main() {
  runApp(TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TicTacToeGame(),
    );
  }
}

class TicTacToeGame extends StatefulWidget {
  @override
  _TicTacToeGameState createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  List<List<String>> board = List.generate(3, (index) => List.filled(3, ''));
  String currentPlayer = 'X';
  String winner = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            winner.isEmpty
                ? 'Current Player: $currentPlayer'
                : 'Winner: $winner',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: 9,
            itemBuilder: (context, index) {
              int row = index ~/ 3;
              int col = index % 3;

              return GestureDetector(
                onTap: () => _onCellTapped(row, col),
                child: Container(
                  color: Colors.greenAccent,
                  child: Center(
                    child: Text(
                      board[row][col],
                      style: TextStyle(fontSize: 40, color: Colors.black),
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _resetGame,
            child: Text('Reset Game'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: winner.isEmpty ? null : _startGame,
            child: Text('Start New Game'),
          ),
        ],
      ),
    );
  }

  void _onCellTapped(int row, int col) {
    if (board[row][col].isEmpty && winner.isEmpty) {
      setState(() {
        board[row][col] = currentPlayer;

        if (_checkWinner(row, col)) {
          setState(() {
            winner = currentPlayer;
          });
          _showResultDialog();
        } else if (_isBoardFull()) {
          _showResultDialog(draw: true);
        } else {
          currentPlayer = (currentPlayer == 'X') ? 'O' : 'X';
        }
      });
    }
  }

  bool _checkWinner(int row, int col) {
    // Check row
    if (board[row].every((element) => element == currentPlayer)) {
      return true;
    }

    // Check column
    if (List.generate(3, (index) => board[index][col])
        .every((element) => element == currentPlayer)) {
      return true;
    }

    // Check diagonals
    if ((row == col || row + col == 2) &&
        ((List.generate(3, (index) => board[index][index])
                .every((element) => element == currentPlayer)) ||
            (List.generate(3, (index) => board[index][2 - index])
                .every((element) => element == currentPlayer)))) {
      return true;
    }

    return false;
  }

  bool _isBoardFull() {
    return board.every((row) => row.every((cell) => cell.isNotEmpty));
  }

  void _resetGame() {
    setState(() {
      board = List.generate(3, (index) => List.filled(3, ''));
      currentPlayer = 'X';
      winner = '';
    });
  }

  void _startGame() {
    setState(() {
      _resetGame();
    });
  }

  void _showResultDialog({bool draw = false}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: draw ? Text('Draw!') : Text('Player $currentPlayer wins!'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
              child: Text('Play Again'),
            ),
          ],
        );
      },
    );
  }
}
