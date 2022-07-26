import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart' as latlong;
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
      resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 112, 9, 1),
          title: const Text('GEC CONNECT',),
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
                      value: MenuAction.logout, child: Text('Sign Out')),
                ];
              },
            )
          ],
        ),
        body: Stack(
        children: [
          FutureBuilder<List<Marker>> (
              future: markerData(),
              builder: (context, snapshot) {
                return FlutterMap(
                  options: MapOptions(
                    center: //latlong.LatLng(
                        // snapshot.data?.latitude ?? 0.0, snapshot.data?.longitude ?? 0.0),
                        latlong.LatLng(10.5559684, 76.2180367),
                    minZoom: 10.0,
                    maxZoom: 18.4999,
                    zoom: 17.0,
                  ),
                  layers: [
                    TileLayerOptions(
                      urlTemplate:
                          "https://api.mapbox.com/styles/v1/nikhil1711/cl5xqoq0y001l14mt91t21l4v/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibmlraGlsMTcxMSIsImEiOiJjbDV4cHh2NGgwNWxiM2xwZDFtbTJ2YTF4In0.obwlY04ou2jKF4V4MkLQxQ",
                      additionalOptions: {
                        'accessToken':
                            'pk.eyJ1IjoibmlraGlsMTcxMSIsImEiOiJjbDV4cHh2NGgwNWxiM2xwZDFtbTJ2YTF4In0.obwlY04ou2jKF4V4MkLQxQ',
                        'id': 'mapbox.streets',
                      },
                    ),
                    MarkerLayerOptions(markers: snapshot.data ??  [ Marker(point: latlong.LatLng(10.5559684, 76.2180367),
    width: 30,
    height: 30,
     builder: (context) =>Icon(Icons.location_pin)
    )]//data, //getMarkerList(locationData),
                        ),
                  ],
                );
              }),
        ],
      ),
    );
  }
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





Future<bool> showDialogeLogout(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title:  Text('SIGN OUT',
      style: GoogleFonts.openSans(
      fontWeight: FontWeight.bold
      ),),
      content: const Text('Are you sure you want to Sign Out?'),
      actions: [
        RaisedButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
              highlightColor: Color.fromARGB(255, 137, 10, 1),
            child: const Text('Cancel')),
        RaisedButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
              highlightColor: Color.fromARGB(255, 137, 10, 1),
            child: const Text('Sign Out'))
      ],
    ),
  ).then((value) => value ?? false);
}

Future<List<Map<String,dynamic>>> getAllData() async{
    var db = FirebaseFirestore.instance;
  final locref = await db.collection('users').where('key',isEqualTo: 1).get();
  final abc = locref.docs.map((doc)=>doc.data()).toList();
  final abd = locref.docs.map((doc)=>doc.get('name')).toList();
  print(abc);
  return abc;
}

Future<List<Marker>> markerData () async {
  final data = await getAllData();
  devtools.log(data.toString());
  List<Marker> m = [];
  for (var i in data) {
    print (i);
    devtools.log(i.toString());
    final k = Marker(point: latlong.LatLng(i['latitude'],i['longitude']),
    width: 10,
    height: 10,
     builder: (context) =>Container(
      
       child: Column(
                            children: [
                              Icon(Icons.location_pin),
                               Text(i['name'],
                               style: GoogleFonts.openSans(
                                fontSize: 10

                               ),),
                            ],
                          ),
     ),
    );
    devtools.log(k.toString());
    m.add(k);
  }
  devtools.log(m.toString());
  return m;
}