import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gecconnect2/constants/routes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../firebase_options.dart';

class VerifyEmail2 extends StatefulWidget {
  const VerifyEmail2({Key? key}) : super(key: key);

  @override
  State<VerifyEmail2> createState() => _VerifyEmail2State();
}

class _VerifyEmail2State extends State<VerifyEmail2> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:  Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform,
            ),
      builder:(context, snapshot) =>  Scaffold(
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
            child: Container(
              
              padding: EdgeInsets.only(top: 260.0,right: 30.0,left: 30.0,bottom: 10),
              child: Column(children: [
                 Text('Please verify your Email',
                 style: GoogleFonts.openSans(
                  fontWeight: FontWeight.w500,
                             color: Colors.white,
                             fontSize: 18.0,
                 ),),
                Container(
                  
                  padding: EdgeInsets.only(top: 15,right: 30.0,left: 30.0),
                  child: RaisedButton(onPressed: () async{
                   final user = FirebaseAuth.instance.currentUser;
                  await user?.sendEmailVerification();
                  },
                    highlightColor: Color.fromARGB(255, 137, 10, 1),
                    child:  Text('Verify Mail',
                    )),
                ),
                Container(
                  width:160,
                  padding: EdgeInsets.only(top: 10,right: 30.0,left: 30.0),
                  child: RaisedButton(onPressed: (){
                    Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
                  }, child:  Text('Login'),
                   highlightColor: Color.fromARGB(255, 137, 10, 1),
                    
                            ),
                ),
                
                GestureDetector(
                  onTap: _launchURL,
                  child: Container(
                    padding: EdgeInsets.only(top:30),
                   
                
                    child: Image.asset('assets/ARCHH.png',width: 100,height: 100,)),
                )
                
                 
              ]
              
            ),
          ),
         
        ),
      ),
      )
    );
  }
}
  _launchURL() async {
    const url = 'https://gectcr.ac.in';
      await launch(url);
   
  }