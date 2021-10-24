import 'package:flutter/material.dart';
import 'gradeOverview.dart';
import 'quiz.dart';

class quizView extends StatefulWidget {
  final Quiz? quiz;
  final int questionNum;
  const quizView({Key? key, this.quiz, required this.questionNum}): super (key:key);

  @override
  _quizView createState() => _quizView(this.quiz, this.questionNum);
}

class _quizView extends State<quizView>{
  final GlobalKey<FormFieldState<String>> _userSelectionKey = GlobalKey();
  Quiz? quiz;
  int questionNum;
  _quizView(this.quiz, this.questionNum);

  _notEmpty(String value) => value.isNotEmpty;
  get values => ({
    'uAns': _userSelectionKey.currentState?.value,
  });

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

  void _updateGrade(){
    var ans = quiz!.pool[questionNum].ansChecker();
    if (ans == 1) {
      quiz!.updateGrade(questionNum, 1);
    } else if (ans == 0) {
      quiz!.updateGrade(questionNum, 0);
    }
  }

  var _selection = -1;

  List<Widget> _buildChoices(){
    int i = 0;
    int ans = 0;
    List<Widget> list = [];
    while(i< quiz!.pool[questionNum].choices.length){
      list.add(RadioListTile(value: i, groupValue: _selection, onChanged: (value) {
        setState(() {
          _selection = int.parse(value.toString());
          ans = _selection + 1;
          print(ans);
          quiz!.pool[questionNum].userAns = ans.toString();
        });
      }, title: Text(quiz!.pool[questionNum].choices[i], style: TextStyle(fontSize: 14)), activeColor: Colors.blue, selectedTileColor: Colors.blue));
      i++;
    }
    return list;
  }

  Widget _previousButton(){
    if(questionNum>0){
      return ElevatedButton(
        child: const Text('Previous'),
        onPressed: () {
          if(quiz!.pool[questionNum].type == 2) {
            quiz!.pool[questionNum].userAns = values['uAns'];
          }
          _updateGrade();
          Navigator.push(context, MaterialPageRoute(builder: (context) => quizView(quiz:quiz, questionNum: questionNum-1)));
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
          if(quiz!.pool[questionNum].type == 2) {
            quiz!.pool[questionNum].userAns = values['uAns'];
          }
          _updateGrade();
          Navigator.push(context, MaterialPageRoute(builder: (context) => quizView(quiz:quiz, questionNum: questionNum+1)));
        },
      );
    }
    return ElevatedButton(
      child: const Text('Finish'),
      onPressed: () {
        if(quiz!.pool[questionNum].type == 2) {
          quiz!.pool[questionNum].userAns = values['uAns'];
        }
        _updateGrade();
        Navigator.push(context, MaterialPageRoute(builder: (context) => gradeOverview(quiz:quiz)));
      },
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
                    Column(children: _buildChoices())
                  else
                    TextFormField(
                        key: _userSelectionKey,
                        decoration: const InputDecoration(labelText: 'Enter your answer below:'),
                        validator: (value) =>
                        _notEmpty(value!) ? null : 'A valid number must be entered'),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Builder(builder: (context) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _previousButton(),
                          Text("    Completed: ${quiz!.completed()}    ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                          Text("Remaining: ${quiz!.numQuestions - quiz!.completed()}   ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
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