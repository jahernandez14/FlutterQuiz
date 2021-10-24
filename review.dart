import 'package:flutter/material.dart';
import 'gradeOverview.dart';
import 'quiz.dart';

class review extends StatefulWidget {
  final Quiz? quiz;
  final int questionNum;
  const review({Key? key, this.quiz, required this.questionNum}): super (key:key);

  @override
  _review createState() => _review(this.quiz, this.questionNum);
}

class _review extends State<review>{
  Quiz? quiz;
  int questionNum;
  _review(this.quiz, this.questionNum);

  Widget _buildQuestion(){
    return Text(quiz!.pool[questionNum].ques);
  }
  Widget _buildQuestionNum(){
    return Text("Question ${questionNum+1}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold));
  }

  Widget _buildPadding(){
    return Padding(
        padding: const EdgeInsets.only(
            left: 15.0, right: 15.0, top: 10, bottom: 0));
  }

  Widget _buildFigure(String name){
    Widget img;
    if(name == ""){
      img = _buildPadding();
    }
    else{
      img = Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10, bottom: 0),
          child: Image.network('http://cheon.atwebpages.com/quiz/figure.php?name=${name}'));
    }
    return img;
  }

  List<Widget> _buildChoices(){
    int i = 0;
    int user = int.parse(quiz!.pool[questionNum].userAns);
    int actual = int.parse(quiz!.pool[questionNum].aAns);

    List<Widget> list = [];
    print("Actual: ${quiz!.pool[questionNum].aAns}");
    while(i< quiz!.pool[questionNum].choices.length){
      if(actual == user && user == i+1) {
        list.add(Text("${quiz!.pool[questionNum].choices[i]}\n",
            style: TextStyle(fontSize: 14, color: Colors.green)));
      }
      else if(actual == i+1) {
        list.add(Text("${quiz!.pool[questionNum].choices[i]}\n",
            style: TextStyle(fontSize: 14, color: Colors.green)));
      }
      else if(user == i+1) {
        list.add(Text("${quiz!.pool[questionNum].choices[i]}\n",
            style: TextStyle(fontSize: 14, color: Colors.red)));
      }
      else{
        list.add(Text("${quiz!.pool[questionNum].choices[i]}\n",
            style: TextStyle(fontSize: 14)));
      }
      i++;
    }
    return list;
  }

  Widget _previousButton(){
    if(questionNum>0){
      return ElevatedButton(
        child: const Text('Previous'),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => review(quiz:quiz, questionNum: questionNum-1)));
        },
      );
    }
    return Padding(
        padding: const EdgeInsets.only(
            left: 25.0, right: 30.0, top: 0, bottom: 0));
  }

  Widget _nextButton(){
    if(questionNum < quiz!.numQuestions-1){
      return ElevatedButton(
        child: const Text('Next'),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => review(quiz:quiz, questionNum: questionNum+1)));
        },
      );
    }
    return ElevatedButton(
      child: const Text('Finish'),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => gradeOverview(quiz:quiz)));
      },
    );
  }

  Widget _gradedFillInTheBlankWidget(){
    if(quiz!.getGrade(questionNum) > 0){
      return Column(
          children: [
            Text("You Answer:  ${quiz!.pool[questionNum].userAns}\n", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
            Text("Correct Answer:  ${quiz!.pool[questionNum].aAns}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
          ]
      );
    }
    return Column(
        children: [
          Text("You Answer:  ${quiz!.pool[questionNum].userAns}\n", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red)),
          Text("Correct Answer:  ${quiz!.pool[questionNum].aAns}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
        ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("CS Quiz"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(24),
          child: Form(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildQuestionNum(),
                  _buildPadding(),
                  _buildQuestion(),
                  _buildFigure(quiz!.pool[questionNum].figure),
                  _buildPadding(),
                  if(quiz!.pool[questionNum].type == 1)
                    Column(children: _buildChoices()
                    )
                  else
                    _gradedFillInTheBlankWidget(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Builder(builder: (context) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _previousButton(),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 80.0, right: 80.0, top: 0, bottom: 0)),
                          _nextButton(),
                        ],
                      );
                    }),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}