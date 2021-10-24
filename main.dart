import 'package:flutter/material.dart';
import 'createQuiz.dart';
import 'server.dart';
// import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  final GlobalKey<FormFieldState<String>> _usernameFormFieldKey = GlobalKey();
  final GlobalKey<FormFieldState<String>> _passwordFormFieldKey = GlobalKey();
  bool result = false;
  late AnimationController controller;
  bool show = false;
  bool showError =  false;

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

  // _saveCredentials() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String usr = _usernameFormFieldKey as String;
  //   String pwd = _passwordFormFieldKey as String;
  //   await prefs.setString('user', usr);
  //   await prefs.setString('password', pwd);
  // }

  _notEmpty(String value) => value.isNotEmpty;
  get values => ({
        'username': _usernameFormFieldKey.currentState?.value,
        'password': _passwordFormFieldKey.currentState?.value
      });

  Future<bool> _login() async {
    Server conn = Server();
    result =
        await conn.connectToLoginServer(values['username'], values['password']);
    print("Username: ${values['username']}");
    print("Password: ${values['password']}");
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
        title: Text("CS Quiz"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(24),
          child: Form(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildLogo(),
                  TextFormField(
                      key: _usernameFormFieldKey,
                      decoration: const InputDecoration(labelText: 'Username'),
                      validator: (value) =>
                          _notEmpty(value!) ? null : 'Username is required'),
                  TextFormField(
                      key: _passwordFormFieldKey,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Password'),
                      validator: (value) =>
                          _notEmpty(value!) ? null : 'Password is required'),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Builder(builder: (context) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          ElevatedButton(
                            child: const Text('Log In'),
                            onPressed: () async {
                              show = true;
                              showError = false;
                              Future.delayed(const Duration(seconds: 2), () => "placeholder");
                              if (Form.of(context)!.validate()) {}
                              result = await _login();
                              if (result == true) {
                                showError = false;
                                Future.delayed(const Duration(seconds: 1), () => Navigator.push(context, MaterialPageRoute(builder: (_) => createQuiz())));
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
                  if(showError) Text("\nError Invalid Login",style: TextStyle(
                    color: Colors.red)),
              ]),
          ),
        ),
      ),
    );
  }
}
