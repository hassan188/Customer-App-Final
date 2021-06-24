import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/components/background.dart';
import 'package:flutter_auth/Screens/viewbooking/viewbooking.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';


class Trips extends StatefulWidget {
  @override
  TripsState createState() => TripsState();
}
class Bookings{
  String BookingID;
  String Source;
  String Destination;
  String Fare;
  String dateTime;

}

class TripsState extends State<Trips> {

  int bookingnumber = 1;
  int count;
  List<Bookings> bookings = List<Bookings>();
  bool isLoading = false;
  QuerySnapshot querySnapshot;

  Future<List<Bookings>> getData() async {
    CollectionReference _collectionRef = Firestore.instance.collection('Bookings');
    querySnapshot = await _collectionRef.getDocuments();
    for (int i = 0; i < querySnapshot.documents.length; i++) {
      Bookings b = new Bookings();
      var a = querySnapshot.documents[i];
      b.BookingID = a.documentID;
      b.dateTime = a.data['Date'].toString();
      b.Source = a.data['SrcAddress'];
      b.Destination = a.data['DestAddress'];
      b.Fare = a.data['Fare'];
      bookings.add(b);

    }
    return Future.value(bookings);
  }
  @override void dispose() {
    // TODO: implement dispose
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Bookings>>(
      future: getData(), // function where you call your api
      builder: (BuildContext context,
          AsyncSnapshot<List<Bookings>> snapshot) { // AsyncSnapshot<Your object type>
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
              body: Center(
                child: Container(
                  height: 100,
                  child: Text('Loading pleae wait',style: TextStyle(fontSize: 30),),

                ),
              )

          );
        } else {
          if (snapshot.hasError) {
            return Scaffold(
                appBar: AppBar(
                  title: Text('Your Previous Bookings'),
                ),
                body: Center(
                  child: Container(
                    height: 100,
                    child: Text('Error: ${snapshot.error}',style: TextStyle(fontSize: 30),),

                  ),
                )

            );
          }
          if (snapshot.hasData==false) {
            return Scaffold(
                appBar: AppBar(
                  title: Text('Your Previous Bookings'),
                ),
                body: Center(
                  child: Container(
                    height: 100,
                    child: Text('You have not made any Booking yet',style: TextStyle(fontSize: 20),),

                  ),
                )

            );

          }
          else  return Scaffold(
            appBar: AppBar(
              title: Text('Your Previous Bookings'),
            ),
            body: ListView.separated(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ListTile(
                    title: Text(bookings[index].Source +' -->'+ bookings[index].Destination ,style:TextStyle(color: Colors.black) ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top:10),
                      child: Row(


                          children:<Widget>[

                            Text('Fare:  '+ bookings[index].Fare,style:TextStyle(color: Colors.cyan[700])),
                            Text(' BookingID:  '+ bookings[index].BookingID,style:TextStyle(color: Colors.cyan[700])),

                          ]

                      ),
                    ),
                    trailing: IconButton(
                        icon: Icon(Icons.arrow_forward_ios),
                        onPressed:(){
                          Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context)
                          => new ViewBooking(bookings[index].BookingID),
                          ));
                        }
                    ),



                  ),
                );

              },
              separatorBuilder: (context, index) {
                return Divider();
              },

            ),


          );

        }
      },
    );
  }

}