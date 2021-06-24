import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter_auth/Screens/Home/home_screen.dart';
import 'package:flutter_auth/Screens/viewbooking/viewbooking.dart';
import 'package:flutter_auth/components/rounded_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' show cos, sqrt, asin;

class RightnowbookingPage extends StatefulWidget {
  Position sourcelocation;
  Position Destination;

  RightnowbookingPage(this.sourcelocation, this.Destination);

  @override
  _RightnowbookingPageState createState() => _RightnowbookingPageState();
}

class Locations{
  double lat;
  double lng;
  String DriverID;
  set(double lat,double lng,String did)
  {
    this.DriverID=did;
    this.lat= lat;
    this.lng = lng;
  }
}


class _RightnowbookingPageState extends State<RightnowbookingPage> {
  final _formKey = GlobalKey<FormState>();
  final descriptionController = TextEditingController();
  final weightcontroller=TextEditingController();
  final listOfLuggageTypes = ["sensitive", "flammable","cold-storage"];
  String luggageTypeDropdownValue = 'sensitive';
  final listOfBookingTypes = ["Pre-Booking", "Right-Now"];
  String bookingTypeDropdownValue = 'Pre Booking';
  final lengthController=TextEditingController();
  final widthController=TextEditingController();
  final heightController=TextEditingController();
  final dateController=TextEditingController();
  final dbRef = FirebaseDatabase.instance.reference().child("pets");
  Completer<GoogleMapController> _controller = Completer();
  final databaseReference = FirebaseDatabase.instance.reference();
  static const LatLng _center = const LatLng(45.521563, -122.677433);
  String _startAddress = '';
  String _destinationAddress = '';
  String UserID;
  String _placeDistance;
  DateTime dateTime;
  final Set<Marker> _markers = {};

  LatLng _lastMapPosition = _center;

  MapType _currentMapType = MapType.normal;

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite





