import 'package:http/http.dart' as http;
import 'dart:convert';

///Server class to establish a connection with the server, parse the json and return a future list of all of the questions.
class Server {
  var _quiz = [];
  var result = false;

  Future<List> connectToQuizServer() async {
    var url = Uri.http(
        'cheon.atwebpages.com', '/quiz', {"quiz": "quiz02"});
    var response = await http.get(url);
    final query = response.body;

    var decoded = json.decode(query);

    _quiz = decoded["quiz"]["question"];

    return _quiz;
  }

  Future <bool> connectToLoginServer(username, password) async {
    var url = Uri.http(
        'cheon.atwebpages.com', '/quiz/login.php', {"user": username, "pin": password});
    var response = await http.get(url);
    final query = response.body;
    var decoded = json.decode(query);
    result = decoded["response"];
    //var error = decoded["reason"];
    if (result != true){
      result = false;
    }
    return result;
  }
}