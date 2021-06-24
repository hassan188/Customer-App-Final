import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Help/components/help.dart';
import 'package:flutter_auth/Screens/Wallet/yourwallets.dart';
import 'package:flutter_auth/Screens/Welcome/welcome_screen.dart';
import 'package:flutter_auth/Screens/Your%20Trip/trip.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../main.dart';
import 'package:flutter_auth/Screens/Location/location.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_auth/Screens/Profile/profile.dart';
import 'dart:collection';
import 'package:flutter_auth/Screens/Help/components/help.dart';
import 'package:flutter_auth/Screens/Wallet/yourwallets.dart';
import 'package:flutter_auth/Screens/Your%20Trip/trip.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../main.dart';
import 'package:flutter_auth/Screens/Location/location.dart';
import 'package:flutter_auth/Screens/Profile/profile.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_auth/Screens/Your Trip/trip.dart';
import 'package:percent_indicator/percent_indicator.dart';


void main() {
  runApp(Homescreen());
}

class Homescreen extends StatelessWidget {
  // This widget is the root of your application.
  static String tag = 'login-page';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: Center(child: MyHomePage(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}


class MyHomePage extends StatefulWidget {


  @override
  _MyHomePageState createState() => _MyHomePageState();

}
class Userinfo
{
  String email;
  String name;
  double amount;
}
class _MyHomePageState extends State<MyHomePage> {

  @override
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final firestoreInstance = Firestore.instance;
  Userinfo info = new Userinfo();

  Widget build(BuildContext context) {
    return FutureBuilder<Userinfo>(
      future: getData(), // function where you call your api
      builder: (BuildContext context,
          AsyncSnapshot<Userinfo> snapshot) { // AsyncSnapshot<Your object type>
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
              body: Center(
                child: Container(
                    height: 100,
                    child:new CircularPercentIndicator(
                      radius: 80.0,
                      lineWidth: 5.0,
                      percent: 1.0,
                      center: new Text("Loading.."),
                      progressColor: Colors.blue[700],
                    )

                ),
              )

          );
        } else {

          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(61.0),
              child: AppBar(
                title: Image.asset('assets/images/ss2.png', height: 160, width: 250,
                ),

                actions: [
                  IconButton(icon: Icon(Icons.account_circle_rounded),
                    onPressed: () {
                      Navigator.push(context,
                          new MaterialPageRoute(builder: (context) => Profilepage())
                      );
                    },
                  ),
                ],
                iconTheme: IconThemeData(color: Colors.black),
              ),
            ),


            drawer: StreamBuilder<Object>(
                stream: null,
                builder: (context, snapshot) {
                  return Drawer(

                    child: ListView(

                        padding: EdgeInsets.all(0.0),
                        children: <Widget>[
                          UserAccountsDrawerHeader(
                            arrowColor: Colors.black,
                            accountName: Text(
                              info.email, style: TextStyle(color: Colors.black),),
                            accountEmail: Text(
                              info.name, style: TextStyle(color: Colors.black),),
                            currentAccountPicture: CircleAvatar(
                              // backgroundImage: ExactAssetImage('assets/images/hassan.JPG'),
                              child: Text(info.name[0]),
                              backgroundColor: Colors.white60,

                            ),


                            onDetailsPressed: () async {

                            },


                          ),
                          Divider(),
                          ListTile(
                            title: Text('Your Trips'),
                            leading: Icon(Icons.trip_origin),
                            onTap: () {
                              Navigator.push(context, new MaterialPageRoute(
                                  builder: (BuildContext context) => Trips()),
                              );
                            },
                          ),

                          ListTile(
                            title: Text('Wallet'),
                            leading: Icon(Icons.money),
                            onTap: () {
                              Navigator.push(context, new MaterialPageRoute(
                                  builder: (BuildContext context) => new Wallet1(info.email,info.name)),
                              );
                            },
                          ),

                          ListTile(
                            title: Text('Help'),
                            leading: Icon(Icons.call),
                            onTap: () {
                              Navigator.push(context, new MaterialPageRoute(
                                  builder: (BuildContext context) => new HelpPage()),
                              );
                            },
                          ),


                          Divider(),

                          ListTile(
                            title: Text('Settings'),
                            leading: Icon(Icons.settings),
                            onLongPress: () {},
                          ),

                          ListTile(
                              title: Text('Logout'),
                              leading: Icon(Icons.logout),
                              onTap: () {
                                Navigator.push(context, new MaterialPageRoute(
                                    builder: (BuildContext context) => new WelcomeScreen()),
                                );
                              }
                          ),
                        ]

                    ),

                  );
                }
            ),

            bottomNavigationBar: BottomNavigationBar(
              // this will be set when a new tab is tapped
              items: [
                BottomNavigationBarItem(
                  icon: Text(""),
                  activeIcon: Text(""),
                  title: Container(
                    height: 0.0,
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Text(""),
                  activeIcon: Text(""),
                  title: Container(
                    height: 0.0,
                  ),
                ),

              ],
              backgroundColor: Colors.blue,
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.white,


            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(context, new MaterialPageRoute(
                    builder: (BuildContext context) => new MapView()),
                );
              },
              label: const Text('Book Luggage'),
              icon: const Icon(Icons.car_rental),
              backgroundColor: Colors.red,

            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

            body: GoogleMap(


              initialCameraPosition: CameraPosition(
                target: LatLng(27.2046, 77.4977),
                zoom: 15,

              ),

            ),

          );

        }
      },
    );
  }
  Future<Userinfo> getData() async {
    String uid =await getId();
    // Userinfo info = new Userinfo();
    CollectionReference _collectionRef = Firestore.instance.collection('Users');
    QuerySnapshot querySnapshot = await _collectionRef.getDocuments();
    for(int i=0;i<querySnapshot.documents.length;i++)
    {
      var a = querySnapshot.documents[i];
      if(a.documentID.toString()==uid) {
        info.email = a.data["email"].toString();
        info.name = a.data['fname'].toString();
      }

    }



    return info;
  }


}

Future<String> getId() async {
  final FirebaseUser user = await FirebaseAuth.instance.currentUser();
  final String uid = user.uid.toString();
  return uid;
}
