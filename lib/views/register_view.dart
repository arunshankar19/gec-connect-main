import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gecconnect2/constants/routes.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:developer' as devtools show log;

import '../constants/mongodb.dart';
import '../firebase_options.dart';
import '../user.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late final TextEditingController _name;
  late final TextEditingController _email1;
  late final TextEditingController _password1;

  @override
  void initState() {
    _email1 = TextEditingController();
    _password1 = TextEditingController();
    _name = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email1.dispose();
    _password1.dispose();
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          width: double.infinity,

           decoration: BoxDecoration(gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color.fromARGB(255, 112, 9, 1),
                  Color.fromARGB(255, 29, 0, 1),
                  
                ],
          )
          ),


          child: FutureBuilder(
            future: Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform,
            ),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  return Container(
                    padding: EdgeInsets.only(top: 200.0,right: 30.0,left: 30.0),
                    

                    
                    child: Column(children: [
                      GestureDetector(
                        onTap: _launchURL,
                        child: Container(
                      
                             padding: EdgeInsets.only(top:0,),
                             
                            child: Image.asset('assets/ARCHH.png',width: 100,height: 100,)),
                      ),
                          
                        
                        Container(
                           padding: EdgeInsets.only(bottom: 17.0,),
                          child: Text('Sign Up',
                           style: GoogleFonts.openSans(
                           fontWeight: FontWeight.w500,
                           color: Colors.white,
                           fontSize: 24.0,
                          ),),
                        ),

                        Container(
                          
                          width: 300,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8.0)
                        ), 
                          child: TextField(
                             style: TextStyle(color: Colors.white,),
                             controller: _name,
                            decoration: InputDecoration(
                              hintText: 'Name',
                               contentPadding: EdgeInsets.only(top:0,left: 15,right: 15,bottom: 6),
                               hintStyle: TextStyle(
                                fontFamily: 'GoogleFonts.raleway()',
                                color: Color.fromARGB(255, 134, 132, 132)
                              )
                             ),
                          ),
                        ),
                        SizedBox(height:10,),
                      Container(
                         width: 300,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8.0)
                        ), 
                        child: TextField(
                           style: TextStyle(color: Colors.white,),
                          controller: _email1,
                          decoration: const InputDecoration(
                            
                            hintText: 'Email',
                            contentPadding: EdgeInsets.only(top:0,left: 15,right: 15,bottom: 6),
                            hintStyle: TextStyle(
                              fontFamily: 'GoogleFonts.raleway()',
                              color: Color.fromARGB(255, 134, 132, 132)
                            )
                          ),
                          enableSuggestions: false,
                          autocorrect: false,
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                       SizedBox(height: 10,),
                      Container(
                         width: 300,
                        height: 40,
                        
                        
                         decoration: BoxDecoration(
                          boxShadow:[ BoxShadow(blurRadius: 1.0),],
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8.0)
                        ), 
                        child: TextField(
                           style: TextStyle(color: Colors.white,),
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: const InputDecoration(hintText: 'Password', contentPadding: EdgeInsets.only(top:0,left: 15,right: 15,bottom: 6),
                          hintStyle: TextStyle(
                            color: Color.fromARGB(255, 134, 132, 132)
                          )),
                          controller: _password1,
                        ),
                      ),


                      Container(
                        width: 300,
                        padding: EdgeInsets.only(top:10.0),
                        child: RaisedButton(
                           color: Colors.white,
                            
                            shape: RoundedRectangleBorder(
                                  
                              borderRadius: BorderRadius.circular(8)),


                            onPressed: ()  async{
                              
                              
                              final email = _email1.text;
                              final pass = _password1.text;
                              final name = _name.text;
                              try {
                                await FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                  email: email,
                                  password: pass,
                                );

                                
                              
                              } on FirebaseAuthException catch (e) {
                                switch (e.code) {
                                  case 'invalid-email':
                                    devtools.log('invalid Email');
                                    break;
                                  case 'wrong-password':
                                    devtools.log('Wrong Password');
                                    break;
                                  case 'user-not-found':
                                    devtools.log('Invalid user');
                                }
                                
                              }
                              final l = await getData();
                              var db = FirebaseFirestore.instance;
                              final userData = <String,dynamic> {
                                'name':name,
                                'email':email,
                                'key':1,
                                'latitude': l?.latitude,
                                'longitude':l?.longitude

                              };
                              db.collection('users').doc(email).set(userData);
                                Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);

                              // print(userCred);
                            },
                            highlightColor: Color.fromARGB(255, 137, 10, 1),
                            child: const Text('Sign Up')),
                      ),

                      SizedBox(height: 160.0,),
                      Container(
                        child: TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                            },
                            child: Text('Already have an account? Login Here !',
                            style: GoogleFonts.openSans(color: Colors.white))
                            ),
                      )
                    ]),
                  );
                default:
                  return const Center(child: CircularProgressIndicator.adaptive());
              }
            },
          ),
        ),
      ),
    );
  }
}
_launchURL() async {
    const url = 'https://gectcr.ac.in';
      await launch(url);
   
  }
  Future<LocationData?> getData() async {
  Location location = Location();

bool _serviceEnabled;
PermissionStatus _permissionGranted;
LocationData _locationData;

_serviceEnabled = await location.serviceEnabled();
if (!_serviceEnabled) {
  _serviceEnabled = await location.requestService();
  if (!_serviceEnabled) {
    return null;
  }
}

_permissionGranted = await location.hasPermission();
if (_permissionGranted == PermissionStatus.denied) {
  _permissionGranted = await location.requestPermission();
  if (_permissionGranted != PermissionStatus.granted) {
    return null;
  }
}

_locationData = await location.getLocation();
return _locationData;
}