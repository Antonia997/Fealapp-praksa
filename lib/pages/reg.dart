import 'package:feal_app/services/auth.dart';
import 'package:feal_app/shared/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:feal_app/shared/constants.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email='';
  String password ='';
  String error= '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.grey[100],
      /*appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        elevation: 0.0,
        title: Text('Sign up to Galileo shop') ,
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Sign In'),
            onPressed: (){
                widget.toggleView();
            },
          )
        ],
      ),*/
      body: Container(
        child: Column(
          children:<Widget> [
            Container(
              padding: EdgeInsets.only(bottom:0),
              height: MediaQuery.of(context).size.height*0.25,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[Colors.grey, Colors.blueGrey],
                    end: Alignment.centerRight,
                    begin:Alignment.centerLeft,
                  ),
                  borderRadius:
                  BorderRadius.only(bottomLeft: Radius.circular(90))
              ),
              child: Center(
                  child:InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('images/Logo2.png',width: 200,height: 100,),
                      ],
                    ),
                  )
              ),

            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20,horizontal: 50),
              child: Form(
                key: _formKey,
                child: Column(
                  children:<Widget> [
                    SizedBox(height: 20.0,),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(hintText: 'Email',prefixIcon: Icon(Icons.email)),
                      validator: (val) => val.isEmpty ? 'Enter an email' : null,
                      onChanged: (val){
                        setState(()=>email = val);
                      },
                    ),
                    SizedBox(height: 20.0,),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(hintText: 'Password',prefixIcon: Icon(Icons.vpn_key)),
                      obscureText: true,
                      validator: (val) => val.length<6 ? 'Enter a password 6+ chars long' : null,
                      onChanged: (val){
                        setState(()=>password = val);
                      },
                    ),
                    SizedBox(height: 20.0,),
                    RaisedButton(
                      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 60),
                      color: Colors.blueGrey,
                      child: Text(
                        'Register',style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),
                      ),
                      onPressed: ()async{
                       if(_formKey.currentState.validate()){
                         setState(() => loading = true);
                         dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                         if(result == null){
                           setState((){
                             error = 'Please supply a valid email';
                             loading =false;
                           });
                         }
                       }
                      },
                    ),
                    SizedBox(height: 12.0,),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    ),
                    RichText(
                        text: TextSpan(
                            children:[
                              TextSpan(text: "Already a member?",style: TextStyle(color: Colors.black,fontSize: 17)),
                              TextSpan(text: "  Login",style: TextStyle(color: Colors.blueGrey,fontSize: 17 ),
                                  recognizer: TapGestureRecognizer()..onTap=(){
                                    widget.toggleView();
                                  }),
                            ]))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
