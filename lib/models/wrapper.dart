import 'package:feal_app/main.dart';
import 'package:feal_app/models/authentication.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:feal_app/models/user.dart';



class Wrapper extends StatelessWidget {
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    print(user);
    if(user == null){
      return Authenticate();

    }
    else{
      return HomePage();
    }
  }
}
