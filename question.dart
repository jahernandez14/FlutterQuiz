///Class that represents each question.
class Question {
  var uAns;
  var _aAns;
  var _ques;
  var _choices;
  var _type;
  var _figure;

  ///question constructor
  Question(type, aAns, ques, choices, figure) {
    this._type = type;
    this._aAns = aAns;
    this._ques = ques;
    this._choices = choices;
    this._figure = figure;
    uAns = "";
  }

  ///method to check it multiple answer question is correct or not.
  int ansChecker() {
    try {
      var ans = int.parse(uAns);
      if (ans > 0 && ans < _choices.length + 1) {
        if (uAns.toString() == _aAns.toString()) {
          return 1;
        } else {
          return 0;
        }
      }
    } catch (u) {
      return 3;
    }
    return 3;
  }

  ///setter and getters used to popullate and retrieve question information.
  set userAns(uAns) {
    this.uAns = uAns;
  }

  String get ques {
    return this._ques;
  }

  String get figure {
    if(_figure == null){
      return "";
    }
    return this._figure;
  }

  String get aAns {
    return this._aAns.toString();
  }

  String get userAns {
    return this.uAns.toString();
  }

  List get choices {
    return this._choices;
  }

  int get type {
    return this._type;
  }
}

///child class of question that now handles fill in the blanck question
class FillInQuestion extends Question {
  FillInQuestion(type, aAns, ques, choices, figure) : super(type, aAns, ques, choices, figure) {
    this._type = type;
    this._aAns = aAns;
    this._ques = ques;
    this._figure = figure;
    uAns = "";
  }

  ///method used to check the answer of only fill in the blank questions
  @override
  int ansChecker() {
    var len = _aAns.length;
    for (var j = 0; j < len; j++) {
      if (uAns.toLowerCase() == _aAns[j].toLowerCase()) {
        return 1;
      }
    }
    return 0;
  }

  ///getter overwritten to eliminate answer choices.
  @override
  List get choices {
    return [""];
  }
}
