import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:mytutor/tutor.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:random_string/random_string.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';

void main() => runApp(NewClassScreen());

class NewClassScreen extends StatefulWidget {
  final Tutor tutor;
  const NewClassScreen({Key key, this.tutor}) : super(key: key);
  @override
  _NewClassScreenState createState() => _NewClassScreenState();
}

class _NewClassScreenState extends State<NewClassScreen> {
  double screenHeight, screenWidth;
  final TextEditingController _subjectCon = TextEditingController();
  final TextEditingController _levelCon = TextEditingController();
  final TextEditingController _taughtLanguageCon = TextEditingController();
  final TextEditingController _priceCon = TextEditingController();
  final TextEditingController _durationCon = TextEditingController();
  final TextEditingController _totalClassCon = TextEditingController();
  final TextEditingController _quantityCon = TextEditingController();
  final TextEditingController _lessonLocationCon = TextEditingController();
  final TextEditingController _addressCon = TextEditingController();

  bool _visibleSubjects=true;
  bool _visiblePricing=false;
  bool _visibleAvailability=false;

  var taughtLanguage = {"English", "Malay", "Mandrian", "Tamil","Others"};
  var lessonLocation = {
    "All",
    "Neutral Location",
    "Tutors House",
    "Students House",
    "Online Tutoring"
  };
  int _radioValue = 0;
  String _lessonLocation = "Neutral Location";

  double latitude, longitude;
  String gmaploc = "";
  String curaddress;
  Position _currentPosition;

