import 'dart:async';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:mytutor/tutor.dart';
import 'package:mytutor/user.dart';
import 'package:mytutor/class.dart';
import 'package:mytutor/bookingScreen.dart';
import 'package:toast/toast.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:glassmorphism/glassmorphism.dart'; 

void main() => runApp(DetailsScreen());

class DetailsScreen extends StatefulWidget {
  final ClassTutor classtutor;
  final Tutor tutor;
  final User user;
  
  const DetailsScreen({Key key, this.classtutor,this.tutor, this.user})
      : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  double screenHeight, screenWidth;
  String titlecenter = "Loading Tutor...";
  double latitude, longitude;
  String boolAsString;
  String email;
  Future<void> _launched;
  bool _visible = false;
  Set<Marker> markers = {};
  

  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.user.name),
          backgroundColor: Color.fromRGBO(14, 30, 64, 1),
          
        ),
        body: Container(
            child: SingleChildScrollView(
                child: Column(
          children: <Widget>[
            Stack(
                  children:[
                    Container(
                 width: double.infinity,
                  height: 150.0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.blueAccent, Colors.white]),
                  ),
                ),
                    Center(
                      child: GlassmorphicContainer(
                        width: double.infinity,
                        height: 150.0,
                        blur: 20,
                        linearGradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.2),
                              Colors.white38.withOpacity(0.2)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight),
                         borderGradient: LinearGradient(colors: [
                          Colors.white24.withOpacity(0.2),
                          Colors.white70.withOpacity(0.2)
                        ]),
                        border: 2, 
                        borderRadius: 2,  
                      ),
                      
                    ),
                    Container(
                  width: double.infinity,
                  height: 150.0,
                  child: Center(
                    child: Column(
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    "https://smileylion.com/mytutor/images/${widget.user.picture}.jpg?",
                                  ),
                                  radius: 60.0,
                                ),
                              ],
                            ),
                            new Row(children: <Widget>[
                              Column(
                                //mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(widget.user.name,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  Text(widget.tutor.occupation,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                      )),
                                  Text(
                                      "Language: " +
                                          widget.classtutor.taughtlanguage,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                      )),
                                  SizedBox(height: 10),
                                  new Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(Icons.email),
                                        onPressed: () => setState(() {
                                          _launched = _openUrl(
                                              'mailto:${widget.user.email}');
                                        }),
                                      ),
                                      SizedBox(width: 30),
                                      IconButton(
                                        icon: Icon(Icons.phone),
                                        onPressed: () => launch(
                                            "tel://" + widget.user.phone),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ]),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
                  ],
                ),
            
            Card(
              elevation: 10,
              child: Container(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Row(
                        children: <Widget>[
                          //SizedBox(width: 5,),
                          Expanded(
                              child: Text(
                            'About Me',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _visible = !_visible;
                              });
                            },
                            child: Icon(
                              _visible
                                  ? Icons.keyboard_arrow_down
                                  : Icons.keyboard_arrow_up,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(width: 5),
                        ],
                      ),
                      Visibility(
                          visible: _visible,
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Column(children: <Widget>[
                              Text(widget.tutor.description,
                                  style: TextStyle(fontSize: 16),
                                  textAlign: TextAlign.justify),
                            ]),
                          )),
                      Divider(),
                      new Row(
                        children: <Widget>[
                          Text(
                            "Subject: ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 5, right: 5),
                            height: 35,
                            width: screenWidth / 3,
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(14, 30, 64, 1),
                                //border:Border.all(),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0))),
                            padding: EdgeInsets.only(
                                left: 10, right: 10, bottom: 10, top: 7),
                            child: Text(
                              widget.classtutor.subject,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 5, right: 5),
                            height: 35,
                            width: screenWidth / 3,
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(14, 30, 64, 1),
                                //border:Border.all(),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0))),
                            padding: EdgeInsets.only(
                                left: 10, right: 10, bottom: 10, top: 7),
                            child: Text(
                              widget.classtutor.level,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      new Column(
                        children: <Widget>[
                          Divider(),
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                //height: 70,
                                //width: screenWidth / 2.5,
                                child: Column(children: <Widget>[
                                  MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    minWidth: 150,
                                    onPressed: () {
                                      onPricing();
                                    },
                                    color: Color.fromRGBO(14, 30, 64, 1),
                                    padding:
                                        EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    child: Column(children: <Widget>[
                                      Text("RM",style: TextStyle(fontSize:18,color: Colors.white,fontWeight: FontWeight.bold),),
                                      //Icon(Icons.attach_money,color: Colors.white,),
                                      Text(
                                        "Pricing",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ]),
                                  )
                                ]),
                              ),
                              SizedBox(width: 10),
                              Container(
                                //height: 70,
                                //width: screenWidth / 2.5,
                                child: Column(children: <Widget>[
                                  MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    minWidth: 150,
                                    onPressed: () {
                                      onAvailability();
                                    },
                                    color: Color.fromRGBO(14, 30, 64, 1),
                                    padding:
                                        EdgeInsets.fromLTRB(20, 10, 20, 10),
                                    child: Column(children: <Widget>[
                                      Icon(
                                        Icons.calendar_today,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        "Availability",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ]),
                                  )
                                ]),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Divider(),
                      new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                              color: Colors.blueAccent,
                              height: screenHeight / 3,
                              width: screenWidth,
                              child: GoogleMap(
                                onMapCreated: _onMapCreated,
                                markers: markers,
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(
                                      double.parse(widget.classtutor.latitude),
                                      double.parse(widget.classtutor.longitude)),
                                  zoom: 15,
                                ),
                              )),
                          SizedBox(height: 10),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 20,
                              ),
                              Text(" Address", style: TextStyle(fontSize: 20)),
                            ],
                          ),
                          Text(widget.classtutor.address,
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.justify),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      
                      
                    ],
                  ),
                ),
              ),
            ),
          ],
        ))));
  }

  Future<void> _openUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  void onPricing() {
    showDialog(
        context: context,
        builder: (context) => new AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              title: Text("Pricing"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Price per class: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("RM " +widget.classtutor.price),
                  SizedBox(height:5),
                  Text("Duration Class: ",
                  style: TextStyle(fontWeight: FontWeight.bold),),
                  Text(widget.classtutor.duration +" Minutes"),
                  SizedBox(height:5),
                  Text(
                    "Total Class: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(widget.classtutor.totalclass),
                ],
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text(
                    "OK",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  void onAvailability() {
    showDialog(
        context: context,
        builder: (context) => new AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              title: Text("Availability"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Date: "+widget.classtutor.date.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  Text(
                    "Time: "+ widget.classtutor.time.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height:5),
                  Text(
                    "Lesson Location: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.classtutor.lessonlocation,
                    //style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height:5),
                  Text(
                    "Available Seat: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(widget.classtutor.balance),
                ],
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text(
                    "OK",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  void _onMapCreated(GoogleMapController controller) {
    String latitude = widget.classtutor.latitude;
    String longitude = widget.classtutor.longitude;
    var lat = double.parse(latitude);
    var long = double.parse(longitude);
    setState(() {
      markers.add(Marker(
          markerId: MarkerId("id-1"),
          position: LatLng(lat, long),
          infoWindow: InfoWindow(
            title: "I am Here",
            snippet: widget.classtutor.address,
          )));
    });
  }
  }