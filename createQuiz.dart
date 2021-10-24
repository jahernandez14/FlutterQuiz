import 'dart:core';
import 'package:flutter/material.dart';
import 'quiz.dart';
import 'quizView.dart';

class createQuiz extends StatefulWidget {
  @override
  _createQuiz createState() => _createQuiz();
}

class _createQuiz extends State<createQuiz> with TickerProviderStateMixin{
  final GlobalKey<FormFieldState<String>> _userSelectionKey = GlobalKey();
  bool result = false;
  late AnimationController controller;
  bool show = false;
  bool showError =  false;
  List quizPool = [];
  Quiz? quiz;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
      setState(() {});
    });
    controller.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  _notEmpty(String value) => value.isNotEmpty;
  get values => ({
    'quiz_length': _userSelectionKey.currentState?.value,
  });

  Future<bool> _buildQuiz() async {
    quiz = Quiz();
    await quiz!.buildQuiz(values['quiz_length']);
    quizPool = quiz!.pool;
    if(quizPool.length < 1 || values['quiz_length'] == ""){
      result = false;
      show = false;
    }
    else{
      result = true;
      show = false;
    }
    print(quizPool);
    print("Login Result: $result");
    return result;
  }

  Widget _buildLogo() {
    return Padding(
        padding: const EdgeInsets.only(top: 60.0),
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
        title: Text("CS Quiz Builder"),
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
                        left: 15.0, right: 15.0, top: 15, bottom: 0),
                  ),
                  TextFormField(
                      key: _userSelectionKey,
                      decoration: const InputDecoration(labelText: 'Enter The Number Of Questions:'),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                      _notEmpty(value!) ? null : 'A valid number must be entered'),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Builder(builder: (context) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          ElevatedButton(
                            child: const Text('Submit'),
                            onPressed: () async {
                              show = true;
                              showError = false;
                              Future.delayed(const Duration(seconds: 2), () => "placeholder");
                              if (Form.of(context)!.validate()) {}
                              result = await _buildQuiz();
                              if (result == true) {
                                showError = false;
                                print(quiz);
                                Future.delayed(const Duration(seconds: 1), () => Navigator.push(context, MaterialPageRoute(builder: (context) => quizView(quiz:quiz, questionNum: 0))));
                                Future.delayed(const Duration(seconds: 1), () => show = false);
                              }
                              else{
                                Future.delayed(const Duration(seconds: 1), () => show = false);
                                showError = true;
                              }
                            },
                          ),
                          TextButton(
                            child: const Text('Reset'),
                            onPressed: () => Form.of(context)!.reset(),
                          )
                        ],
                      );
                    }),
                  ),
                  if(show) CircularProgressIndicator(
                      value: controller.value,
                      semanticsLabel: 'Linear progress indicator'),
                  if(showError) Text("\nInvalid Quiz Number",style: TextStyle(
                      color: Colors.red)),
                ]),
          ),
        ),
      ),
    );
  }
}