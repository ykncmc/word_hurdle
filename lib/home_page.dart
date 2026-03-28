import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:word_hurdle/helper_functions.dart';
import 'package:word_hurdle/hurdle_provider.dart';
import 'package:word_hurdle/keyboard_view.dart';
//import 'package:word_hurdle/wordle.dart';
import 'package:word_hurdle/worlde_view.dart';

class WordHurdlePage extends StatefulWidget {
  const WordHurdlePage({super.key});

  @override
  State<WordHurdlePage> createState() => _WordHurdlePageState();
}

class _WordHurdlePageState extends State<WordHurdlePage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<HurdleProvider>(context, listen: false).initi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Word Hurdle')),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Consumer<HurdleProvider>(
                  builder: (context, provider, child) => GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                    ),
                    itemCount: provider.hurdleBoard.length,
                    itemBuilder: (context, index) {
                      final wordle = provider.hurdleBoard[index];
                      return WordleView(wordle: wordle);
                    },
                  ),
                ),
              ),
            ),
            Consumer<HurdleProvider>(
              builder: (context, provider, child) => KeyboardView(
                excludedLetters: provider.excludedLetters,

                onPressed: (value) {
                  provider.inputLetter(value);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Consumer<HurdleProvider>(
                builder: (context, provider, child) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        provider.deleteLetter();
                      },
                      child: const Text('DELETE'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (!provider.isAvalidWord) {
                          showMsg(context, 'Not a word in my dictionary');
                          return;
                        }
                        if (provider.shouldCheckForAnswer) {
                          provider.checkAnswer();
                        }
                        if (provider.wins) {
                          showResult(
                            context: context,
                            title: 'Congratulations, you won!',
                            body:
                                'You guessed the word ${provider.targetWord} correctly.',
                            onPlayAgain: () {
                              Navigator.pop(context);
                              provider.reset();
                            },
                            onCancel: () {
                              Navigator.pop(context);
                            },
                          );
                        } else if (provider.noAttemptsLeft) {
                          showResult(
                            context: context,
                            title: 'Game Over',
                            body: 'The word was ${provider.targetWord}.',
                            onPlayAgain: () {
                              Navigator.pop(context);
                              provider.reset();
                            },
                            onCancel: () {
                              Navigator.pop(context);
                            },
                          );
                        }
                      },
                      child: const Text('SUBMIT'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
