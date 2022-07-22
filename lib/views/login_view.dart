import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:gecconnect2/firebase_options.dart';

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
      appBar: AppBar(title: const Text('Login')),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(children: [
                TextField(
                  controller: _email,
                  decoration: const InputDecoration(
                    hintText: 'Enter your Email',
                  ),
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(hintText: 'Password'),
                  controller: _password,
                ),
                TextButton(
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
                    child: const Text('Login')),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          registerRoute, (route) => false);
                    },
                    child: const Text('Do not have a account? Create one!'))
              ]);
            default:
              return const Text('Loading.....');
          }
        },
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
