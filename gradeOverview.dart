import 'package:flutter/material.dart';
import 'package:quiz_v2/review.dart';
import 'createQuiz.dart';
import 'quiz.dart';

class gradeOverview extends StatefulWidget {
  final Quiz? quiz;
  const gradeOverview({Key? key, this.quiz}): super (key:key);

  @override
  _gradeOverview createState() => _gradeOverview(this.quiz);
}

class _gradeOverview extends State<gradeOverview>{
  Quiz? quiz;
  _gradeOverview(this.quiz);

  Widget _buildLogo() {
    return Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: Center(
            child: Container(
                width: 200,
                height: 150,
                child: Image.asset('assets/icon/quiz.png'))));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("CS Quiz Grade Summary"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(24),
          child: Form(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildLogo(),
                  Padding(
                      padding: const EdgeInsets.only(
                          left: 25.0, right: 30.0, top: 10, bottom: 10)),
                  Text("Grade Overview", style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
                  Text("\n${quiz!.overallGrade()}", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
              Padding(
              padding: const EdgeInsets.symmetric(vertical: 100.0),
          child: Builder(builder: (context) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  child: const Text('Try Again'),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => createQuiz()));
                  },
                ),
                Padding(
                    padding: const EdgeInsets.only(
                        left: 50.0, right: 50.0, top: 0, bottom: 0)),
                ElevatedButton(
                  child: const Text('Review'),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => review(quiz: quiz, questionNum: 0)));
                  },
                )
              ],
            );
          }),
        )
                ]),
          ),
        ),
      ),
    );
  }
}