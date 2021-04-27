/*import 'package:feal_app/main.dart';
import 'package:feal_app/pages/register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  static const routeName ='/login';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final GlobalKey<FormState> _formKey = GlobalKey();

  void _submit()
  {

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(bottom: 30),
        child: Column(
          children:<Widget> [
            Container(
              height: MediaQuery.of(context).size.height*0.3,
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
                    onTap: (){
                      Navigator.push(context,MaterialPageRoute(builder: (context)=>HomePage()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('images/Logo2.png',width: 200,height: 100,),
                      ],
                    ),
                  )
              ),

            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 20,right: 20,top: 30),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children:<Widget>[
                        //-----Email-----
                        TextFormField(
                          decoration: InputDecoration(labelText:'Email',),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value){
                            if(value.isEmpty || !value.contains('@')){
                              return 'invalid email';
                            }
                            return null;
                          },
                          onSaved: (value)
                          {

                          },
                        ),
                        //----Password-----
                        TextFormField(
                          decoration: InputDecoration(labelText:'Password'),
                          obscureText: true,
                          validator: (value)
                          {
                            if(value.isEmpty || value.length<=5)
                            {
                              return 'invalid password';
                            }
                            return null;
                          },
                          onSaved: (value)
                          {

                          },
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        RaisedButton(
                            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 100),
                            child: Text("LOGIN",style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),),
                          onPressed: ()
                          {
                            _submit();
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          color: Colors.blueGrey,
                          textColor: Colors.white,
                        )
                      ],
                    ),
                  ),
                /*child: Column(
                  children: [
                    _textInput(hint: "Email",icon: Icons.email),
                    _textInput(hint: "Password",icon: Icons.vpn_key),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      alignment: Alignment.centerRight,
                        child: Text("Forgot Passwword?", textAlign: TextAlign.end, )
                    ),
                    Expanded(
                      child: Center(
                        child: InkWell(
                          onTap: (){
                            Navigator.push(context,MaterialPageRoute(builder: (context)=>Register()));
                          },
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: <Color>[Colors.grey, Colors.blueGrey],
                                  end: Alignment.centerLeft,
                                  begin:Alignment.centerRight,
                                ),
                                borderRadius:
                                BorderRadius.all(Radius.circular(100))
                            ),
                            alignment: Alignment.center,
                            child: Text("LOGIN",style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),),

                          ),
                        ),
                      ),
                    )

                  ],
                ),*/
                ),
              ),
            ),
            RichText(
                text: TextSpan(
                children:[
                  TextSpan(text: "Don't have an account?",style: TextStyle(color: Colors.black)),
                  TextSpan(text: "Register",style: TextStyle(color: Colors.blueGrey ),
                      recognizer: TapGestureRecognizer()..onTap=(){
                        Navigator.push(context,MaterialPageRoute(builder: (context)=>Register()
                        )
                        );
                      }),
                ]))
          ],
        ),
      ),
    );
  }
   Widget  _textInput({controller,hint,icon})
   {
     return Container(
       margin: EdgeInsets.only(top: 10),
       decoration: BoxDecoration(
         borderRadius:BorderRadius.all(Radius.circular(20)),
         color:Colors.white,
       ),
       padding: EdgeInsets.only(left:10 ),
       child: TextFormField(
         controller: controller,
         decoration: InputDecoration(
           border:InputBorder.none ,
           hintText: hint,
           prefixIcon: Icon(icon),

         ),
       ),
     );
   }

*/