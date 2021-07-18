import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mytutor/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';

void main() => runApp(PaymentHistoryScreen());

class PaymentHistoryScreen extends StatefulWidget {
  final User user;
  const PaymentHistoryScreen({Key key, this.user}) : super(key: key);
  @override
  _PaymentHistoryScreenState createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  List paymentdata;
  double screenHeight, screenWidth;
  String title = "Loading payment history...";
  String status = "Process";

  void initState() {
    super.initState();
    _loadPaymentHistory(status);
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
            title: Text("My Class History"),
            bottom: TabBar(
              isScrollable: true,
              onTap: (index) {
                if (index == 0) {
                  _loadPaymentHistory("Process");
                }
                if (index == 1) {
                  _loadPaymentHistory("On Going");
                }
                if (index == 2) {
                  _loadPaymentHistory("Completed");
                }
                if (index == 3) {
                  _loadPaymentHistory("Cancel");
                }
              },
              tabs: <Widget>[
                Tab(
                  child: Text('To Approve'),
                ),
                Tab(
                  child: Text('On Going'),
                ),
                Tab(
                  child: Text('Completed'),
                ),
                Tab(
                  child: Text('Return Refund'),
                ),
              ],
            ),
          ),
          body: TabBarView(children: <Widget>[
            Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                  paymentdata == null
                      ? Flexible(
                          child: Container(child: Center(child: Text(title))))
                      : Flexible(
                          child: ListView.builder(
                              itemCount: paymentdata.length,
                              itemBuilder: (context, index) {
                                return Column(children: <Widget>[
                                  InkWell(
                                      onTap: () => {
                                            //_loadTutorDetail(index),
                                          },
                                      child: Card(
                                        elevation: 10,
                                        child: Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Row(
                                            children: <Widget>[
                                              GestureDetector(
                                                  onTap: () =>null,//_onImageDisplay(index),
                                                  child: ClipOval(
                                                    //height: screenHeight / 5,
                                                    //width: screenWidth / 2.5,
                                                    child: CachedNetworkImage(
                                                      fit: BoxFit.cover,
                                                      imageUrl:
                                                          "https://smileylion.com/mytutor/images/${paymentdata[index]['picture']}.jpg?",
                                                      height: screenHeight / 6,
                                                      width: screenWidth / 3.6,
                                                      placeholder: (context,
                                                              url) =>
                                                          new CircularProgressIndicator(),
                                                      errorWidget: (context,
                                                              url, error) =>
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
                                                Text(paymentdata[index]['name'].toString(),
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  ),
                                                  Text(paymentdata[index]['subject'].toString() +" - "+paymentdata[index]['level'],
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                  Text(paymentdata[index]['payday'],
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                  
                                                  
                                                ],
                                              )),
                                              Expanded(
                                                  child: Column(
                                                crossAxisAlignment:CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    "RM " +
                                                        paymentdata[index]
                                                            ['paidamount'],
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                              FontWeight.bold,
                                                        color: Colors.red),
                                                  ),
                                                  Text(
                                                    paymentdata[index]
                                                            ['paystatus']
                                                        .toString(),
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                  Text(
                                                    paymentdata[index]
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
                              }))
                ])),
                Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                  paymentdata == null
                      ? Flexible(
                          child: Container(child: Center(child: Text(title))))
                      : Flexible(
                          child: ListView.builder(
                              itemCount: paymentdata.length,
                              itemBuilder: (context, index) {
                                return Column(children: <Widget>[
                                  InkWell(
                                      onTap: () => {
                                            //_loadTutorDetail(index),
                                          },
                                      child: Card(
                                        elevation: 10,
                                        child: Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Row(
                                            children: <Widget>[
                                              GestureDetector(
                                                  onTap: () =>null,//_onImageDisplay(index),
                                                  child: ClipOval(
                                                    //height: screenHeight / 5,
                                                    //width: screenWidth / 2.5,
                                                    child: CachedNetworkImage(
                                                      fit: BoxFit.cover,
                                                      imageUrl:
                                                          "https://smileylion.com/mytutor/images/${paymentdata[index]['picture']}.jpg?",
                                                      height: screenHeight / 6,
                                                      width: screenWidth / 3.6,
                                                      placeholder: (context,
                                                              url) =>
                                                          new CircularProgressIndicator(),
                                                      errorWidget: (context,
                                                              url, error) =>
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
                                                Text(paymentdata[index]['name'].toString(),
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  ),
                                                  Text(paymentdata[index]['subject'].toString() +" - "+paymentdata[index]['level'],
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                  Text(paymentdata[index]['payday'],
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                  
                                                  
                                                ],
                                              )),
                                              Expanded(
                                                  child: Column(
                                                crossAxisAlignment:CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    "RM " +
                                                        paymentdata[index]
                                                            ['paidamount'],
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                              FontWeight.bold,
                                                        color: Colors.red),
                                                  ),
                                                  Text(
                                                    paymentdata[index]
                                                            ['paystatus']
                                                        .toString(),
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                  Text(
                                                    paymentdata[index]
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
                              }))
                ])),
                Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                  paymentdata == null
                      ? Flexible(
                          child: Container(child: Center(child: Text(title))))
                      : Flexible(
                          child: ListView.builder(
                              itemCount: paymentdata.length,
                              itemBuilder: (context, index) {
                                return Column(children: <Widget>[
                                  InkWell(
                                      onTap: () => {
                                            //_loadTutorDetail(index),
                                          },
                                      child: Card(
                                        elevation: 10,
                                        child: Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Row(
                                            children: <Widget>[
                                              GestureDetector(
                                                  onTap: () =>null,//_onImageDisplay(index),
                                                  child: ClipOval(
                                                    //height: screenHeight / 5,
                                                    //width: screenWidth / 2.5,
                                                    child: CachedNetworkImage(
                                                      fit: BoxFit.cover,
                                                      imageUrl:
                                                          "https://smileylion.com/mytutor/images/${paymentdata[index]['picture']}.jpg?",
                                                      height: screenHeight / 6,
                                                      width: screenWidth / 3.6,
                                                      placeholder: (context,
                                                              url) =>
                                                          new CircularProgressIndicator(),
                                                      errorWidget: (context,
                                                              url, error) =>
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
                                                Text(paymentdata[index]['name'].toString(),
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  ),
                                                  Text(paymentdata[index]['subject'].toString() +" - "+paymentdata[index]['level'],
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                  Text(paymentdata[index]['payday'],
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                  
                                                  
                                                ],
                                              )),
                                              Expanded(
                                                  child: Column(
                                                crossAxisAlignment:CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    "RM " +
                                                        paymentdata[index]
                                                            ['paidamount'],
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                              FontWeight.bold,
                                                        color: Colors.red),
                                                  ),
                                                  Text(
                                                    paymentdata[index]
                                                            ['paystatus']
                                                        .toString(),
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                  Text(
                                                    paymentdata[index]
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
                              }))
                ])),
                Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                  paymentdata == null
                      ? Flexible(
                          child: Container(child: Center(child: Text(title))))
                      : Flexible(
                          child: ListView.builder(
                              itemCount: paymentdata.length,
                              itemBuilder: (context, index) {
                                return Column(children: <Widget>[
                                  InkWell(
                                      onTap: () => {
                                            //_loadTutorDetail(index),
                                          },
                                      child: Card(
                                        elevation: 10,
                                        child: Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Row(
                                            children: <Widget>[
                                              GestureDetector(
                                                  onTap: () =>null,//_onImageDisplay(index),
                                                  child: ClipOval(
                                                    //height: screenHeight / 5,
                                                    //width: screenWidth / 2.5,
                                                    child: CachedNetworkImage(
                                                      fit: BoxFit.cover,
                                                      imageUrl:
                                                          "https://smileylion.com/mytutor/images/${paymentdata[index]['picture']}.jpg?",
                                                      height: screenHeight / 6,
                                                      width: screenWidth / 3.6,
                                                      placeholder: (context,
                                                              url) =>
                                                          new CircularProgressIndicator(),
                                                      errorWidget: (context,
                                                              url, error) =>
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
                                                Text(paymentdata[index]['name'].toString(),
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  ),
                                                  Text(paymentdata[index]['subject'].toString() +" - "+paymentdata[index]['level'],
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                  Text(paymentdata[index]['payday'],
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                  
                                                  
                                                ],
                                              )),
                                              Expanded(
                                                  child: Column(
                                                crossAxisAlignment:CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    "RM " +
                                                        paymentdata[index]
                                                            ['paidamount'],
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                              FontWeight.bold,
                                                        color: Colors.red),
                                                  ),
                                                  Text(
                                                    paymentdata[index]
                                                            ['paystatus']
                                                        .toString(),
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                  Text(
                                                    paymentdata[index]
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
                              }))
                ])),
            
          ]),
        ));
  }

  void _loadPaymentHistory(String status) async {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Loading...");
    await pr.show();
    String url = "https://smileylion.com/mytutor/php/load_payment_history.php";
    await http.post(url, body: {
      "userid": widget.user.userid,
      "classstatus": status,
    }).then((res) {
      if (res.body == "nodata") {
        title = "No Favorite Tutor Found";
        setState(() {
          paymentdata = null;
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          paymentdata = extractdata["payment"];
        });
      }
    }).catchError((err) {
      print(err);
    });
    await pr.hide();
  }
}
