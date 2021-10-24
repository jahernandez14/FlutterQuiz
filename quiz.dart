import 'question.dart';
import 'server.dart';
import 'dart:math';

///Quiz class used to contain a pool of questions used for the quiz
class Quiz {
  var _qPool = [];
  var _numQuestions;
  var _grade = [];

  ///method to create a quiz by using the server class to get all server questions
  buildQuiz(num) async {
    try {
      _numQuestions = int.parse(num);
    } catch (u) {
      _numQuestions = 5;
    }

    Server server = new Server();
    var arr = await server.connectToQuizServer();
    _qPool.add(new Question(arr[5]["type"], arr[5]["answer"],
        arr[5]["stem"], arr[5]["option"], arr[5]["figure"]));
    _grade.add(-1);
    var poolLen = arr.length;
    for (var i = 1; i < this._numQuestions; i++) {
      _grade.add(-1);
      var rng = new Random().nextInt(poolLen);
      if (arr[rng]["type"] == 1) {
        _qPool.add(new Question(arr[rng]["type"], arr[rng]["answer"],
            arr[rng]["stem"], arr[rng]["option"], arr[rng]["figure"]));
      } else {
        _qPool.add(new FillInQuestion(
            arr[rng]["type"], arr[rng]["answer"], arr[rng]["stem"], [], arr[rng]["figure"]));
      }
    }
  }

  ///method to get the grade of a certain question
  int getGrade(i) {
    return _grade[i];
  }

  int completed(){
    int count = 0;
    for(int i =0; i< _grade.length; i++){
      if(_grade[i] > -1){
        count++;
      }
    }
    return count;
  }

  ///method to get the overall grade after the completion of the quiz
  String overallGrade() {
    var total = 0;
    for (var i = 0; i < this._numQuestions; i++) {
      if (_grade[i] == 1) {
        total += 1;
      }
    }
    return "$total/$_numQuestions";
  }

  ///method to update the grade every time the answer is answered.
  void updateGrade(index, score) {
    this._grade[index] = score;
  }

  ///getters to get quiz information such as question pool and number of questions the quuiz will contain.
  List get pool {
    return this._qPool;
  }

  List get grades {
    return this._grade;
  }

  int get numQuestions {
    return this._numQuestions;
  }
}
