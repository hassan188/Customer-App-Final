import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter_auth/Screens/Home/home_screen.dart';
import 'package:flutter_auth/Screens/Location/location.dart';
import 'package:flutter_auth/components/rounded_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' show cos, sqrt, asin;

class HelpPage extends StatefulWidget {
  Position sourcelocation;
  HelpPage({Key key, @required this.sourcelocation,}) ;
  @override
  _HelpPageState createState() => _HelpPageState();
}


class _HelpPageState extends State<HelpPage> {
  var _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(
            'Help'
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0,),
          child: Center(
            child: Column(


              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,

              children: <Widget>[
                SizedBox(height:20.0),
                Center(
                  child: ListTile(
                    title: Center(child: Center(
                      child: Text('Ask for help!',
                        style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.red
                        ),
                      ),
                    ),
                    ),
                  ),
                ),

                Center(
                  child: ExpansionTile(
                    title: Text(
                      "How to edit profile?",
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w400
                      ),
                    ),

                    children: <Widget>[
                      ListTile(
                        title: Text('Goto HomeScreen->Click on icon button->Edit what you want-> Click on Done',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),),
                      )
                    ],
                  ),
                ),


                ExpansionTile(
                  title: Text(
                    "How to Book Luggage?",
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400
                    ),
                  ),

                  children: <Widget>[
                    ListTile(
                      title: Text('Click on book luggage->Enter pickup and dropoff location-> Select booking type-> Enter luggage details-> CLick on request',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),),
                    )
                  ],
                ),
                ExpansionTile(
                  title: Text(
                    "How to Signout from the account?",
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400
                    ),
                  ),

                  children: <Widget>[
                    ListTile(
                      title: Text('Goto HomeScreen->Click on menu button->Click on Signout button',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                    )
                  ],
                ),

              ],

            ),

          ),
        ),
      ),


    );
  }
}
