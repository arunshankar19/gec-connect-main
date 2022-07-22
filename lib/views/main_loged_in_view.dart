import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
import 'package:gecconnect2/constants/routes.dart';
import 'package:location/location.dart';



enum MenuAction { logout }

class SigninView extends StatefulWidget {
  const SigninView({Key? key}) : super(key: key);

  @override
  State<SigninView> createState() => _SigninViewState();
}

class _SigninViewState extends State<SigninView> {
  late final TextEditingController loca;

  @override
  void initState() {
    loca = TextEditingController();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    loca.dispose();
    // TODO: implement dispose
    super.dispose();
  }
 
   @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Gec Connect'),
          actions: [
            PopupMenuButton<MenuAction>(
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.logout:
                    final logoutVal = await showDialogeLogout(context);
                    // devtools.log(logoutVal.toString());
                    if (logoutVal) {
                      await FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          loginRoute, (route) => false);
                    }
                    break;
                }
              },
              itemBuilder: (context) {
                return [
                  const PopupMenuItem<MenuAction>(
                      value: MenuAction.logout, child: Text('Log Out')),
                ];
              },
            )
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Get location Data'),
              TextField(controller: loca,),
              ElevatedButton(
                onPressed: () async {
                  final loc = await getData();
                  loca.text= loc.toString();

                  devtools.log(loc.toString());                  
                },
                child: const Text('Click to get location data'),
              )
            ],
          ),
        ));
  }
}

Future<bool> showDialogeLogout(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Logout'),
      content: const Text('Are you sure you want to logout'),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel')),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Logout'))
      ],
    ),
  ).then((value) => value ?? false);
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