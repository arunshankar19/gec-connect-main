import 'package:flutter/material.dart';
import 'package:gecconnect2/views/login_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:animated_text_kit/animated_text_kit.dart';


class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  void initState(){
    super.initState();
    _navigatetohome();
  }

_navigatetohome()async{
  await Future.delayed(Duration(milliseconds:5000),() {});
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));

}

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            
            decoration: BoxDecoration(gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color.fromARGB(255, 112, 9, 1),
                Color.fromARGB(255, 29, 0, 1),
                
              ],
            )),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Container(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Image.asset('assets/ARCHH.png',width: 100,height: 100,)),
                     
                      
                      
                       Text('gec connect',
                       
                         style: GoogleFonts.openSans(
                         fontWeight: FontWeight.w500,
                         color: Colors.white,
                         fontSize: 24.0,
                        ),
                       
                         
                        )
                        ],
                  ),
                  )
                ),
              ),
               Expanded(flex: 1,
               child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SpinKitRotatingCircle(color: Colors.white, size: 20.0, ),
                  Padding(padding: EdgeInsets.only(top: 20.0),
                  ),
                  Text('connecting gec',
                    style: GoogleFonts.raleway(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500)),
               ],
              ),
            ) 
          ],
         )
       ],
      ),
    );   
  }
}
  
