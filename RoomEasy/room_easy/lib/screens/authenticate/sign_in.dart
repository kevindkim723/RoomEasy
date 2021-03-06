import 'package:flutter/material.dart';

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:room_easy/services/auth.dart';
import 'package:room_easy/shared/loading.dart';
import 'package:room_easy/shared/constants.dart';
import 'package:room_easy/screens/survey/survey.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  SignIn({this.toggleView});

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

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : WillPopScope(
            onWillPop: () {
              widget.toggleView(0);
            },
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Color(0xffffefaf),
              // appBar: AppBar(
              //   title: Text("Sign In"),
              // ),
              body: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 60.0),
                      child: Center(
                        child: Container(
                            width: 200,
                            height: 200,
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
                        validator: (val) {
                          return val.isEmpty ? "Enter email" : null;
                        },
                        onChanged: (val) {
                          email = val;
                        },
                        decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                              // width: 0.0 produces a thin "hairline" border
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 1.0),
                            ),
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
                            enabledBorder: const OutlineInputBorder(
                              // width: 0.0 produces a thin "hairline" border
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 1.0),
                            ),
                            border: OutlineInputBorder(
                                borderSide:
                                    new BorderSide(color: Color(0xff201cbb))),
                            labelText: 'Password',
                            hintText: 'Enter secure password'),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextButton(
                      onPressed: () {
                        //TODO FORGOT PASSWORD SCREEN GOES HERE
                      },
                      child: Text(
                        'Forgot Password',
                        style:
                            TextStyle(color: Color(0xff201cbb), fontSize: 15),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 250,
                      decoration: BoxDecoration(
                          color: Color(0xff201cbb),
                          borderRadius: BorderRadius.circular(20)),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color(0xff201cbb)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(
                                color: Color(0xff201cbb),
                                width: 2.0,
                              ),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          dynamic result = await _authService
                              .signInWithEmailAndPassword(email, password);
                          if (_authService.auth.currentUser != null) {
                            await _authService.auth.currentUser.reload();
                            if (_authService.auth.currentUser == null ||
                                !_authService.auth.currentUser.emailVerified) {
                              showAlertDialog(context, "email not verified");
                            }
                          } else {
                            print(result);
                            if (result == "user-not-found" ||
                                result == 'invalid-email') {
                              showAlertDialog(
                                  context, "no account found with that email");
                            } else if (result == "wrong-password") {
                              print("breh");
                              showAlertDialog(context, "wrong password");
                            } else {
                              //valid email

                            }
                          }
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: InkWell(
                            onTap: () {
                              widget.toggleView(2);
                            },
                            child: Container(
                              width: double.infinity,
                              height: 50,
                              child:
                                  Center(child: Text('Tap here to register')),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
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
