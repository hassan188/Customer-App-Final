/*import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
     body: SafeArea(
       child: Center(
         child: Container(
           color: Colors.black54,
           width: 350.0,
           height: 200.0,
           margin: EdgeInsets.all(50.0),
           child: Text('20/2/2020',
             style: TextStyle(
               fontWeight: FontWeight.bold,
               color: Colors.black,
             ),
           ),
         ),
       ),
    ),

    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/edit_profile/components/body.dart';
class EditProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
}