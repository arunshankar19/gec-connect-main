import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:gecconnect2/firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/routes.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      
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
                    child: 
                     Column(
                      
                      children: [
                        Container(

                           padding: EdgeInsets.only(top:0,),
                           
                          child: Image.asset('assets/ARCHH.png',width: 100,height: 100,)),
                          
                        
                        Container(
                           padding: EdgeInsets.only(bottom: 17.0,),
                          child: Text('gec connect',
                           style: GoogleFonts.raleway(
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
                          
                          controller: _email,
                          decoration: const InputDecoration(
                          
                            hintText: 'Email Address',
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
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: const InputDecoration(hintText: 'Password',
                          contentPadding: EdgeInsets.only(top:0,left: 15,right: 15,bottom: 6),
                          hintStyle: TextStyle(
                            color: Color.fromARGB(255, 134, 132, 132)
                          )
                          ),
                          controller: _password,
                        ),
                      ),
                      Container(
                        width: 300,
                        
                        padding: EdgeInsets.only(top: 10.0),
                        child: RaisedButton(
                          
                            onPressed: () async {
                              final email = _email.text;
                              final pass = _password.text;
                              try {
                                final user = await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                  email: email,
                                  password: pass,
                                );
                                if (user.user?.emailVerified ?? false) {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                    mainRoute,
                                    (route) => false,
                                  );
                                } else {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                    verifyRoute,
                                    (route) => false,
                                  );
                                }
                                // print(userCred);
      
                              } on FirebaseAuthException catch (e) {
                                switch (e.code) {
                                  case 'invalid-email':
                                    devtools.log('Invaid Email');
                                    break;
                                  case 'wrong-password':
                                     await showDialogIncorrect(context,'Wrong credentials');
                                    devtools.log('Wrong credentials');
                                    break;
                                  case 'user-not-found':
                                  await showDialogIncorrect(context, 'No user Found');
                                    devtools.log('no user found');
                                    break;
                                }
                                //(e.code);
                              }
                            },
                        
                          
                            color: Colors.white,
                            
                            shape: RoundedRectangleBorder(
                                  
                              borderRadius: BorderRadius.circular(8)),
                              
                            
                            child: Text('Login',
                            style: GoogleFonts.raleway(
                              color: Colors.black
                            )
                            ),
                            
                            ),
                           
                      ),
                      SizedBox(height: 215.0,)
                      ,
                      Container(
                         padding: EdgeInsets.only(top:0),
                        
                        child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  registerRoute, (route) => false);
                            },
                            child: Text('Create an Account',
                            style: GoogleFonts.raleway(
                            color: Colors.white)
                            )
                            ),
                      )
                    ]
                    ),
                  );
                default:
                  return const Text('Loading.....');
              }
            },
          ),
        ),
      ),
    );
  }
}

Future<void> showDialogIncorrect(
  BuildContext context,
  String text,
) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Error'),
      content: Text(text),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Ok'))
      ],
    ),
  );
}
