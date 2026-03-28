class Wordle {
  String letter;
  bool existsInTarget;
  bool deosnotExistInTarget;
  Wordle({
    required this.letter,
     this.existsInTarget = false,
     this.deosnotExistInTarget = false,
  });
}