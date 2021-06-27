import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Home/home.dart';
import 'package:flutter_auth/Screens/Login/login_screen.dart';
import 'package:flutter_auth/Screens/Signup/components/or_divider.dart';
import 'package:flutter_auth/Screens/Signup/components/social_icon.dart';
import 'package:flutter_auth/Screens/home/home.dart';
import 'package:flutter_auth/components/already_have_an_account_acheck.dart';
import 'package:flutter_auth/components/rounded_button.dart';
import 'package:flutter_auth/components/rounded_input_field.dart';
import 'package:flutter_auth/components/rounded_password_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'background.dart';


class Body extends StatelessWidget{
  String Fname;
  String Lname;
  String email;
  String password;
  String phone;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final firestoreInstance = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    //   final DatabaseReference reference = FirebaseDatabase.instance.reference().child('pets');
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(child: SizedBox(height: size.height * 0.02)),
            Text(
              'Edit Profile',
              style: TextStyle(fontFamily:'AkayaTelivigala',fontSize:25,fontWeight: FontWeight.bold),
            ),
            Center(child: SizedBox(height: size.height * 0.02)),
            Text(
              'Edit Your Information',
              style: TextStyle(color: Colors.red,fontFamily:'AkayaTelivigala',fontSize:20,),
            ),
            Center(child: SizedBox(height: size.height * 0.04)),

            RoundedInputField(

              hintText: "FName",
              onChanged: (value) {
                Fname = value;
              },
            ),
            RoundedInputField(

              hintText: "LName",
              onChanged: (value) {
                Lname = value;
              },
            ),
            RoundedInputField(
              icon: Icons.email,
              hintText: "Email",
              onChanged: (value) {
                email = value;
              },
            ),RoundedInputField(
              icon: Icons.phone,
              hintText: "Phone",
              onChanged: (value) {
                phone = value;
              },
            ),

            RoundedPasswordField(
              onChanged: (value) {
                password = value;
              },
            ),
            RoundedButton(

              text: "Done",
              press: () async {


                final uid = await getData();
                Firestore.instance.document("Users/$uid").updateData
                  ({

                  "Fname":Fname,
                  "lname" :Lname,
                  "email"  :email,
                  "phone#"  :phone,
                  "password":password,


                }).then((_){
                  Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context)
                  =>

                      LoginScreen()),
                  );
                });


              },
            ),
            RoundedButton(

              text: "Cancel",
              press: () {
//                Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context)
 //               => MyHomePage()),

  //              );


              },
            ),
          ],
        ),
      ),
    );

  }



}

Future<String> getData() async {
  final FirebaseUser user = await FirebaseAuth.instance.currentUser();
  final String uid = user.uid.toString();
  return uid;
}
