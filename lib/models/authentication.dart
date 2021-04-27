import 'dart:convert';


import 'package:feal_app/pages/sign_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:feal_app/pages/reg.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  void toggleView(){
    setState(()=> showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if(showSignIn){
      return SignIn(toggleView:toggleView);
    }
    else{
      return Register(toggleView:toggleView);
    }
  }

}





/*class Authentication with ChangeNotifier {
  Future<void> singUp(String email, String password) async {
    const url = 'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=[AIzaSyAQYvZDXmSFuzEDObViUM-0MXQMddXOrsg]';

    final response = await http.post(Uri.parse(url), body: json.encode(
        {
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }
    ));
    final responseData = json.decode(response.body);
    print(responseData);
  }
}*/