import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gecconnect2/constants/routes.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({Key? key}) : super(key: key);

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Mail')),
      body: Column(children: [
        const Text('Please verify Email'),
        TextButton(onPressed: () async{
        await user?.sendEmailVerification();
        }, child: const Text('Verify Mail')),
        TextButton(onPressed: (){
          Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
        }, child: const Text('Login'))
      ]),
    );
  }
}