import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Home/home_screen.dart';
import 'package:flutter_auth/Screens/Location/secrets.dart';// Stores the Google Maps API Key
import 'package:flutter_auth/Screens/Prebooking/components/prebooking.dart';
import 'package:flutter_auth/Screens/Rightnowbooking/componenets/rightnowbooking.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dart:math' show cos, sqrt, asin;

import 'package:percent_indicator/circular_percent_indicator.dart';

class ViewBooking extends StatefulWidget {
  /* final Position sourcelocation;
  final Position Destination;
  final double driverlat;
  final double driverlng;

  */
  String BookingID;

  //ViewBooking(this.sourcelocation,this.Destination,this.driverlat,this.driverlng);
  ViewBooking(this.BookingID);

  @override
  _ViewBookingState createState() => _ViewBookingState();
}
class Bookings{
  String BookingID;
  String Source;
  String Destination;
  String Fare;
  String dateTime;
  double Srclat;
  double Srclng;
  double Destlat;
  double Destlng;
  double Driverlat;
  double Driverlng;
  String Desciption;


}

class _ViewBookingState extends State<ViewBooking> {

  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));
  GoogleMapController mapController;

  Position _currentPosition;
  String _currentAddress;

  final startAddressController = TextEditingController();
  final destinationAddressController = TextEditingController();

  final startAddressFocusNode = FocusNode();
  final destinationAddressFocusNode = FocusNode();

  String _startAddress = '';
  String _destinationAddress = '';
  String _placeDistance;
  Bookings b = new Bookings();

  Set<Marker> markers = {};

  PolylinePoints polylinePoints;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  final _scaffoldKey = GlobalKey<ScaffoldState>();


  // Method for calculating the distance between two places
  _getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;
        print('CURRENT POS: $_currentPosition');
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 18.0,
            ),
          ),
        );
      });
      await _getAddress();
    }).catchError((e) {
      print(e);
    });
  }

  // Method for retrieving the address
  _getAddress() async {
    try {
      List<Placemark> p =
      await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);
      //  getting location from lat and long
      Placemark place = p[0];

      setState(() {
        _currentAddress =
        "${place.name}, ${place.locality}, ${place.postalCode}, ${place
            .country}";
        startAddressController.text = _currentAddress;
        _startAddress = _currentAddress;
      });
    } catch (e) {
      print(e);
    }
  }

  // Method for calculating the distance between two places
  Future<bool> _calculateDistance() async {
    Marker startMarker = Marker(
      markerId: MarkerId('start'),
      position: LatLng(
        b.Srclat,
        b.Srclng,
      ),
      infoWindow: InfoWindow(
        title: 'Start',
        snippet: _startAddress,
      ),
    );

    // Destination Location Marker
    Marker destinationMarker = Marker(
      markerId: MarkerId('Destinaion'),
      position: LatLng(
          b.Destlat,
          b.Destlng),
      infoWindow: InfoWindow(
        title: 'Destination',
        snippet: _destinationAddress,
      ),
      icon: BitmapDescriptor.defaultMarker,
    );
    Marker Drivermarker = Marker(
        markerId: MarkerId('Driver'),
        position: LatLng(b.Driverlat, b.Driverlng,
        ),
        infoWindow: InfoWindow(
          title: 'Driver',
        ),
        icon: BitmapDescriptor.defaultMarker
    );

    // Adding the markers to the list
    markers.add(startMarker);
    markers.add(destinationMarker);
    markers.add(Drivermarker);
  }

  // Calculating to check that the position relative


  // Calculating the distance between the start and the end positions
  // with a straight path, without considering any route
  // double distanceInMeters = await Geolocator().bearingBetween(
  //   startCoordinates.latitude,
  //   startCoordinates.longitude,
  //   destinationCoordinates.latitude,
  //   destinationCoordinates.longitude,
  // );


  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  _createPolylines(Position start, Position destination) async {
    polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      Secrets.API_KEY, // Google Maps API Key
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.transit,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      jointType: JointType.round,
      points: polylineCoordinates,
      width: 3,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      geodesic: true,
    );
    polylines[id] = polyline;
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Bookings>(
        future: getData(), // function where you call your api
        builder: (BuildContext context,
            AsyncSnapshot<
                Bookings> snapshot) { // AsyncSnapshot<Your object type>
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
                        progressColor: Colors.green,
                      )

                  ),
                )

            );
          }

          else {
            return Scaffold(
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
              floatingActionButton: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton.extended(
                  onPressed: () async {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Positioned(
                                bottom: 0.0,
                                right: 0.0,
                                left: 0.0,
                                child: Container(
                                  height: 250.0,
                                  decoration: BoxDecoration(
                                    color: Colors.white24,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16.0),
                                      topRight: Radius.circular(16.0),),

                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(50.0, 0.0, 40.0, 00.0),
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          width: double.infinity,
                                          color: Colors.white,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(50.0, 0.0, 40.0, 00.0),
                                            child: Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child: Column(
                                          //ROW 1
                                          children: [
                                              Icon(Icons.person,color: Colors.blue,),
                                              Text('Ashfaq Ahmed',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                               Padding(
                                                 padding: const EdgeInsets.all(4.0),
                                                 child: Column(
                                                  //ROW 1
                                                  children: [
                                                    Icon(Icons.car_rental,color: Colors.blue,),
                                                    Text('WagonR LRE-3333',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 17.0,
                                                      ),
                                                    ),

                                      ],

                                    ),
                                               ),
                                              Padding(
                                                padding: const EdgeInsets.all(4.0),
                                                child: Column(
                                                  //ROW 1
                                                  children: [
                                                    Icon(Icons.phone,color: Colors.blue,),
                                                    Text('0321-1234567',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 17.0,
                                                      ),
                                                    ),

                                                  ],

                                                ),
                                              ),

]
                                              ),
                                            )
                                          ),


                                        ),


                                        SizedBox(height: 24.0,),
                                        RaisedButton(
                                          onPressed: () async {



                                          },
                                          color: Theme.of(context).accentColor,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(50.0, 0.0, 40.0, 0.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                Text("Driver Information", style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold,color: Colors.white),),
                                                Icon(FontAwesomeIcons.info, color: Colors.white, size: 20.0,),


                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),


                            ],
                          );
                        });
                  },
                  label: const Text('Contact Driver'),
                  backgroundColor: Colors.red,
                ),
              ),
              // label: const Text('Book Luggage'),
              // icon: const Icon(Icons.car_rental),

              floatingActionButtonLocation: FloatingActionButtonLocation
                  .centerDocked,

              body: GoogleMap(
                markers: markers != null ? Set<Marker>.from(markers) : null,
                initialCameraPosition: CameraPosition(
                  target: LatLng(b.Driverlat,b.Driverlng),
                  zoom: 15,


                ),

              ),

            );
          }
        }
    );
  }


  void initState() {
    super.initState();
    _calculateDistance();
  }

  Future<Bookings> getData() async {

    String uid = await getUserId();
    DocumentReference docref;
    if(widget.BookingID==uid)
    {
      docref = Firestore.instance.collection('TempBooking')
          .document(widget.BookingID);
    }
    else
    {
      docref = Firestore.instance.collection('Bookings')
          .document(widget.BookingID);
    }

    DocumentSnapshot querySnapshot = await docref.get();
    var a = querySnapshot.data;
    b.BookingID = querySnapshot.documentID;
    b.dateTime = querySnapshot.data['Date'].toString();
    b.Source = querySnapshot.data['SrcAddress'];
    b.Destination = querySnapshot.data['DestAddress'];
    b.Fare = querySnapshot.data['Fare'];
    b.Srclat = querySnapshot.data['Srclat'];
    b.Srclng = querySnapshot.data['Srclng'];
    b.Destlat = querySnapshot.data['Destlat'];
    b.Destlng = querySnapshot.data['Destlng'];
    b.Driverlat = querySnapshot.data['Driverlat'];
    b.Driverlng = querySnapshot.data['Driverlng'];
    print("Driverlat${b.Driverlat}");
    print("Driverlng${b.Driverlng}");
    print("Srclat${b.Srclat}");
    print("Srclng${b.Srclng}");
    print("dlat${b.Driverlat}");
    print("dlng${b.Driverlng}");
    Marker startMarker = Marker(
      markerId: MarkerId('start'),
      position: LatLng(
        b.Srclat,
        b.Srclng,
      ),
      infoWindow: InfoWindow(
        title: 'Start',
        snippet: _startAddress,
      ),
    );

    Marker destinationMarker = Marker(
      markerId: MarkerId('Destinaion'),
      position: LatLng(
        b.Destlat,
        b.Destlng,),
      infoWindow: InfoWindow(
        title: 'Destination',
        snippet: _destinationAddress,
      ),
      icon: BitmapDescriptor.defaultMarker,
    );
    print('jjjjjj');


    Marker Drivermarker = Marker(
        markerId: MarkerId('Driver'),
        position: LatLng(b.Driverlat, b.Driverlng,
        ),
        infoWindow: InfoWindow(
          title: 'Driver',
        ),
        icon: BitmapDescriptor.defaultMarker
    );



    // Adding the markers to the list
    markers.add(startMarker);
    markers.add(destinationMarker);
    markers.add(Drivermarker);


    return Future.value(b);
  }
}
Future<String> getUserId() async {
  final FirebaseUser user = await FirebaseAuth.instance.currentUser();
  final String uid = user.uid.toString();
  return uid;
}