import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mytutor/user.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mytutor/newclassscreen.dart';
import 'package:mytutor/updateclassscreen.dart';
import 'package:mytutor/class.dart';
import 'package:mytutor/tutor.dart';
import 'package:mytutor/detailscreen.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() => runApp(TutorMainScreen());

class TutorMainScreen extends StatefulWidget {
  final Tutor tutor;
  final User user;
  const TutorMainScreen({Key key, this.user, this.tutor}) : super(key: key);
  @override
  _TutorMainScreenState createState() => _TutorMainScreenState();
}

class _TutorMainScreenState extends State<TutorMainScreen> {
  GlobalKey<RefreshIndicatorState> refreshKey;
  double screenHeight, screenWidth;
  List classdata;
  String titlecenter = "Loading...";

  @override
  void initState() {
    super.initState();
    _loadClass();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: Container(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: <
            Widget>[
          classdata == null
              ? Flexible(
                  child: Container(child: Center(child: Text(titlecenter))))
              : Flexible(
                  child: RefreshIndicator(
                      key: refreshKey,
                      onRefresh: () async {
                        _loadClass();
                      },
                      child: ListView.builder(
                          itemCount: classdata.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: <Widget>[
                                InkWell(
                                    onTap: () => {
                                          _loadTutorDetail(index),
                                        },
                                    onDoubleTap: () =>
                                        _updateClassDialog(index),
                                    onLongPress: () => _deleteClass(index),
                                    child: Card(
                                      elevation: 10,
                                      child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Row(
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: () => null,
                                              child: ClipOval(
                                                //height: screenHeight / 5,
                                                //width: screenWidth / 2.5,
                                                child: CachedNetworkImage(
                                                  fit: BoxFit.cover,
                                                  imageUrl:
                                                      "https://smileylion.com/mytutor/images/${widget.tutor.picture}.jpg?",
                                                  height: screenHeight / 6,
                                                  width: screenWidth / 3.6,
                                                  placeholder: (context, url) =>
                                                      new CircularProgressIndicator(),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          new Icon(Icons.error),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Expanded(
                                                child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  widget.user.name,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                                ),
                                                Text(
                                                  classdata[index]['subject']
                                                          .toString() +
                                                      " - " +
                                                      classdata[index]['level']
                                                          .toString(),
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                                Text(
                                                  classdata[index]
                                                          ['lessonlocation']
                                                      .toString(),
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                                Text(
                                                  "RM " +
                                                      classdata[index]
                                                          ['price'] +
                                                      " Onwards",
                                                  style: TextStyle(
                                                      fontSize: 19,
                                                      color: Colors.red),
                                                ),
                                              ],
                                            )),
                                          ],
                                        ),
                                      ),
                                    ))
                              ],
                            );
                          })),
                ),
        ]),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Color.fromRGBO(14, 30, 64, 1),
        onPressed: () {
          _newClassScreen();
        },
      ),
    );
  }

  void _loadClass() async {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Loading...");
    await pr.show();
    String url = "https://smileylion.com/mytutor/php/load_class.php";
    await http.post(url, body: {
      "tutorid": widget.tutor.tutorid,
    }).then((res) {
      if (res.body == "nodata") {
        titlecenter = "No Class Found, Please Insert Your New Class";
        setState(() {
          classdata = null;
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          classdata = extractdata["class"];
        });
      }
    }).catchError((err) {
      print(err);
    });
    await pr.hide();
  }

  Future<void> _newClassScreen() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => NewClassScreen(
                  tutor: widget.tutor,
                )));
    _loadClass();
  }

  _deleteClass(int index) {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text(
          'Delete this class?',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                String url =
                    "https://smileylion.com/mytutor/php/delete_class.php";
                http.post(url, body: {
                  "classid": classdata[index]['classid'],
                }).then((res) {
                  print(res.body);

                  if (res.body == "success") {
                    _loadClass();
                  } else {
                    Toast.show("Failed", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  }
                }).catchError((err) {
                  print(err);
                });
              },
              child: Text(
                "Yes",
                style: TextStyle(color: Colors.black),
              )),
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.black),
              )),
        ],
      ),
    );
  }

  void _updateClassDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Update this class? ",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          content:
              new Text("Are you sure?", style: TextStyle(color: Colors.black)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _updateClass(index);
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _updateClass(int index) async {
    ClassTutor curclass = new ClassTutor(
      classid: classdata[index]['classid'],
      subject: classdata[index]['subject'],
      level: classdata[index]['level'],
      taughtlanguage: classdata[index]['taughtlanguage'],
      date: classdata[index]['date'],
      time: classdata[index]['time'],
      price: classdata[index]['price'],
      duration: classdata[index]['duration'],
      totalclass: classdata[index]['totalclass'],
      quantity: classdata[index]['quantity'],
      balance: classdata[index]['balance'],
      lessonlocation: classdata[index]['lessonlocation'],
      longitude: classdata[index]['longitude'],
      latitude: classdata[index]['latitude'],
      address: classdata[index]['address'],
    );
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => UpdateClassScreen(
                  classtutor: curclass,
                  tutor: widget.tutor,
                )));
    _loadClass();
  }

  _loadTutorDetail(int index) {
    ClassTutor curclass = new ClassTutor(
      classid: classdata[index]['classid'],
      subject: classdata[index]['subject'],
      level: classdata[index]['level'],
      taughtlanguage: classdata[index]['taughtlanguage'],
      date: classdata[index]['date'],
      time: classdata[index]['time'],
      price: classdata[index]['price'],
      duration: classdata[index]['duration'],
      totalclass: classdata[index]['totalclass'],
      quantity: classdata[index]['quantity'],
      balance: classdata[index]['balance'],
      lessonlocation: classdata[index]['lessonlocation'],
      longitude: classdata[index]['longitude'],
      latitude: classdata[index]['latitude'],
      address: classdata[index]['address'],
    );
    //String fav=_isFavorite.toString();
    //print(fav);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => DetailsScreen(
                  classtutor: curclass,
                  user: widget.user,
                  tutor: widget.tutor,
                )));
  }
}
