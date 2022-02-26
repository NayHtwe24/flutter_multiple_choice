import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: QuizPage(),
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  var isFirstTime = false;
  var numberOfChoices = 3; // Multiple Choice Limit
  var multipleChoices = [];
  var correctAnswer = 1;
  var answerData = 0;
  var totalPoints = 0;
  var startNum = 1;

  void getData(startNum) {
    answerData = 0;
    multipleChoices = [];

    correctAnswer = startNum;
    multipleChoices.add(correctAnswer);
    //debugPrint('Multiple Choice List Log: $multipleChoices');

    var random = Random();
    var randomNumber = random.nextInt(9) + 1;
    //debugPrint('Random Number Log: $randomNumber');

    while (multipleChoices.length < numberOfChoices) {
      randomNumber = random.nextInt(9) + 1;
      if (!multipleChoices.contains(randomNumber)) {
        multipleChoices.add(randomNumber);
      }
      // debugPrint('Multiple Choice Final List Log: $multipleChoices');
    }
    multipleChoices = multipleChoices..shuffle();
    //debugPrint('Shuffle Multiple Choice List Log: $multipleChoices');
  }

  void startProcess() {
    if (!isFirstTime) {
      totalPoints = 0;
      startNum = 1;
      getData(startNum);
    }
    isFirstTime = true;
  }

  List<Widget> getImageListWidgets() {
    List<Widget> widgets = [];
    for (var num in multipleChoices) {
      widgets.add(Expanded(
        flex: 1,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              if (answerData == 0) {
                setState(() {
                  if (num == correctAnswer) {
                    totalPoints += 10;
                    answerData++;
                  }
                  answerData++;
                });
              }
            }, // Handle your callback.
            child: Ink(
              height: 80,
              width: 100,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                image: DecorationImage(
                  image: AssetImage('assets/number/$num.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ));
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    startProcess();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Assignment 1 By Nay Htwe"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Please Select $correctAnswer",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ...getImageListWidgets(),
              const SizedBox(height: 20),
              Text(
                answerData == 2
                    ? "Your answer is correct"
                    : answerData == 1
                    ? "Your answer is not correct"
                    : "",
                style: TextStyle(
                  color: answerData == 2 ? Colors.blue : Colors.red,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              startNum != 9 ? ElevatedButton(
                onPressed: (() {
                  getData(++startNum);
                  setState(() {

                  });
                }),
                style: ElevatedButton.styleFrom(
                  primary: Colors.teal,
                ),
                child: const Text(
                  "NEXT",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ) : ElevatedButton(
                onPressed: (() {
                  startNum = 1;
                  getData(startNum);
                  setState(() {
                    totalPoints = 0;
                  });
                }),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                ),
                child: const Text(
                  "Reset",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Text(
                "Score: $totalPoints",
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}