          : MapType.normal;
    });
  }

  void _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        infoWindow: InfoWindow(
          title: 'Really cool place',
          snippet: '5 Star Rating',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  List<String> _locations1 = ['Partial', 'Full'];
  String _selectedLocation1;
  List<String> _locations2 = ['Sensitive', 'Heavy','cold-storage'];
  String _selectedLocation2;
  List<String> _locations3 = ['1.0', '2.0', '3.0', '4.0', '5.0', '6.0', '7.0'];
  String _selectedLocation3;
  double fare;
  List dts = new List();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAddress();
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pre-Booking'),
      ),
      body: SafeArea(
        child: Column(children: <Widget>[
          Container(
            child: Column(children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(40.0, 15.0, 40.0, 00.0),
                child: Center(
                  child: Center(
                    child: Text(
                      "Enter Required Information of Your Luggage",
                      style: TextStyle(fontFamily: 'AkayaTelivigala',

                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(50.0, 0.0, 00.0, 00.0),
                child: Row(
                  //ROW 1
                  children: [
                    DropdownButton(
                      hint: Text('Vehicle type'),
                      style: TextStyle(
                        color: Colors.black,

                        fontStyle: FontStyle.italic,
                      ),
                      // Not necessary for Option 1
                      value: _selectedLocation1,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedLocation1 = newValue;
                        });
                      },
                      items: _locations1.map((location) {
                        return DropdownMenuItem(
                          child: new Text(location),
                          value: location,
                        );
                      }).toList(),
                    ),
                    DropdownButton(
                      hint: Text('Luggage type'),
                      style: TextStyle(
                        color: Colors.black,

                        fontStyle: FontStyle.italic,
                      ),
                      // Not necessary for Option 1
                      value: _selectedLocation2,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedLocation2 = newValue;
                        });
                      },
                      items: _locations2.map((location) {
                        return DropdownMenuItem(
                          child: new Text(location),
                          value: location,
                        );
                      }).toList(),
                    ),

                  ],
                ),
              ),
              Container(
                child: Column( //ROW 2

                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(50.0, 0.0, 40.0, 00.0),
                        child: TextField(
                          controller:weightcontroller,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "Enter weight of luggage",
                            hintStyle: TextStyle(
                              color: Colors.black,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(50.0, 0.0, 40.0, 00.0),
                        child: TextField(
                          controller: descriptionController,
                          decoration: InputDecoration(

                            hintText: "Enter description of luggage",
                            hintStyle: TextStyle(
                              color: Colors.black,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                    ]),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(50.0, 00.0, 40.0, 00.0),
                  child: Row(
                    // ROW 3
                    children: [
                      Container(
                        child: Flexible(
                            child: new TextField(
                              controller: lengthController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(labelText: "Length"),
                              style: TextStyle(
                                color: Colors.black,
                                fontStyle: FontStyle.italic,
                              ),
                            )),
                      ),
                      Flexible(
                        child: new TextField(
                          controller: widthController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: "Width"),
                          style: TextStyle(
                            color: Colors.black,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      Flexible(
                        child: new TextField(
                          controller: heightController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: "Height"),
                          style: TextStyle(
                            color: Colors.black,

                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(50.0, 0.0, 40.0, 00.0),
                child: DateTimePicker(

                  style: TextStyle(
                    color: Colors.black,

                    fontStyle: FontStyle.italic,
                  ),
                  // controller:dateController,
                  type: DateTimePickerType.dateTimeSeparate,
                  dateMask: 'd MMM, yyyy',
                  initialValue: DateTime.now().toString(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  icon: Icon(Icons.event),
                  dateLabelText: 'Date',
                  timeLabelText: "Time",
                  selectableDayPredicate: (date) {
                    // Disable weekend days to select from the calendar
                    if (date.weekday == 6 || date.weekday == 7) {
                      return false;
                    }

                    return true;
                  },

                  onChanged: (val) => print(val),

                  validator: (val) {

                    print(val);
                    return null;
                  },
                  onSaved: (val) => print(val),
                ),
              ),
            ]

            ),

          ),
          Container(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
              mapType: _currentMapType,
              markers: _markers,
              onCameraMove: _onCameraMove,
            ),
            height: MediaQuery
                .of(context)
                .size
                .height /
                2.5, // Also Including Tab-bar height.
          ),
        ]

        ),

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
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton.extended(
          onPressed: () async {

            if(descriptionController.text =='' || weightcontroller.text =='' || lengthController.text == '' || widthController.text ==' ' || heightController.text =='')
            {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('something is missing')));
              return;
            }
            UserID = await getUserId();
            List<Locations> locationslist = List<Locations>();
            locationslist= await getloc();
            double distance;
            double totalDistance = calculateDistance(widget.sourcelocation.latitude, widget.sourcelocation.longitude, widget.Destination.latitude, widget.Destination.longitude);
            for(int i=0;i<locationslist.length;i++) {


              dts.add(calculateDistance(widget.sourcelocation.latitude,widget.sourcelocation.longitude, locationslist[i].lat,locationslist[i].lng));

            }
            fare = (totalDistance*100) ;
            if(_selectedLocation1=="Full")
            {
              fare = fare*2;
            }


            //calculate min index
            double min=dts[0];
            int minindex=0;
            for(int i=0;i<3;i++)
            {

              if(min> dts[i])
              {
                min = dts[i];
                minindex=i;
              }
            }

            dateTime = DateTime.now();
            Firestore.instance.collection("TempBooking").document(UserID).setData({
              "Description": descriptionController.text,
              "weight": weightcontroller.text,
              "length":lengthController.text,
              "width":widthController.text,
              "height":heightController.text,
              "luggage type":_selectedLocation2,
              "vehicle type":_selectedLocation1,
              'distance':totalDistance,
              'DriverID':locationslist[minindex].DriverID,
              'UserID': UserID,
              "Driverlat": locationslist[minindex].lat,
              "Driverlng": locationslist[minindex].lng,
              "Srclat":widget.sourcelocation.latitude,
              "Srclng":widget.sourcelocation.longitude,
              "Destlat":widget.Destination.latitude,
              "Destlng":widget.Destination.longitude,
              "SrcAddress":_startAddress,
              "DestAddress":_destinationAddress,
              "Fare": fare.toStringAsFixed(0),
              "Date":dateTime,


            });
            Firestore.instance.collection("Bookings")
                .add({
              "Description": descriptionController.text,
              "weight": weightcontroller.text,
              "length":lengthController.text,
              "width":widthController.text,
              "height":heightController.text,
              "luggage type":_selectedLocation2,
              "vehicle type":_selectedLocation1,
              'distance':totalDistance,
              'DriverID':locationslist[minindex].DriverID,
              'UserID': UserID,
              "Driverlat": locationslist[minindex].lat,
              "Driverlng": locationslist[minindex].lng,
              "Srclat":widget.sourcelocation.latitude,
              "Srclng":widget.sourcelocation.longitude,
              "Destlat":widget.Destination.latitude,
              "Destlng":widget.Destination.longitude,
              "SrcAddress":_startAddress,
              "DestAddress":_destinationAddress,
              "Fare": fare.toStringAsFixed(0),
              "Date":dateTime,


            }

            ).then((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Successfully Added')));



              descriptionController.clear();
              weightcontroller.clear();
              heightController.clear();
              widthController.clear();
              lengthController.clear();

            }).catchError((onError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(onError)));
            });

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
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0),),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white,
                                  blurRadius: 16.0,
                                  spreadRadius: 0.5,
                                  offset: Offset(0.7,0.7),
                                )
                              ]
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 17.0),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  width: double.infinity,
                                  color: Colors.white,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Row(
                                      children: [
                                        Image.asset('assets/images/mazda.jpg',height: 70.0, width: 80.0,),
                                        SizedBox(width: 16.0,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Distance",

                                              style: TextStyle(
                                                fontSize: 18.0,
                                                fontFamily: "Brand-Bold",),
                                            ),
                                            Text(
                                              totalDistance.toStringAsFixed(1),
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.black,),
                                            ),

                                          ],
                                        ),
                                        SizedBox(width: 16.0,),
                                        Column(

                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Fare",
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                fontFamily: "Brand-Bold",),
                                            ),
                                            Text(
                                              fare.toStringAsFixed(0),
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.black,),
                                            ),

                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Row(
                                    children: [
                                      Icon(FontAwesomeIcons.moneyCheckAlt, size: 18.0, color: Colors.black,),
                                      SizedBox(width: 16.0,),
                                      Text("cash",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 6.0,),
                                      Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 16.0,),
                                    ],
                                  ),
                                ),

                                SizedBox(height: 24.0,),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                                  child: RaisedButton(
                                    onPressed: () async {
                                      String uid = await getUserId();
                                      String BookingID=uid;
                                      Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context)
                                      => new ViewBooking(BookingID),
                                      ));



                                    },
                                    color: Theme.of(context).accentColor,
                                    child: Padding(
                                      padding: EdgeInsets.all(17.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Request", style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,color: Colors.white),),
                                          Icon(FontAwesomeIcons.taxi, color: Colors.white, size: 26.0,),


                                        ],
                                      ),
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
          label: const Text('Create  Booking'),
          backgroundColor: Colors.red,
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

    );

  }
  _getAddress() async {
    try {
      List<Placemark> p =
      await placemarkFromCoordinates(widget.sourcelocation.latitude, widget.sourcelocation.longitude);
      List<Placemark> p1 =
      await placemarkFromCoordinates(widget.Destination.latitude, widget.Destination.longitude);
      //  getting location from lat and long
      Placemark place = p[0];
      Placemark place1 = p1[0];


      setState(() {
        _startAddress=
        "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
        _destinationAddress=
        "${place1.name}, ${place1.locality}, ${place1.postalCode}, ${place1.country}";
      });
    } catch (e) {
      print(e);
    }
  }

}

double calculateDistance(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a));
}
Future<List<Locations>> getloc() async {
  String did;
  double lat,lng;
  CollectionReference _collectionRef = Firestore.instance.collection('Location');
  QuerySnapshot querySnapshot = await _collectionRef.getDocuments();
  List<Locations> locationslist =  List<Locations>();
  for (int i = 0; i < querySnapshot.documents.length; i++) {
    var a = querySnapshot.documents[i];
    did = a.documentID.toString();
    lat =double.parse(a.data['lat'].toString());
    lng =double.parse(a.data['lng'].toString());
    Locations loc = new Locations();
    loc.set(lat, lng, did);
    locationslist.add(loc);
  }

  return locationslist;
}