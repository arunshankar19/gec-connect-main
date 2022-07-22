import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gecconnect2/constants/routes.dart';
import 'package:gecconnect2/views/email_verify.dart';
import 'package:gecconnect2/views/login_view.dart';
import 'package:gecconnect2/views/main_loged_in_view.dart';
import 'package:gecconnect2/views/register_view.dart';
import 'firebase_options.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        loginRoute:(context) => const Login(),
        registerRoute:(context) => const Register(),
        verifyRoute:(context) => const VerifyEmail(),
        mainRoute:(context) => const SigninView(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
          future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          
          case ConnectionState.done:
          final user = FirebaseAuth.instance.currentUser;
          if(user != null) {
          if (user.emailVerified) {
            return const SigninView();
          }
          else {
            // Navigator.of(context).pushNamedAndRemoveUntil('/veify/', (route) => false); 
            return const VerifyEmail();           
          }
          }
           else {
            return const Login();
          }
          default:
          // Navigator.of(context).pushNamedAndRemoveUntil('/login/', (route) => false);
          return const Center(child: CircularProgressIndicator.adaptive(),);
          // return const Text('Loading....');
        }
      },);
  }
}
