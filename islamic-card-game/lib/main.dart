
import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(IslamicCardGame());

class IslamicCardGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kartu Islami',
      home: GameScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

enum QuestionType { pengetahuan, hijaiyah, tajwid }

class Question {
  final String question;
  final List<String> options;
  final int correctIndex;

  Question(this.question, this.options, this.correctIndex);
}

class HijaiyahQuestion {
  final String image;
  final List<String> options;
  final int correctIndex;

  HijaiyahQuestion(this.image, this.options, this.correctIndex);
}

class TajwidQuestion {
  final String ayat;
  final List<String> options;
  final int correctIndex;

  TajwidQuestion(this.ayat, this.options, this.correctIndex);
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<Question> questionBank = [
    Question("Rukun Islam ada berapa?", ["4", "5", "6"], 1),
    Question("Kitab suci umat Islam adalah?", ["Alkitab", "Injil", "Al-Qur’an"], 2),
    Question("Nabi terakhir yang diutus Allah adalah?", ["Musa", "Isa", "Muhammad"], 2),
    Question("Malaikat pencatat amal baik bernama?", ["Malik", "Jibril", "Raqib"], 2),
    Question("Shalat wajib dalam sehari ada?", ["3", "5", "7"], 1),
  ];

  List<HijaiyahQuestion> hijaiyahBank = [
    HijaiyahQuestion("assets/huruf_alif.png", ["Alif", "Ba", "Ta"], 0),
    HijaiyahQuestion("assets/huruf_ba.png", ["Ya", "Ba", "Kaf"], 1),
  ];

  List<TajwidQuestion> tajwidBank = [
    TajwidQuestion("... مَنۡ يَّعۡمَلۡ ...", ["Idgham", "Iqlab", "Izhar"], 0),
    TajwidQuestion("... مِنۡ بَعۡدِ ...", ["Ikhfa", "Iqlab", "Izhar"], 2),
  ];

  late Question currentQuestion;
  late HijaiyahQuestion currentHijaiyah;
  late TajwidQuestion currentTajwid;
  QuestionType currentType = QuestionType.pengetahuan;

  int score = 0;
  bool questionVisible = false;

  void pickCard() {
    final rand = Random().nextInt(3); // 0, 1, 2
    setState(() {
      if (rand == 0) {
        currentQuestion = questionBank[Random().nextInt(questionBank.length)];
        currentType = QuestionType.pengetahuan;
      } else if (rand == 1) {
        currentHijaiyah = hijaiyahBank[Random().nextInt(hijaiyahBank.length)];
        currentType = QuestionType.hijaiyah;
      } else {
        currentTajwid = tajwidBank[Random().nextInt(tajwidBank.length)];
        currentType = QuestionType.tajwid;
      }
      questionVisible = true;
    });
  }

  void answer(bool isCorrect, String correctText) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isCorrect ? 'Benar!' : 'Salah!'),
        content: Text(isCorrect
            ? 'Jawaban kamu benar!'
            : 'Jawaban yang benar: $correctText'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                if (isCorrect) score += 1;
                questionVisible = false;
              });
            },
            child: Text('Lanjut'),
          )
        ],
      ),
    );
  }

  Widget buildPengetahuanCard() {
    return Column(
      children: [
        Text(currentQuestion.question, style: TextStyle(fontSize: 18)),
        SizedBox(height: 20),
        ...List.generate(3, (index) {
          return ElevatedButton(
            onPressed: () => answer(index == currentQuestion.correctIndex,
                currentQuestion.options[currentQuestion.correctIndex]),
            child: Text(currentQuestion.options[index]),
          );
        })
      ],
    );
  }

  Widget buildHijaiyahCard() {
    return Column(
      children: [
        Image.asset(currentHijaiyah.image, width: 100, height: 100),
        SizedBox(height: 20),
        ...List.generate(3, (index) {
          return ElevatedButton(
            onPressed: () => answer(index == currentHijaiyah.correctIndex,
                currentHijaiyah.options[currentHijaiyah.correctIndex]),
            child: Text(currentHijaiyah.options[index]),
          );
        }),
      ],
    );
  }

  Widget buildTajwidCard() {
    return Column(
      children: [
        Text(currentTajwid.ayat, style: TextStyle(fontSize: 18)),
        SizedBox(height: 20),
        ...List.generate(3, (index) {
          return ElevatedButton(
            onPressed: () => answer(index == currentTajwid.correctIndex,
                currentTajwid.options[currentTajwid.correctIndex]),
            child: Text(currentTajwid.options[index]),
          );
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (!questionVisible) {
      content = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Pilih salah satu kartu!", style: TextStyle(fontSize: 18)),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(3, (_) {
              return GestureDetector(
                onTap: pickCard,
                child: Image.asset('assets/card_back.png', width: 90, height: 130),
              );
            }),
          ),
          SizedBox(height: 30),
          Text("Skor: $score", style: TextStyle(fontSize: 20)),
        ],
      );
    } else {
      switch (currentType) {
        case QuestionType.pengetahuan:
          content = buildPengetahuanCard();
          break;
        case QuestionType.hijaiyah:
          content = buildHijaiyahCard();
          break;
        case QuestionType.tajwid:
          content = buildTajwidCard();
          break;
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text('Game Kartu Islami'), backgroundColor: Colors.green),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: content),
      ),
    );
  }
}
