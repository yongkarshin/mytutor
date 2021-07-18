import 'package:flutter/material.dart';
import 'package:mytutor/class.dart';
import 'package:mytutor/tutor.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';

void main() => runApp(UpdateClassScreen());

class UpdateClassScreen extends StatefulWidget {
  final Tutor tutor;
  final ClassTutor classtutor;
  const UpdateClassScreen({Key key, this.tutor, this.classtutor})
      : super(key: key);

  @override
  _UpdateClassScreenState createState() => _UpdateClassScreenState();
}

class _UpdateClassScreenState extends State<UpdateClassScreen> {
  final TextEditingController _subjectCon = TextEditingController();
  final TextEditingController _levelCon = TextEditingController();
  final TextEditingController _taughtLanguageCon = TextEditingController();
  final TextEditingController _priceCon = TextEditingController();
  final TextEditingController _durationCon = TextEditingController();
  final TextEditingController _totalClassCon = TextEditingController();
  final TextEditingController _quantityCon = TextEditingController();
  //final TextEditingController _lessonLocationCon = TextEditingController();
  final TextEditingController _latitudeCon = TextEditingController();
  final TextEditingController _longitudeCon = TextEditingController();
  final TextEditingController _addressCon = TextEditingController();
  String _subject = "";
  String _level = "";
  String _taughtlanguage = "";
  String _price = "";
  String _duration = "";
  String _totalClass = "";
  String _quantity = "";
  String _lessonLocation = "Neutral Location";
  String _address = "";
  double screenHeight, screenWidth;

  double latitude, longitude;
  String gmaploc = "";
  Position _currentPosition;
  int _radioValue = 0;
  
