import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Home/home_screen.dart';
import 'package:flutter_auth/Screens/Login/components/body.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';



class ForgotPassword extends StatefulWidget {
  static String id = 'forgot-password';

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _auth = FirebaseAuth.instance;
  String email="s@gmail.com";
  final emailcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[100],
      body: Form(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Forget Passworda',
                style: TextStyle(fontSize: 30, color: Colors.black),
              ),
              TextFormField(
                  controller:emailcontroller,
                  style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Email',
                  icon: Icon(
                    Icons.mail,
                    color: Colors.black54,
                  ),
                  errorStyle: TextStyle(color: Colors.black54),
                  labelStyle: TextStyle(color: Colors.black54),
                  hintStyle: TextStyle(color: Colors.black54),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 20),
              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                color: Colors.indigo[300],
                child: Text('Send Email'),
                onPressed: () async {
                  try {
                    await _auth.sendPasswordResetEmail(email: emailcontroller.text);

                  } catch(e){
                    print(e);
                  }
                    Navigator.push(context, new MaterialPageRoute(
                        builder: (BuildContext context) => new LoginPage()),
                    );
                  },

              ),

            ],
          ),
        ),
      ),
    );
  }
}
