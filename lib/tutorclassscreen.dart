import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mytutor/user.dart';
import 'package:mytutor/tutor.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() => runApp(TutorClassScreen());

class TutorClassScreen extends StatefulWidget {
  final Tutor tutor;
  final User user;
  const TutorClassScreen({Key key, this.user, this.tutor}) : super(key: key);
  @override
  _TutorClassScreenState createState() => _TutorClassScreenState();
}

class _TutorClassScreenState extends State<TutorClassScreen> {
  double screenHeight, screenWidth;
  List classdata;
  String titlecenter = "Loading...";
  GlobalKey<RefreshIndicatorState> refreshKey;
  String status = "";
  @override
  void initState() {
    super.initState();
    _loadClass("Process");
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return new DefaultTabController(
        length: 4,
        child: Scaffold(
          resizeToAvoidBottomPadding: true,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TabBar(
                  onTap: (index) {
                    if (index == 0) {
                      _loadClass("Process");
                    }
                    if (index == 1) {
                      _loadClass("On Going");
                    }
                    if (index == 2) {
                      _loadClass("Completed");
                    }
                    if (index == 3) {
                      _loadClass("Cancel");
                    }
                  },
                  tabs: <Widget>[
                    Tab(
                      child: Text('Requests'),
                    ),
                    Tab(
                      child: Text('On Going'),
                    ),
                    Tab(
                      child: Text('Completed'),
                    ),
                    Tab(
                      child: Text('Rejected'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          body: TabBarView(children: <Widget>[
            Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    classdata == null
                        ? Flexible(
                            child: Container(
                                child: Center(child: Text(titlecenter))))
                        : Flexible(
                            child: RefreshIndicator(
                                key: refreshKey,
                                onRefresh: () async {
                                  _loadClass("Process");
                                },
                                child: ListView.builder(
                                    itemCount: classdata.length,
                                    itemBuilder: (context, index) {
                                      return Column(children: <Widget>[
                                        InkWell(
                                            onTap: () => {
                                                  _onUpdateStatus(index),
                                                },
                                            child: Card(
                                              elevation: 10,
                                              child: Padding(
                                                padding: EdgeInsets.all(5),
                                                child: Row(
                                                  children: <Widget>[
                                                    GestureDetector(
                                                      onTap: () => null,
                                                      child: ClipOval(
                                                        child:
                                                            CachedNetworkImage(
                                                          fit: BoxFit.cover,
                                                          imageUrl:
                                                              "https://smileylion.com/mytutor/images/${classdata[index]['picture']}.jpg?",
                                                          height:
                                                              screenHeight / 6,
                                                          width:
                                                              screenWidth / 3.6,
                                                          placeholder: (context,
                                                                  url) =>
                                                              new CircularProgressIndicator(),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              new Icon(
                                                                  Icons.error),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    Expanded(
                                                        child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        
                                                        Text(
                                                          classdata[index]
                                                              ['name'],
                                                          style: TextStyle(
                                                              fontSize: 18),
                                                        ),
                                                        Text(
                                                          classdata[index][
                                                                      'subject']
                                                                  .toString() +
                                                              " - " +
                                                              classdata[index]
                                                                      ['level']
                                                                  .toString(),
                                                          style: TextStyle(
                                                              fontSize: 18),
                                                        ),
                                                        Text(
                                                          classdata[index]
                                                              ['payday'],
                                                          style: TextStyle(
                                                              fontSize: 18),
                                                        ),
                                                      ],
                                                    )),
                                                    Expanded(
                                                        child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Text(
                                                          "RM " +
                                                              classdata[index][
                                                                      'paidamount']
                                                                  .toString(),
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                        Text(
                                                          classdata[index]
                                                              ['paystatus'],
                                                          style: TextStyle(
                                                              fontSize: 18),
                                                        ),
                                                        Text(
                                                    classdata[index]
                                                            ['bquantity']
                                                        .toString() + " Person",
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                      ],
                                                    )),
                                                  ],
                                                ),
                                              ),
                                            ))
                                      ]);
                                    })),
                          ),
                  ]),
            ),
            Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    classdata == null
                        ? Flexible(
                            child: Container(
                                child: Center(child: Text(titlecenter))))
                        : Flexible(
                            child: RefreshIndicator(
                                key: refreshKey,
                                onRefresh: () async {
                                  _loadClass("On Going");
                                },
                                child: ListView.builder(
                                    itemCount: classdata.length,
                                    itemBuilder: (context, index) {
                                      return Column(children: <Widget>[
                                        InkWell(
                                            onTap: () => {
                                                  null,
                                                },
                                            child: Card(
                                              elevation: 10,
                                              child: Padding(
                                                padding: EdgeInsets.all(5),
                                                child: Row(
                                                  children: <Widget>[
                                                    GestureDetector(
                                                      onTap: () => null,
                                                      child: ClipOval(
                                                        child:
                                                            CachedNetworkImage(
                                                          fit: BoxFit.cover,
                                                          imageUrl:
                                                              "https://smileylion.com/mytutor/images/${classdata[index]['picture']}.jpg?",
                                                          height:
                                                              screenHeight / 6,
                                                          width:
                                                              screenWidth / 3.6,
                                                          placeholder: (context,
                                                                  url) =>
                                                              new CircularProgressIndicator(),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              new Icon(
                                                                  Icons.error),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    Expanded(
                                                        child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        //Text(classdata[index]['bookingid'].toString()),
                                                        Text(
                                                          classdata[index]
                                                              ['name'],
                                                          style: TextStyle(
                                                              fontSize: 18),
                                                        ),
                                                        Text(
                                                          classdata[index][
                                                                      'subject']
                                                                  .toString() +
                                                              " - " +
                                                              classdata[index]
                                                                      ['level']
                                                                  .toString(),
                                                          style: TextStyle(
                                                              fontSize: 18),
                                                        ),
                                                        Text(
                                                          classdata[index]
                                                              ['payday'],
                                                          style: TextStyle(
                                                              fontSize: 18),
                                                        ),
                                                      ],
                                                    )),
                                                    Expanded(
                                                        child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Text(
                                                          "RM " +
                                                              classdata[index][
                                                                      'paidamount']
                                                                  .toString(),
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                        Text(
                                                          classdata[index]
                                                              ['paystatus'],
                                                          style: TextStyle(
                                                              fontSize: 18),
                                                        ),
                                                        Text(
                                                    classdata[index]
                                                            ['bquantity']
                                                        .toString() + " Person",
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                      ],
                                                    )),
                                                  ],
                                                ),
                                              ),
                                            ))
                                      ]);
                                    })),
                          ),
                  ]),
            ),
            Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    classdata == null
                        ? Flexible(
                            child: Container(
                                child: Center(child: Text(titlecenter))))
                        : Flexible(
                            child: RefreshIndicator(
                                key: refreshKey,
                                onRefresh: () async {
                                  _loadClass("Completed");
                                },
                                child: ListView.builder(
                                    itemCount: classdata.length,
                                    itemBuilder: (context, index) {
                                      return Column(children: <Widget>[
                                        InkWell(
                                            onTap: () => {
                                                  null,
                                                },
                                            child: Card(
                                              elevation: 10,
                                              child: Padding(
                                                padding: EdgeInsets.all(5),
                                                child: Row(
                                                  children: <Widget>[
                                                    GestureDetector(
                                                      onTap: () => null,
                                                      child: ClipOval(
                                                        child:
                                                            CachedNetworkImage(
                                                          fit: BoxFit.cover,
                                                          imageUrl:
                                                              "https://smileylion.com/mytutor/images/${classdata[index]['picture']}.jpg?",
                                                          height:
                                                              screenHeight / 6,
                                                          width:
                                                              screenWidth / 3.6,
                                                          placeholder: (context,
                                                                  url) =>
                                                              new CircularProgressIndicator(),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              new Icon(
                                                                  Icons.error),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    Expanded(
                                                        child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        //Text(classdata[index]['bookingid'].toString()),
                                                        Text(
                                                          classdata[index]
                                                              ['name'],
                                                          style: TextStyle(
                                                              fontSize: 18),
                                                        ),
                                                        Text(
                                                          classdata[index][
                                                                      'subject']
                                                                  .toString() +
                                                              " - " +
                                                              classdata[index]
                                                                      ['level']
                                                                  .toString(),
                                                          style: TextStyle(
                                                              fontSize: 18),
                                                        ),
                                                        Text(
                                                          classdata[index]
                                                              ['payday'],
                                                          style: TextStyle(
                                                              fontSize: 18),
                                                        ),
                                                      ],
                                                    )),
                                                    Expanded(
                                                        child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Text(
                                                          "RM " +
                                                              classdata[index][
                                                                      'paidamount']
                                                                  .toString(),
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                        Text(
                                                          classdata[index]
                                                              ['paystatus'],
                                                          style: TextStyle(
                                                              fontSize: 18),
                                                        ),
                                                        Text(
                                                    classdata[index]
                                                            ['bquantity']
                                                        .toString() + " Person",
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                      ],
                                                    )),
                                                  ],
                                                ),
                                              ),
                                            ))
                                      ]);
                                    })),
                          ),
                  ]),
            ),
           Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    classdata == null
                        ? Flexible(
                            child: Container(
                                child: Center(child: Text(titlecenter))))
                        : Flexible(
                            child: RefreshIndicator(
                                key: refreshKey,
                                onRefresh: () async {
                                  _loadClass("Cancel");
                                },
                                child: ListView.builder(
                                    itemCount: classdata.length,
                                    itemBuilder: (context, index) {
                                      return Column(children: <Widget>[
                                        InkWell(
                                            onTap: () => {
                                                  null,
                                                },
                                            child: Card(
                                              elevation: 10,
                                              child: Padding(
                                                padding: EdgeInsets.all(5),
                                                child: Row(
                                                  children: <Widget>[
                                                    GestureDetector(
                                                      onTap: () => null,
                                                      child: ClipOval(
                                                        child:
                                                            CachedNetworkImage(
                                                          fit: BoxFit.cover,
                                                          imageUrl:
                                                              "https://smileylion.com/mytutor/images/${classdata[index]['picture']}.jpg?",
                                                          height:
                                                              screenHeight / 6,
                                                          width:
                                                              screenWidth / 3.6,
                                                          placeholder: (context,
                                                                  url) =>
                                                              new CircularProgressIndicator(),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              new Icon(
                                                                  Icons.error),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    Expanded(
                                                        child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        //Text(classdata[index]['bookingid'].toString()),
                                                        Text(
                                                          classdata[index]
                                                              ['name'],
                                                          style: TextStyle(
                                                              fontSize: 18),
                                                        ),
                                                        Text(
                                                          classdata[index][
                                                                      'subject']
                                                                  .toString() +
                                                              " - " +
                                                              classdata[index]
                                                                      ['level']
                                                                  .toString(),
                                                          style: TextStyle(
                                                              fontSize: 18),
                                                        ),
                                                        Text(
                                                          classdata[index]
                                                              ['payday'],
                                                          style: TextStyle(
                                                              fontSize: 18),
                                                        ),
                                                      ],
                                                    )),
                                                    Expanded(
                                                        child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Text(
                                                          "RM " +
                                                              classdata[index][
                                                                      'paidamount']
                                                                  .toString(),
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                        Text(
                                                          classdata[index]
                                                              ['paystatus'],
                                                          style: TextStyle(
                                                              fontSize: 18),
                                                        ),
                                                        Text(
                                                    classdata[index]
                                                            ['bquantity']
                                                        .toString() + " Person",
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                      ],
                                                    )),
                                                  ],
                                                ),
                                              ),
                                            ))
                                      ]);
                                    })),
                          ),
                  ]),
            ),
          ]),
        ));
  }

  void _loadClass(String status) async {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Loading...");
    await pr.show();
    String url = "https://smileylion.com/mytutor/php/load_class_status.php";
    await http.post(url, body: {
      "tutorid": widget.tutor.tutorid,
      "classstatus": status,
    }).then((res) {
      if (res.body == "nodata") {
        titlecenter = "No Class Found.";
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

  _onUpdateStatus(int index) {
    showDialog(
        context: context,
        builder: (context) => new AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              title: new Text(
                "Accept " + classdata[index]['name'],
                style: TextStyle(fontSize: 20),
              ),
              actions: <Widget>[
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                    http.post(
                        "https://smileylion.com/mytutor/php/update_class_status.php",
                        body: {
                          "classstatus": "On Going",
                          "bookingid": classdata[index]['bookingid'],
                        }).then((res) {
                      if (res.body == "success") {
                        setState(() {
                          _loadClass("Process");
                        });
                        
                      } else {
                        Toast.show("Failed", context,
                            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                      }
                    }).catchError((err) {
                      print(err);
                    });
                  },
                  child: Text("Accept"),
                ),
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                    http.post(
                        "https://smileylion.com/mytutor/php/update_class_status.php",
                        body: {
                          "classstatus": "Cancel",
                          "bookingid": classdata[index]['bookingid'],
                        }).then((res) {
                      if (res.body == "success") {
                        _loadClass("Process");
                      } else {
                        Toast.show("Failed", context,
                            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                      }
                    }).catchError((err) {
                      print(err);
                    });
                  },
                  child: Text("Reject"),
                ),
                MaterialButton(onPressed: (){
                  Navigator.of(context).pop(false);
                },child: Text("Close"),)
              ],
            ));
  }
}
