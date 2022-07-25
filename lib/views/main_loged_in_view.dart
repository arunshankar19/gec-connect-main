import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
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
        body: Stack(
        children: [
          FutureBuilder<LocationData?>(
              future: getData(),
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
                    MarkerLayerOptions(markers: [
                      Marker(
                        width: 50.0,
                        height: 50.0,
                        point: latlong.LatLng(snapshot.data?.latitude ?? 0.0,
                            snapshot.data?.longitude ?? 0.0),
                        builder: (context) => Column(
                          children: [
                            Icon(Icons.location_pin),
                            const Text('Arun'),
                          ],
                        ),
                      ),
                    ] //data, //getMarkerList(locationData),
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


