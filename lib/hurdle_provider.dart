import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:english_words/english_words.dart' as words;
import 'package:word_hurdle/wordle.dart';

class HurdleProvider extends ChangeNotifier {
  final random = Random.secure();
  List<String> totalWords = [];
  List<String> rowInputs = [];
  List<String> excludedLetters = [];
  List<Wordle> hurdleBoard = [];
  String targetWord = "";
  int count = 0;
  int index = 0;
  final letterPerRow = 5;
  final totalAttempts = 6;
  int attempts = 0;
  bool wins = false;
  void initi() {
    totalWords = words.all.where((elemet) => elemet.length == 5).toList();
    generateBoard();
    generateRandomWord();
  }

  void generateBoard() {
    hurdleBoard = List.generate(30, (index) => Wordle(letter: ""));
  }

  void generateRandomWord() {
    targetWord = totalWords[random.nextInt(totalWords.length)].toUpperCase();
    print(targetWord);
  }

  bool get isAvalidWord =>
      totalWords.contains(rowInputs.join('').toLowerCase());

  bool get shouldCheckForAnswer => rowInputs.length == letterPerRow;

  bool get noAttemptsLeft => attempts == totalAttempts;

  void inputLetter(String letter) {
    if (count < letterPerRow) {
      count++;
      rowInputs.add(letter);
      hurdleBoard[index] = Wordle(
        letter: letter,
      ); //Meaning: “ Put this new object into this position.” LHS → hurdleBoard[index] (a position in the list)
      index++;
      //print(rowInputs);
      notifyListeners();
    }
  }

  void deleteLetter() {
    if (rowInputs.isNotEmpty) {
      rowInputs.removeAt(rowInputs.length - 1);
      //print(rowInputs);
    }
    if (count > 0) {}
    hurdleBoard[index - 1] = Wordle(letter: "");
    index--;
    count--;
    notifyListeners();
  }

  void checkAnswer() {
    final input = rowInputs.join('');
    if (input == targetWord) {
      wins = true;
    } else {
      _markLetterOnBoard();
      if (attempts < totalAttempts) {
        _goToNextRow();
      }
    }
  }

  void _markLetterOnBoard() {
    for (int i = 0; i < hurdleBoard.length; i++) {
      if (hurdleBoard[i].letter.isNotEmpty &&
          targetWord.contains(hurdleBoard[i].letter)) {
        hurdleBoard[i].existsInTarget = true;
      } else if (hurdleBoard[i].letter.isNotEmpty &&
          !targetWord.contains(hurdleBoard[i].letter)) {
        hurdleBoard[i].deosnotExistInTarget = true;
        excludedLetters.add(hurdleBoard[i].letter);
      }
    }
    notifyListeners();
  }

  void _goToNextRow() {
    attempts++;
    count = 0;
    rowInputs.clear();
  }

  void reset() {
    rowInputs.clear();
    excludedLetters.clear();
    hurdleBoard.clear();
    targetWord = "";
    count = 0;
    index = 0;
    attempts = 0;
    wins = false;
    generateBoard();
    generateRandomWord();
    notifyListeners();
  }
}

//random.nextInt(100)-->It means:Give me a random number between 0 and 99
//var r = Random(); print(r.nextInt(100));-->
//It means:Give me a random number between 0 and 99, but this is not secure.
// It can be predicted. So we use Random.secure() instead.
