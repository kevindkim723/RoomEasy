import 'package:flutter/material.dart';

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:room_easy/services/auth.dart';
import 'package:room_easy/shared/loading.dart';
import 'package:room_easy/shared/constants.dart';
import 'package:room_easy/screens/home/survey.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String error = "";
  String note = "";
  bool loading = false;

  Timer timer;
  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body:  Form(
        key: _formKey,
        child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: Center(
                  child: Container(
                      width: 200,
                      height: 150,
                      /*decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(50.0)),*/
                      child: Image.asset('assets/roomEasy.png')),
                ),
              ),
              Padding(
                //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  validator: (val){
                    return val.isEmpty ? "Enter email" : null;
                  },
                  onChanged: (val) {
                    email = val;
                  },

                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      hintText: 'Enter valid email id as abc@gmail.com'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                //padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  onChanged: (val) {
                    password = val;
                  },


                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Enter secure password'),
                ),
              ),
              TextButton(
                onPressed: (){
                  //TODO FORGOT PASSWORD SCREEN GOES HERE
                },
                child: Text(
                  'Forgot Password',
                  style: TextStyle(color: Colors.blue, fontSize: 15),
                ),
              ),
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(
                          color: Colors.blue,
                          width: 2.0,
                        ),
                      ),
                  ),
                  ),
                  onPressed: () async {
                      await _authService.auth.currentUser.reload();
                      dynamic result = await _authService.signInWithEmailAndPassword(email, password);
                      if (_authService.auth.currentUser == null || !_authService.auth.currentUser.emailVerified)
                        {
                          showAlertDialog(context, "email not verified");
                        }
                      else {
                        if (result == "user-not-found" ||
                            result == 'invalid-email') {
                          showAlertDialog(
                              context, "no account found with that email");
                        }
                        else if (result == "wrong-password") {
                          print("breh");
                          showAlertDialog(context, "wrong password");
                        }
                        else { //valid email
                          setState(() {
                            print("valid email");
                            Navigator.of(context).popUntil((route) =>
                            route.isFirst);
                            Navigator.pushReplacementNamed(context, '/survey');
                          });
                        }
                      }
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
                 SizedBox(
                  height: 130,
                ),
              GestureDetector(
                onTap: (){
                  print("tapped text");
                },
                  child: Text('New User? Create Account'))
            ],
          ),
      ),
    );
  }

  Future<void> sendVerificationEmail() async {
    await _authService.auth.currentUser
        .sendEmailVerification(); //sends verification email
    setState(() {
      note = "verification email sent to ${_authService.user}";
    });
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      checkEmailVerified();
    });
  }

  Future<void> checkEmailVerified() async {
    User user = _authService.auth.currentUser;
    await user.reload();
    if (user.emailVerified) {
      timer.cancel();
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => Survey()));
    }
  }
}
showAlertDialog(BuildContext context, String message) {

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("My title"),
    content: Text(message),
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}