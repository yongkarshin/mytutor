import 'package:flutter/material.dart';
import 'package:mytutor/user.dart';
import 'package:random_string/random_string.dart';
import 'package:intl/intl.dart';
import 'package:mytutor/paymentScreen.dart';
import 'package:mytutor/tutor.dart';
import 'package:toast/toast.dart';
import 'package:mytutor/mainscreen.dart';
import 'package:glassmorphism/glassmorphism.dart';

void main() => runApp(BookingScreen());

class BookingScreen extends StatefulWidget {
  final User user;
  final Tutor tutor;
  const BookingScreen({Key key, this.user, this.tutor}) : super(key: key);
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  String titlecenter = "Loading ...";
  double screenHeight, screenWidth;
  //String selectedTime = "9:00 - 10:00";
  String selectedQty = "1";

  List<String> timelist = [
    "9:00 - 10:00",
    "10:00 - 11:00",
    "12:00 - 13:00",
    "15:00 - 16:00",
    "17:00 - 18:00",
    "19:00 - 20:00",
  ];
  List<String> qty = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
  ];
  bool _full = true;
  bool _deposit = false;
  double _totalprice = 0.0;
  double _depositcharge = 0.0;
  double _amountpayable = 0.0;

  @override
  void initState() {
    super.initState();
    //_loadSubject();
    _full = true;
    _onFullPayment(true);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Tutor Booking'),
        backgroundColor: Color.fromRGBO(14, 30, 64, 1),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 120.0,
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
                      height: 120.0,
                      blur: 20,
                      linearGradient: LinearGradient(colors: [
                        Colors.white.withOpacity(0.2),
                        Colors.white38.withOpacity(0.2)
                      ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                      borderGradient: LinearGradient(colors: [
                        Colors.white24.withOpacity(0.2),
                        Colors.white70.withOpacity(0.2)
                      ]),
                      border: 2,
                      borderRadius: 2,
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        //mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Colors.black,
                            backgroundImage: NetworkImage(
                              "https://smileylion.com/mytutor/images/${widget.tutor.picture}.jpg?",
                            ),
                            radius: 50.0,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Booking with",
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                widget.tutor.name,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              
              Card(
                elevation: 10,
                child: Container(
                  height: screenHeight/1.3,
                  width: screenWidth,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Column(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Icon(
                              Icons.subject,
                              size: 20,
                            ),
                            Text(" Your Class Details",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                    ),
                                
                          ],
                        ),
                        SizedBox(height:5),
                        Text(widget.tutor.subject + " - " + widget.tutor.level,style: TextStyle(fontSize:17),),
                        Text("Date: "+widget.tutor.date,style: TextStyle(fontSize:17)),
                        Text("Time: "+widget.tutor.time,style: TextStyle(fontSize:17)),
                        Text(widget.tutor.lessonlocation +
                            " - " +
                            widget.tutor.address,style: TextStyle(fontSize:17)),
                            ]
                          )
                        ),
                        SizedBox(height: 10,),
                        Container(
                            child: Row(
                               crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text("Select your Booking Quantity:",style: TextStyle(fontSize:17)),
                            SizedBox(width: 20),
                            Container(

                                height: 30,
                                //padding: EdgeInsets.only(left: 10, right: 10),
                                width: 80,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blue),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0))),
                                child: DropdownButtonHideUnderline(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12, right: 2),
                                    child: DropdownButton(
                                      isExpanded: true,
                                      hint:
                                          Text('Select your booking quantity'),
                                      value: selectedQty,
                                      underline: Container(
                                        color: Colors.transparent,
                                      ),
                                      onChanged: (newValue) {
                                        setState(() {
                                          selectedQty = newValue;
                                          print(selectedQty);
                                          _updatePayment();
                                        });
                                      },
                                      items: qty.map((selectedQty) {
                                        return DropdownMenuItem(
                                            child: Text(
                                              selectedQty.toString(),
                                            ),
                                            value: selectedQty);
                                      }).toList(),
                                    ),
                                  ),
                                )),
                          ],
                        )),
                        Divider(),
                        Container(
                            child: Column(
                              children: <Widget>[
                            Text(
                              "Payment option",
                              style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Checkbox(
                                    value: _full,
                                    onChanged: (bool value) {
                                      _onFullPayment(value);
                                    }),
                                Text("Full Payment",style: TextStyle(fontSize:17)),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(15, 2, 15, 2),
                                  child: Container(
                                    width: 1,
                                    height: 45,
                                    color: Colors.grey,
                                  ),
                                ),
                                Checkbox(
                                    value: _deposit,
                                    onChanged: (bool value) {
                                      _onDepositPayment(value);
                                    }),
                                Text("Deposit only",style: TextStyle(fontSize:17)),
                              ],
                            ),
                          ],
                        )),
                        Divider(),
                        Container(
                          height: screenHeight / 6,
                          width: screenWidth / 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              //Text("Payment ",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                              Padding(
                                  padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                                  child: Table(
                                      defaultColumnWidth: FlexColumnWidth(1.0),
                                      columnWidths: {
                                        0: FlexColumnWidth(7),
                                        1: FlexColumnWidth(3),
                                      },
                                      children: [
                                        TableRow(children: [
                                          TableCell(
                                            child: Container(
                                                alignment: Alignment.centerLeft,
                                                height: 20,
                                                child:
                                                    Text("Total Class Price",style: TextStyle(fontSize:17))),
                                          ),
                                          TableCell(
                                            child: Container(
                                                alignment: Alignment.centerLeft,
                                                height: 20,
                                                child: Text("RM " +
                                                        _totalprice
                                                            .toStringAsFixed(
                                                                2) ??
                                                    "0.00",style: TextStyle(fontSize:17))),
                                          ),
                                        ]),
                                        TableRow(children: [
                                          TableCell(
                                            child: Container(
                                                alignment: Alignment.centerLeft,
                                                height: 20,
                                                child: Text("Deposit Charge",style: TextStyle(fontSize:17))),
                                          ),
                                          TableCell(
                                            child: Container(
                                                alignment: Alignment.centerLeft,
                                                height: 20,
                                                child: Text("RM " +
                                                        _depositcharge
                                                            .toStringAsFixed(
                                                                2) ??
                                                    "0.00",style: TextStyle(fontSize:17))),
                                          ),
                                        ]),
                                        TableRow(children: [
                                          TableCell(
                                            child: Container(
                                                alignment: Alignment.centerLeft,
                                                height: 20,
                                                child: Text("Total Amount",style: TextStyle(fontWeight:FontWeight.bold,fontSize: 17),)),
                                          ),
                                          TableCell(
                                            child: Container(
                                                alignment: Alignment.centerLeft,
                                                height: 20,
                                                child: Text("RM " +
                                                        _amountpayable
                                                            .toStringAsFixed(
                                                                2) ??
                                                    "0.00",style: TextStyle(fontWeight:FontWeight.bold,fontSize: 17))),
                                          ),
                                        ]),
                                      ]))
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children:<Widget>[
                              MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          minWidth: 300,
                          height: 50,
                          child: Text('Make Payment',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )),
                          color: Color.fromRGBO(14, 30, 64, 1),
                          //textColor: Colors.blue,
                          elevation: 10,
                          onPressed: makePaymentDialog,
                        ),
                            ]
                          )
                        ),
                        
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void makePaymentDialog() {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text(
          'Proceed with payment?',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        content: new Text(
          'Are you sure?',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                makePayment();
              },
              child: Text(
                "Ok",
                style: TextStyle(
                  color: Colors.black,
                ),
              )),
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.black,
                ),
              )),
        ],
      ),
    );
  }

  Future<void> makePayment() async {
    String paystatus = "";
    if (_full) {
      print("FULL PAYMENT");
      paystatus = "Full Payment";
      Toast.show("Full Payment", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } else if (_deposit) {
      print("DEPOSIT");
      paystatus = "Deposit";
      Toast.show("Deposit Only", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } else {
      Toast.show("Please select payment option", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
    var now = new DateTime.now();
    var formatter = new DateFormat('ddMMyyyy-');
    String bookingid = widget.user.email.substring(0, 4) +
        "-" +
        formatter.format(now) +
        randomAlphaNumeric(6);
    print(bookingid);
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => PaymentScreen(
                  user: widget.user,
                  bookingid: bookingid,
                  tutor: widget.tutor,
                  quantity: selectedQty,
                  val: _amountpayable.toStringAsFixed(2),
                  paystatus: paystatus,
                )));

    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => MainScreen(user:widget.user)));
    Navigator.pop(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => MainScreen(user: widget.user)));
  }

  void _onFullPayment(bool newValue) => setState(() {
        _full = newValue;
        if (_full) {
          _deposit = false;
          _updatePayment();
        } else {
          _updatePayment();
        }
      });

  void _onDepositPayment(bool newValue) {
    setState(() {
      _deposit = newValue;
      if (_deposit) {
        _full = false;
        _updatePayment();
      } else {
        _updatePayment();
      }
    });
  }

  void _updatePayment() {
    setState(() {
      _totalprice = double.parse(widget.tutor.price) *
          double.parse(widget.tutor.totalclass) *
          double.parse(selectedQty);
      _depositcharge = _totalprice * 0.20;
      print(_full);
      if (_full) {
        _amountpayable = _totalprice + _depositcharge;
      }
      if (_deposit) {
        _totalprice = 0.00;
        _amountpayable = _depositcharge;
      }
      print(_totalprice);
      print("Deposit" + _depositcharge.toStringAsFixed(3));
      print(_amountpayable);
    });
  }
}
