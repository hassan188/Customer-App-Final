import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Login/components/background.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';


class Transactions extends StatefulWidget {
  @override
  TransactionsState createState() => TransactionsState();
}
class Transaction{
  String ReceiverID;
  String ReceiverEmail;
  String Amount;
  String dateTime;

}

class TransactionsState extends State<Transactions> {

  int bookingnumber = 1;
  int count;
  List<Transaction> transactions = List<Transaction>();
  bool isLoading = false;
  QuerySnapshot querySnapshot;

  Future<List<Transaction>> getData() async {
    CollectionReference _collectionRef = Firestore.instance.collection('Transactions');
    querySnapshot = await _collectionRef.getDocuments();
    for (int i = 0; i < querySnapshot.documents.length; i++) {
      Transaction b = new Transaction();
      var a = querySnapshot.documents[i];
      b.dateTime= a.data['Date'].toString();
      b.ReceiverEmail = a.data['ReceiverEmail'];
      b.ReceiverID = a.data['ReceiverID'];
      b.Amount = a.data['Amount'];
      transactions.add(b);

    }
    return Future.value(transactions);
  }
  @override void dispose() {
    // TODO: implement dispose
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Transaction>>(
      future: getData(), // function where you call your api
      builder: (BuildContext context,
          AsyncSnapshot<List<Transaction>> snapshot) { // AsyncSnapshot<Your object type>
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
          if (snapshot.hasData==false) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Your Transactions'),
              ),
              body: Center(
                child: Container(
                  height: 100,
                  child: Text('You have not made any Transaction yet',style: TextStyle(fontSize: 20,color: Colors.red)),

                ),
              ),

            );

          }
          else  return Scaffold(
            appBar: AppBar(
              title: Text('Your Transactions'),
            ),
            body: ListView.separated(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ListTile(
                    title: Text('ReceiverEmail:  '+transactions[index].ReceiverID +'   RecevierID: '+ transactions[index].ReceiverEmail,style: TextStyle(color:Colors.cyan),),
                    subtitle:Text('Amount sent:   '+ transactions[index].Amount +'            Date:  '+transactions[index].dateTime, style: TextStyle(color:Colors.green),),
                    tileColor: Colors.white,
                    selectedTileColor: Colors.lightBlue,

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
