import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'tabscreen.dart';
import 'user.dart';
import 'loginscreen.dart';
import 'package:mytutor/dot_type.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double screenHeight;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color:Color.fromRGBO(14, 30, 64, 1),
        ),
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        textTheme: GoogleFonts.anaheimTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      title: 'MyTutor',
      home: Scaffold(
        body: Container(
          child: Stack(
            children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/splashscreen1.png'),
                          fit: BoxFit.cover))),
              
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height:300),
                    ProgressIndicator()

                  ],

              )
            ],
          ),
        ),
      ),
    );
  }
}

class ProgressIndicator extends StatefulWidget {
  final Color dotOneColor;
  final Color dotTwoColor;
  final Color dotThreeColor;
  final Duration duration;
  final DotType dotType;
  final Icon dotIcon;

  ProgressIndicator(
      {this.dotOneColor = Colors.redAccent,
      this.dotTwoColor = Colors.green,
      this.dotThreeColor = Colors.blueAccent,
      this.duration = const Duration(milliseconds: 1000),
      this.dotType = DotType.circle,
      this.dotIcon = const Icon(Icons.blur_on)});

  @override
  _ProgressIndicatorState createState() => new _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<ProgressIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation_1;
  Animation<double> animation_2;
  Animation<double> animation_3;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation_1 = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: controller,
      curve: Interval(0.0, 0.80, curve: Curves.ease),
    ));
    animation_2 = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: controller,
      curve: Interval(0.1, 0.90, curve: Curves.ease),
    ));
    animation_3 = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: controller,
      curve: Interval(0.2, 1.0, curve: Curves.ease),
    ));
    controller.addListener(() {
      setState(() {
        if(animation_3.value>0.99){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>LoginScreen()));
        }
      });
    });
    controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
        child: new Container(
            child: new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Transform.translate(
          offset: Offset(
              0.0,
              -30 *
                  (animation_1.value <= 0.5
                      ? animation_1.value
                      : 1.0 - animation_1.value)),
          child: new Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Dot(
              radius: 10.0,
              color: widget.dotOneColor,
              type: widget.dotType,
              icon: widget.dotIcon,
            ),
          ),
        ),
        Transform.translate(
          offset: Offset(
              0.0,
              -30 *
                  (animation_2.value <= 0.5
                      ? animation_2.value
                      : 1.0 - animation_2.value)),
          child: new Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Dot(
              radius: 10.0,
              color: widget.dotTwoColor,
              type: widget.dotType,
              icon: widget.dotIcon,
            ),
          ),
        ),
        Transform.translate(
          offset: Offset(
              0.0,
              -30 *
                  (animation_3.value <= 0.5
                      ? animation_3.value
                      : 1.0 - animation_3.value)),
          child: new Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Dot(
              radius: 10.0,
              color: widget.dotThreeColor,
              type: widget.dotType,
              icon: widget.dotIcon,
            ),
          ),
        ),
      ],
    )));
  }

  @override
  void dispose() {
    controller.stop();
    super.dispose();
  }

  

  
}

class Dot extends StatelessWidget {
  final double radius;
  final Color color;
  final DotType type;
  final Icon icon;

  Dot({this.radius, this.color, this.type, this.icon});

  @override
  Widget build(BuildContext context) {
    return new Center(
        child: type == DotType.icon
            ? Icon(icon.icon, color: color, size: 1.3 * radius)
            : new Transform.rotate(
                angle: type == DotType.diamond ? pi / 4 : 0.0,
                child: Container(
                  width: radius,
                  height: radius,
                  decoration: BoxDecoration(
                      color: color,
                      shape: type == DotType.circle
                          ? BoxShape.circle
                          : BoxShape.rectangle),
                )));
  }
}
