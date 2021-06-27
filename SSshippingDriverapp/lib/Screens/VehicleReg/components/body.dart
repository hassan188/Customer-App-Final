import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auth/Screens/Login/components/body.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VRegisterPage extends StatefulWidget {

  final String fname;
  String lname;
  String email;
  String password;
  String address;
  String cnic;
  String phone;
  String citypref;
  String vehiclePref;
  String WeightCap;

  VRegisterPage({Key key, @required this.email,this.password,this.phone,this.cnic,this.address, this.fname,this.lname,this.citypref,this.vehiclePref,this.WeightCap}) ;
  @override
  _VRegisterPageState createState() => new _VRegisterPageState();
}

class _VRegisterPageState extends State<VRegisterPage> {
  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  //
  // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyCustomFormState>!
  List<String> _locations2 = ['Pick Up', 'Shahzore','Mazda'];
  String _selectedLocation2;
  List<String> _locations3 = ['Pick Up', 'Shahzore','Mazda'];
  String _selectedLocation3;
  List<String> _locations4 = ['1','2','3','4','5','6','7','8','9','10'];
  String _selectedLocation4;


  final _formKey = GlobalKey<FormState>();
  final ownerNameTextEditController = new TextEditingController();
  final ownerCnicTextEditController = new TextEditingController();
  final companyNameTextEditController = new TextEditingController();
  final registeredNumberTextEditController = new TextEditingController();
  final weightCapTextEditController = new TextEditingController();
  final colorTextEditController = new TextEditingController();
  final lengthController=TextEditingController();
  final widthController=TextEditingController();
  final heightController=TextEditingController();



  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String _errorMessage = '';

  void processError(final PlatformException error) {
    setState(() {
      _errorMessage = error.message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[100],
      body: Center(
          child: Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 36.0, left: 24.0, right: 24.0),
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Vehicle Information',
                      style: TextStyle(fontSize: 36.0, color: Colors.indigo),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      '$_errorMessage',
                      style: TextStyle(fontSize: 14.0, color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: ownerNameTextEditController,
                      keyboardType: TextInputType.name,
                      autofocus: true,
                      textInputAction: TextInputAction.next,

                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Owner Name',
                        contentPadding:
                        EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      controller: companyNameTextEditController,
                      keyboardType: TextInputType.name,
                      autofocus: true,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Company Name',
                        contentPadding:
                        EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(

                      controller: ownerCnicTextEditController,
                      keyboardType: TextInputType.text,
                      autofocus: false,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Owner CNIC',
                        contentPadding:
                        EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(

                      controller: registeredNumberTextEditController,
                      keyboardType: TextInputType.text,
                      autofocus: false,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Vehicle Registered Number',
                        contentPadding:
                        EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                      ),

                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(

                      controller: weightCapTextEditController,
                      keyboardType: TextInputType.number,
                      autofocus: true,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Weight Capacity',
                        contentPadding:
                        EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: Container(
                      padding: const EdgeInsets.only(left: 9.0, right: 10.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32.0),
                          color: Colors.white,
                          border: Border.all()),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          hint: Text('Vehicle Type'),
// Not necessary for Option 0
                          value: _selectedLocation3,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedLocation3 = newValue;
                            });
                          },
                          items: _locations3.map((location) {
                            return DropdownMenuItem(
                              child: new Text(location),
                              value: location,

                            );
                          }).toList(),

                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: Container(
                      padding: const EdgeInsets.only(left: 9.0, right: 10.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32.0),
                          color: Colors.white,
                          border: Border.all()),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          hint: Text('Car Condition'),
// Not necessary for Option 0
                          value: _selectedLocation4,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedLocation4 = newValue;
                            });
                          },
                          items: _locations4.map((location) {
                            return DropdownMenuItem(
                              child: new Text(location),
                              value: location,

                            );
                          }).toList(),

                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 00.0, 15.0, 00.0),
                      child: Row(
                        // ROW 3
                        children: [
                          Container(
                            child: Flexible(
                                child: Padding(
                                  padding: const     EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 20.0),
                                  child: new TextField(
                                    controller: lengthController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: 'length',
                                      contentPadding:
                                      EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 10.0),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(35.0)),
                                    ),
                                  ),
                                )),
                          ),
                          Flexible(
                            child: Padding(
                              padding: const     EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 20.0),
                              child: new TextField(
                                controller: widthController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: 'width',
                                  contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(32.0)),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Padding(
                              padding: const   EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 20.0),
                              child: new TextField(
                                controller: heightController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: 'height',
                                  contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(32.0)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),



                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      onPressed: () {
                        Navigator.push(context, new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                LoginPage()),
                        );
                        if (_formKey.currentState.validate()) {
                          _firebaseAuth
                              .createUserWithEmailAndPassword(
                              email: widget.email,
                              password: widget.password)
                              .then((onValue) async {
                            final uid = await getData();

                            Firestore.instance
                                .document('Drivers/$uid')
                                .setData({
                              'fname': widget.fname,
                              'lname': widget.lname,
                              'phone#': widget.phone,
                              'cnic':widget.cnic,
                              'email':widget.email,
                              'password':widget.password,
                              'city prefrences':widget.citypref,
                              'vehicle prefrences':widget.vehiclePref,
                              'weight capacity':widget.WeightCap,

                            });
                            Firestore.instance.
                            collection('wallet').document(uid).setData({
                              'amount':1000
                            });
                            Firestore.instance.
                            collection('Vehicles').
                            add({
                              'drivers id':uid,
                              'owner name': ownerNameTextEditController.text,
                              'owner cnic': ownerCnicTextEditController.text,
                              'weight capacity': weightCapTextEditController.text,
                              'registered_no': registeredNumberTextEditController.text,
                              'color':colorTextEditController.text,
                              'company name':companyNameTextEditController.text,
                              'Type':_selectedLocation3,
                              'Condition':_selectedLocation4,
                              "length":lengthController.text,
                              "width":widthController.text,
                              "height":heightController.text,

                            })
                                .then((userInfoValue) {

                            },
                            );
                          }).catchError((onError) {
                            processError(onError);
                          });
                        }
                      },
                      padding: EdgeInsets.all(12),
                      color: Colors.indigoAccent,
                      child: Text('Done'.toUpperCase(),
                          style: TextStyle(color: Colors.black)),

                    ),
                  ),
                ],
              )
          )

      ),

    );
  }
}
Future<String> getData() async {
  final FirebaseUser user = await FirebaseAuth.instance.currentUser();
  final String uid = user.uid.toString();
  return uid;
}