  String _setTime, _setDate;
  String _hour, _minute, _time;
  String dateTime;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getLocation();
    _subjectCon.text = widget.classtutor.subject;
    _levelCon.text = widget.classtutor.level;
    _taughtLanguageCon.text = widget.classtutor.taughtlanguage;
    _priceCon.text = widget.classtutor.price;
    _durationCon.text = widget.classtutor.duration;
    _totalClassCon.text = widget.classtutor.totalclass;
    _quantityCon.text = widget.classtutor.quantity;
    _lessonLocation = widget.classtutor.lessonlocation;
    _addressCon.text = widget.classtutor.address;
    _dateController.text = widget.classtutor.date;
    _timeController.text = formatDate(
        DateTime(2021, 06, 01, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text("Update Class")),
      body: Container(
          child: SingleChildScrollView(
            child: Card(
              elevation: 10,
              child: Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(children: [
                TextField(
                    controller: _subjectCon,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: 'Subject', icon: Icon(Icons.book))),
                TextField(
                    controller: _levelCon,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: 'Level', icon: Icon(Icons.equalizer))),
                SizedBox(
                  height: 10,
                ),
                TextField(
                    controller: _taughtLanguageCon,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: 'Taught Language',
                        icon: Image.asset("assets/images/language.png",
                            width: 25, height: 25, color: Colors.grey[600]))),
                Container(
                  //height: 30,
                    child: Row(
                      children: [
                        Tab(icon: Icon(Icons.calendar_today)),
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap:(){
                            _selectDate(context);
                          },
                          child:Container(
                            width: screenWidth/3,
                            height: 30,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(color: Colors.grey[100],),
                            child: TextFormField(
                              style: TextStyle(fontSize:18),
                              textAlign: TextAlign.center,
                              enabled: false,
                              keyboardType: TextInputType.text,
                              controller: _dateController,
                              onSaved: (String val){
                                _setDate=val;
                              },
                              decoration: InputDecoration(
                                disabledBorder:UnderlineInputBorder(borderSide: BorderSide.none),
                                //contentPadding: EdgeInsets.only(top: 0.0)
                              ),
                            ),
                          )
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Tab(icon: Icon(Icons.timer)),
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap:(){
                            _selectTime(context);
                          },
                          child:Container(
                            width: screenWidth/3,
                            height: 30,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(color: Colors.grey[100],),
                            child: TextFormField(
                              style: TextStyle(fontSize:18),
                              textAlign: TextAlign.center,
                              enabled: false,
                              keyboardType: TextInputType.text,
                              controller: _timeController,
                              onSaved: (String val){
                                _setTime=val;
                              },
                              decoration: InputDecoration(
                                disabledBorder:UnderlineInputBorder(borderSide: BorderSide.none),
                                //contentPadding: EdgeInsets.only(top: 0.0)
                              ),
                            ),
                          )
                        ),
                      ])
                ),
                TextField(
                    controller: _priceCon,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: 'Price (RM)',
                        icon: Image.asset("assets/images/rm2.png",
                            width: 25, height: 25, color: Colors.grey[600]))),
                TextField(
                    controller: _durationCon,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: 'Duration (Min)', icon: Icon(Icons.timer))),
                TextField(
                    controller: _totalClassCon,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: 'Total Class',
                        icon: Image.asset("assets/images/class.png",
                            width: 25, height: 25, color: Colors.grey[600]))),
                TextField(
                    controller: _quantityCon,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: 'Quantity', icon: Icon(Icons.event_seat))),
                SizedBox(
                  height: 10,
                ),
                Container(
                    height: 30,
                    child: Row(
                      children: [
                        //Icon(Icons.location_on),
                        Tab(icon: Icon(Icons.pin_drop)),

                        SizedBox(
                          width: 5,
                        ),
                        new Radio(
                            value: 0,
                            groupValue: _radioValue,
                            onChanged: _handleRadioValueChange),
                        new Text("Neutral Location"),
                        SizedBox(
                          width: 5,
                        ),
                        new Radio(
                            value: 1,
                            groupValue: _radioValue,
                            onChanged: _handleRadioValueChange),
                        new Text("Tutors House"),
                      ],
                    )),
                Container(
                    height: 30,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 29,
                        ),
                        new Radio(
                            value: 2,
                            groupValue: _radioValue,
                            onChanged: _handleRadioValueChange),
                        new Text("Students House"),
                        SizedBox(
                          width: 12,
                        ),
                        new Radio(
                            value: 3,
                            groupValue: _radioValue,
                            onChanged: _handleRadioValueChange),
                        new Text("Online Tutoring"),
                      ],
                    )),
                /*TextField(
                    controller: _lessonLocationCon,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: 'lessonLocation',
                        icon: Icon(Icons.pin_drop))),*/

                SizedBox(
                  height: 6,
                ),
                SizedBox(height: 15),
                Container(
                    height: 30,
                    child: Row(
                      children: [
                        GestureDetector(
                          child: Icon(Icons.gps_fixed),
                          onTap: _searchCurLoc,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          gmaploc,
                          style: TextStyle(fontSize: 17),
                        ),
                      ],
                    )),
                    /*Container(
                    height: 30,
                    child: Row(
                      children: [
                        GestureDetector(
                          child: Icon(Icons.location_on),
                          onTap: _searchCurLoc,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        
                      Flexible(child: Text(
                  curaddress,
                  maxLines: 2,
                  softWrap: false,
                  overflow: TextOverflow.fade,
                  style: TextStyle(fontSize: 17),
                ),)
                   
                      ],
                    )),*/
                 
                TextField(
                    controller: _addressCon,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: 'Address', icon: Icon(Icons.location_on))),
                SizedBox(height: 10),
                MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      minWidth: 300,
                      height: 50,
                      child: Text('Update',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )),
                      color: Color.fromRGBO(14, 30, 64, 1),
                      //textColor: Colors.blue,
                      elevation: 10,
                      onPressed: updateClassDialog),
                
                SizedBox(height: 10),
              ])),
            )
                  )),
    );
  }
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat.yMd().format(selectedDate);
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
        _timeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }
  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
      switch (_radioValue) {
        case 0:
          _lessonLocation = "Neutral Location";
          break;
        case 1:
          _lessonLocation = "Tutors House";
          break;
        case 2:
          _lessonLocation = "Students House";
          break;
        case 3:
          _lessonLocation = "Online Tutoring";
          break;
      }
    });
  }

  void updateClassDialog() {
    _subject = _subjectCon.text;
    _level = _levelCon.text;
    _taughtlanguage = _taughtLanguageCon.text;
    _price = _priceCon.text;
    _duration = _durationCon.text;
    _totalClass = _totalClassCon.text;
    _quantity = _quantityCon.text;
    //_lessonLocation = _lessonLocationCon.text;
    _address = _addressCon.text;
    if(_subject==""&&_level==""&&_taughtlanguage==""
    &&_price==""&&_duration==""&&_totalClass==""&&
    _quantity==""&&_lessonLocation==""&&_address==""){
      Toast.show(
        "Fill all required fields",
        context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.TOP,
      );
      return;
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text(
              "Update " + widget.classtutor.subject,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            content: new Text(
              "Are you sure?",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text(
                  "Yes",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  _onUpdateClass();
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
        });
  }
  void _onUpdateClass() {
    _subject = _subjectCon.text;
    _level = _levelCon.text;
    _taughtlanguage = _taughtLanguageCon.text;
    _price = _priceCon.text;
    _duration = _durationCon.text;
    _totalClass = _totalClassCon.text;
    _quantity = _quantityCon.text;
    //lessonLocation = _lessonLocation;
    _address = _addressCon.text;

    http.post("https://smileylion.com/mytutor/php/update_class.php", body: {
      "classid": widget.classtutor.classid,
      "subject": _subject,
      "level": _level,
      "taughtlanguage": _taughtlanguage,
      "date": selectedDate.toString(),
      "time": formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString(),
      "price": _price,
      "duration": _duration,
      "totalclass": _totalClass,
      "quantity": _quantity,
      "lessonlocation": _lessonLocation,
      "latitude": _currentPosition.latitude.toString(),
      "longitude":_currentPosition.longitude.toString(),
      "address": _address,
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show(
          "Success",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
        Navigator.pop(context);
      } else {
        Toast.show(
          "Failed",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
        );
      }
    }).catchError((err) {
      print(err);
    });
  }
  Future<void> _getLocation() async{
         try {
      final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
      geolocator
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
          .then((Position position) {
        setState(() {
          _currentPosition = position;
          print("GEOLOCATOR");
          if (_currentPosition != null) {
            print(gmaploc);
            gmaploc = _currentPosition.latitude.toString() +
                "/" +
                _currentPosition.longitude.toString();
          }
        });
      }).catchError((e) {
        print(e);
      });
    } catch (exception) {
      print(exception.toString());
    }
      }

     _searchCurLoc() {
    _getLocation();
  } 

}
