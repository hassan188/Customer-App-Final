import 'dart:async';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Profile/profile.dart';
import 'package:flutter_auth/Screens/Transactions/Transactions.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'constants1.dart';





class Wallet1 extends StatefulWidget {
  String email;
  String name;

  Wallet1(this.email,this.name);
  @override
  _Wallet1State createState() => _Wallet1State();
}

class _Wallet1State extends State<Wallet1> {
  final EmailController = TextEditingController();
  final AmountController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  double balance;
  @override
  Widget build(BuildContext context) {


    return FutureBuilder<double>(
      future: GetBalance(), // function where you call your api
      builder: (BuildContext context,
          AsyncSnapshot<double> snapshot) { // AsyncSnapshot<Your object type>
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
                  title: Text('Your Transactions'),
                ),
                body: Center(
                  child: Container(
                    height: 100,
                    child: Text('Error: ${snapshot.error}',style: TextStyle(fontSize: 30),),

                  ),
                )

            );

          }
          else
          {
            return Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                title: Text('Wallet'),
              ),

              body: Container(
                padding: EdgeInsets.only(top: 64),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: <Widget>[
                          _buildHeader(),
                          SizedBox(height: 16),
                          _buildGradientBalanceCard(),
                          SizedBox(height: 24.0),
                          _buildCategories(),
                        ],
                      ),
                    ),
                    SizedBox(height: 32),
                  ],
                ),
              ),
            );
          }

        }
      },
    );
  }

  Row _buildCategories() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          height: 100.0,
          width: 100.0,
          child: RaisedButton(
            color: Colors.red,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Icon(Icons.send), // icon
                Text("Send"), // text

              ],
            ),

            onPressed: () {
              _openPopup(context);
            },

          ),
        ),
        Container(
          height: 100.0,
          width: 100.0,
          child: FlatButton(
            color: Colors.yellow,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.volunteer_activism), // icon
                Text("Activities"), // text
              ],
            ),

            onPressed: () {

            },
          ),
        ),
        Container(
          height: 100.0,
          width: 100.0,
          child: FlatButton(
            color: Colors.teal,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.payment), // icon
                Text("Transactions",style: TextStyle(fontSize: 11),), // text
              ],
            ),

            onPressed: () {
              Navigator.push(context, new MaterialPageRoute(
                  builder: (BuildContext context) => new Transactions()),
              );
            },
          ),
        ),

      ],
    );
  }

  Container _buildGradientBalanceCard() {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.indigo[900],
            Constants.deepBlue,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(

              balance.toString(),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 28,
              ),
            ),
            SizedBox(height: 4),
            Text(
              "Total Balance",
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Hello,",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(

              widget.name.toString(),
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Row _buildTransactionItem(
      {Color color,
        IconData iconData,
        String date,
        String title,
        double amount}) {
    return Row(
      children: <Widget>[
        Container(
          height: 52,
          width: 52,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Icon(
            iconData,
            color: Colors.white,
          ),
        ),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              date,
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            )
          ],
        ),
        Spacer(),
        Text(
          "-\$ $amount",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Column _buildCategoryCard(
      {Color bgColor, Color iconColor, IconData iconData, String text}) {
    return Column(
      children: <Widget>[
        Container(
          height: 75,
          width: 75,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Icon(
            iconData,
            color: iconColor,
            size: 36,
          ),
        ),
        SizedBox(height: 8),
        Text(text),
      ],

    );

  }
  _openPopup(context) {
    Alert(
        context: context,
        title: "Enter Information",
        content: Column(
          children: <Widget>[
            TextField(
              controller: EmailController,
              decoration: InputDecoration(
                icon: Icon(Icons.email_rounded),
                labelText: 'Sender Email',
              ),
            ),
            TextField(
              controller: AmountController,
              decoration: InputDecoration(
                icon: Icon(Icons.money),
                labelText: 'Amount Send',
              ),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: ()
            {
              getData();


            },
            child: Text(
              "Send",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show(

    );
  }
  Future<double> GetBalance() async {
    String uid =await getUid();
    DocumentReference documentReference = Firestore.instance.collection('Wallet').document(uid);
    DocumentSnapshot querySnapshot2 = await documentReference.get();
    balance = double.parse( querySnapshot2.data['amount'].toString());
    return balance;

  }
  Future<void> getData() async {
    String id;
    String uid = await getUid();
    CollectionReference _collectionRef = Firestore.instance.collection('Users');
    QuerySnapshot querySnapshot = await _collectionRef.getDocuments();
    for (int i = 0; i < querySnapshot.documents.length; i++) {
      var a = querySnapshot.documents[i];
      if (a.data['email'] == EmailController.text) {
        id = a.documentID;
      }
    }
    DocumentReference docref = Firestore.instance.document('Wallet/$id');
    DocumentSnapshot querySnapshot2 = await docref.get();
    DocumentReference docref1 = Firestore.instance.document('Wallet/$uid');
    DocumentSnapshot querySnapshot3 = await docref1.get();
    var a = querySnapshot2.data;
    int SenderWalletamount = querySnapshot3.data['amount'];
    int ReceiverWalletamount = querySnapshot2.data['amount'];

    int Enteredamount = int.parse(AmountController.text);
    if (SenderWalletamount < Enteredamount) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("You don't have sufficient Amount")));
    }
    else {
      Firestore.instance.document('Wallet/$uid').updateData({
        'amount': SenderWalletamount - Enteredamount,
      });
      Firestore.instance.document('Wallet/$id').updateData({
        'amount': ReceiverWalletamount + Enteredamount,
      });
      Navigator.pop(context);
    }
    Firestore.instance.collection("Transactions").add(
        {
          "ReceiverID": id,
          "ReceiverEmail":EmailController.text,
          "Date":DateTime.now(),
          "Amount":AmountController.text,
        });
  }

}

Future<String> getUid() async {
  final FirebaseUser user = await FirebaseAuth.instance.currentUser();
  final String uid = user.uid.toString();
  return uid;
}