  String _selectedSubjects;
  final List<String> _subjectslist=[
    "Art",
    "Math",
    "Music",
    "Science",
    "MUET",
    "IELTS",
    "Mandarin",
    "English Language",
    "French Language",
    "Germen Language",
    "Italian Language",
    "Japanese Language",
    "Spanish Language",
    "Biology",
    "Chemistry",
    "Phycis",
    "Astronomy",
    "Law",
    "Piano",
    "Dance",
    "Photography",
    "Guitar",
    "Accounting",
    "Business",
    "Video Editing",
    "Graphic Design",
    "Fitness",
    "Nutrition",
    "Cooking",
    "Pastry & Dessert",

  ];

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
    //_getAddress();
    _dateController.text = DateFormat.yMd().format(DateTime.now());
    _timeController.text = formatDate(
        DateTime(2021, 06, 01, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    dateTime = DateFormat.yMd().format(DateTime.now());
    return Scaffold(
      appBar: AppBar(
        title: Text("New Class"),
        backgroundColor: Color.fromRGBO(14, 30, 64, 1)
      ),
      body: Container(
        child: SingleChildScrollView(
            child: Card(
              elevation: 10,
              child: Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
              children: <Widget>[
                /*
                Container(
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                        child: Text("Subjects",style: TextStyle(fontSize:20),),
                      ),
                      GestureDetector(
                        onTap:(){
                          setState((){
                            _visibleSubjects=!_visibleSubjects;
                          });
                        },
                        child: Icon(
                          _visibleSubjects
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_up,
                          color: Color.fromRGBO(14, 30, 64, 1),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      )
                        ],
                      ),
                      Visibility(
                        visible: _visibleSubjects,
                        child: Padding(padding: EdgeInsets.all(5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          /*children:[
                            Container(
                              child: Autocomplete(
                                 optionsBuilder: (TextEditingValue value){
                                   if(value.text.isEmpty){
                                     return[];
                                   }
                                   return _subjectslist.where((suggestion) => suggestion.toLowerCase().contains(value.text.toLowerCase()));
                                 },
                                 onSelected:(value){
                                   setState(() {
                                     _selectedSubjects=value;
                                   });
                                 }
                              )
                            ),
                          Text(_selectedSubjects!=null
                          ? _selectedSubjects
                          : "Type something",
                          )
                          ],*/
                            /*Text("Subjects",style: TextStyle(fontSize:18,fontWeight: FontWeight.bold),),
                            Text("AutoComplete Text"),
                            Text("Levels",style: TextStyle(fontSize:18,fontWeight: FontWeight.bold),),
                            Text("AutoComplete Text"),
                            Text("Taught Languages",style: TextStyle(fontSize:18,fontWeight: FontWeight.bold),),
                            Text("AutoComplete Text"),*/
                          
                        ),
                        )
                        
                        ),
                    ]
                  )
                ),
                Divider(),
                Container(
                  child:Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                        child: Text("Pricing",style: TextStyle(fontSize:20),),

                      ),
                      GestureDetector(
                        onTap:(){
                          setState((){
                            _visiblePricing=!_visiblePricing;
                          });
                        },
                        child: Icon(
                          _visiblePricing
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_up,
                          color: Color.fromRGBO(14, 30, 64, 1),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      )
                        ],
                      ),
                      Visibility(
                        visible: _visiblePricing,
                        child: Padding(padding: EdgeInsets.all(5),
                        child: Column(
                          children: <Widget>[
                            Text("Testing"),
                          ]
                        ),
                        )),
                    ]
                  )
                ),
                Divider(),
                Container(
                  child:Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                        child: Text("Availability",style: TextStyle(fontSize:20),),

                      ),
                      GestureDetector(
                        onTap:(){
                          setState((){
                            _visibleAvailability=!_visibleAvailability;
                          });
                        },
                        child: Icon(
                          _visibleAvailability
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_up,
                          color: Color.fromRGBO(14, 30, 64, 1),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      )
                        ],
                      ),
                      Visibility(
                        visible: _visibleAvailability,
                        child: Padding(padding: EdgeInsets.all(5),
                        child: Column(
                          children: <Widget>[
                            Text("Testing"),
                          ]
                        ),
                        )),
                    ]
                  )
                ),*/
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
                    child: Text('Add New Class',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        )),
                    color: Color.fromRGBO(14, 30, 64, 1),
                    //textColor: Colors.blue,
                    elevation: 10,
                    onPressed: newClassDialog),
              ],
            ),
            ),
          ),
          ),
        
      ),
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

  void newClassDialog() {
    String _subject = _subjectCon.text;
    String _level = _levelCon.text;
    String _taughtlanguage = _taughtLanguageCon.text;
    String _price = _priceCon.text;
    String _duration = _durationCon.text;
    String _totalClass = _totalClassCon.text;
    String _quantity = _quantityCon.text;
    //String _lessonLocation = _lessonLocationCon.text;
    String _address = _addressCon.text;
    if (_subject == "" &&
        _level == "" &&
        _taughtlanguage == "" &&
        _price == "" &&
        _duration == "" &&
        _totalClass == "" &&
        _quantity == "" &&
        _lessonLocation == "" &&
        _address == "") {
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
            "Register new Class? ",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
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
                _addClass();
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

  String generateClassid() {
    String classid = randomNumeric(6);
    return classid;
  }

  void _addClass() {
    String _subject = _subjectCon.text;
    String _level = _levelCon.text;
    String _taughtlanguage = _taughtLanguageCon.text;
    String _price = _priceCon.text;
    String _duration = _durationCon.text;
    String _totalClass = _totalClassCon.text;
    String _quantity = _quantityCon.text;
    //String _lessonLocation = _lessonLocationCon.text;
    String _address = _addressCon.text;
    http.post("https://smileylion.com/mytutor/php/new_class.php", body: {
      "classid": generateClassid(),
      "tutorid": widget.tutor.tutorid,
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
      "longitude": _currentPosition.longitude.toString(),
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

  Future<void> _getLocation() async {
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

  Future<void> _getAddress() async {
    try {
      final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
      _currentPosition = await geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      final coordinates = new Coordinates(_currentPosition.latitude, _currentPosition.longitude);
      var addresses =await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      setState(() {
        curaddress = first.addressLine;
        if (curaddress != null) {
          latitude = _currentPosition.latitude;
          longitude = _currentPosition.longitude;
          return;
        }
      });
      print("${first.featureName} : ${first.addressLine}");
    } catch (exception) {
      print(exception.toString());
    }
  }

  _searchCurLoc() {
    _getLocation();
    //_getAddress();
  }
}
