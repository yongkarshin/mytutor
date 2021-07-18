import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mytutor/tutordetail.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mytutor/tutor.dart';
import 'package:mytutor/user.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:favorite_button/favorite_button.dart';

void main() => runApp(MainScreen());

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({Key key, this.user}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  GlobalKey<RefreshIndicatorState> refreshKey;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List tutordata;
  double screenHeight, screenWidth;
  String title = "Loading...";
  bool _isFavorite;

  TextEditingController _max = new TextEditingController();
  TextEditingController _address = new TextEditingController();
  TextEditingController _searchcontroller = TextEditingController();

  List<String> _selectedItems = [];

  String curaddress;
  Position _currentPosition;
  double latitude, longitude, classlat, classlon;
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController gmcontroller;
  String _homeloc;
  CameraPosition _home;
  MarkerId markerId1 = MarkerId("12");
  Set<Marker> markers = Set();
  CameraPosition _userpos;
  double distance = 0.0;

  // ignore: unused_field
  bool _isHideValue1 = true;
  // ignore: unused_field
  bool _isHideValue2 = false;
  // ignore: unused_field
  bool _isHideValue3 = true;
  // ignore: unused_field
  bool _isHideValue4 = false;
  // ignore: unused_field
  bool _isHideValue5 = false;
  // ignore: unused_field
  bool _isHidePrimary = false;
  // ignore: unused_field
  bool _isHideSeconadary = false;

  // ignore: unused_field
  bool _isSelected1 = false;
  // ignore: unused_field
  bool _isSelected2 = false;
  // ignore: unused_field
  bool _isSelected3 = false;
  // ignore: unused_field
  bool _isSelected4 = false;

  var taughtLanguage = {"All", "English", "Malay", "Mandrian", "Tamil"};
  var lessonLocation = {"All", "In Person", "Online Tutoring"};
  var subject = {"All", "Malay", "English", "Tamil", "Chineses", "Mathematics"};
  var syllabus = {"All", "Standard 1", "Standard 2"};
  var sort = {
    "Relevance",
    "Price Highest",
    "Price Lowest",
    "In Person",
    "Online Tutoring",
    "Nearest Tutor"
  };

  String selectedsort = "Relevance";
  String selectedsubject = "All";
  String selectedsyllabus = "All";
  String selectedtaughtLanguage = "All";
  String selectedlessonLocation = "All";

  @override
  void initState() {
    super.initState();
    _loadsearchsortTutor(selectedsort, _searchcontroller.text);
    _getLocation();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        resizeToAvoidBottomPadding: true,
        key: _scaffoldKey,
        endDrawer: Drawer(
            child: Container(
                margin: EdgeInsets.only(left: 5, top: 0),
                color: Colors.white,
                height: screenHeight,
                child: Column(
                  children: <Widget>[
                    Expanded(
                        child: ListView(
                            primary: false,
                            shrinkWrap: true,
                            children: <Widget>[
                          Container(
                              padding: EdgeInsets.only(top: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Filter",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )),
                          //Divider(),
                          //_filter(),
                          //Divider(),
                          //_filter0(),
                          Divider(),
                          _filter1(),
                          Divider(),
                          _filter2(),
                          Divider(),
                          _filter3(),
                          Divider(),
                          _filter4(),
                          Divider(),
                          _filter5(),
                          Divider(),
                        ])),
                    Container(
                        height: 44,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            GestureDetector(
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: 25, top: 6, right: 25, bottom: 6),
                                  height: 34,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Text(
                                    "Reset",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                    textAlign: TextAlign.center,
                                  ),
                                  alignment: Alignment.centerLeft,
                                ),
                                onTap: () {
                                  //_loadTutor();
                                }),
                            GestureDetector(
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 25, top: 6, right: 25, bottom: 6),
                                height: 34,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  "Apply",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                  textAlign: TextAlign.center,
                                ),
                                alignment: Alignment.centerLeft,
                              ),
                              onTap: null, //() => _filterItem(_selectedItems),
                            ),
                          ],
                        )),
                    SizedBox(height: 10),
                  ],
                ))),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 30,
                    padding:
                        EdgeInsets.only(left: 8, right: 0, bottom: 1, top: 1),
                    //width: 120,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: DropdownButton(
                      hint: Text('Sort'),
                      value: selectedsort,
                      underline: Container(
                        color: Colors.transparent,
                      ),
                      onChanged: (newValue) {
                        setState(() {
                          selectedsort = newValue;
                          print(selectedsort);
                          _loadsearchsortTutor(
                              selectedsort, _searchcontroller.text);
                        });
                      },
                      items: sort.map((selectedsort) {
                        return DropdownMenuItem(
                          child: Text(
                            selectedsort.toString(),
                          ),
                          value: selectedsort,
                        );
                      }).toList(),
                    ),
                  ),
                  Container(
                    width: screenWidth / 2.5,
                    height: 50,
                    padding: EdgeInsets.fromLTRB(3, 10, 1, 10),
                    child: TextField(
                      autofocus: false,
                      controller: _searchcontroller,
                      //textInputAction: TextInputAction.search,
                      //onSubmitted: (value) {
                      //_loadTutor2(_searchcontroller.text);
                      //},
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 1, top: 1, right: 15),
                          hintText: "Search Tutor",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.blue),
                            borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0)),
                          )),
                    ),
                  ),
                  Container(
                    height: 30,
                    width: 40,
                    padding:
                        EdgeInsets.only(left: 3, right: 3, bottom: 0, top: 0),
                    child: OutlineButton(
                      padding:
                          EdgeInsets.only(left: 1, right: 1, bottom: 1, top: 1),
                      child: Icon(Icons.search),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.blue,
                        ),
                        borderRadius:
                            const BorderRadius.all(const Radius.circular(5.0)),
                      ),
                      onPressed: () {
                        _loadsearchsortTutor(
                            selectedsort, _searchcontroller.text);
                        //print("not thing here");
                      },
                    ),
                  ),
                  Container(
                    height: 30,
                    width: 40,
                    padding:
                        EdgeInsets.only(left: 3, right: 3, bottom: 0, top: 0),
                    child: OutlineButton(
                      padding:
                          EdgeInsets.only(left: 1, right: 1, bottom: 1, top: 1),
                      child: Icon(Icons.edit_location),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.blue,
                        ),
                        borderRadius:
                            const BorderRadius.all(const Radius.circular(5.0)),
                      ),
                      onPressed: () {
                        _loadMapDialog();
                      },
                    ),
                  ),
                  /*Container(
                        height: 30,
                        width: 80,
                        padding:
                            EdgeInsets.only(left: 3, right: 3, bottom: 0, top: 0),
                        child: OutlineButton(
                            child: Text("Filter"),
                            textColor: Colors.black,
                            highlightColor: Colors.grey,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Colors.blue,
                              ),
                              borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0)),
                            ),
                            onPressed: () {
                              _scaffoldKey.currentState.openEndDrawer();
                            }),
                      ),*/

                  /*IconButton(
                          icon: Icon(Icons.edit_location),
                          onPressed: () => _loadMapDialog()),
                      Text("Tutor near you", style: TextStyle(fontSize: 20)),
                      Stack(
                        children: [
                          IconButton(
                              icon: Icon(Icons.filter_list),
                              onPressed: () {
                                _scaffoldKey.currentState.openEndDrawer();
                              }),
                        ],
                      ),*/
                ],
              ),
              Divider(height: 2),
              tutordata == null
                  ? Flexible(
                      child: Container(child: Center(child: Text(title))))
                  : Flexible(
                      child: RefreshIndicator(
                          key: refreshKey,
                          color: Colors.blue,
                          onRefresh: () async {
                            _loadTutor();
                          },
                          child: ListView.builder(
                              itemCount: tutordata.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: <Widget>[
                                    InkWell(
                                        onTap: () => {
                                              checkFavorite(index),
                                            },
                                        child: Card(
                                          elevation: 10,
                                          child: Padding(
                                            padding: EdgeInsets.all(5),
                                            child: Row(
                                              children: <Widget>[
                                                GestureDetector(
                                                  onTap: () =>
                                                      _onImageDisplay(index),
                                                  child: ClipOval(
                                                    //height: screenHeight / 5,
                                                    //width: screenWidth / 2.5,
                                                    child: CachedNetworkImage(
                                                      fit: BoxFit.cover,
                                                      imageUrl:
                                                          "https://smileylion.com/mytutor/images/${tutordata[index]['picture']}.jpg?",
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
                                                    Text(
                                                      tutordata[index]['name']
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20),
                                                    ),
                                                    Text(
                                                      tutordata[index]
                                                                  ['subject']
                                                              .toString() +
                                                          " - " +
                                                          tutordata[index]
                                                                  ['level']
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontSize: 18),
                                                    ),
                                                    Text(
                                                      tutordata[index]
                                                              ['lessonlocation']
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 18),
                                                    ),
                                                    Text(
                                                      "RM " +
                                                          tutordata[index]
                                                              ['price'] +
                                                          " Onwards",
                                                      style: TextStyle(
                                                          fontSize: 19,
                                                          color: Colors.red),
                                                    ),
                                                  ],
                                                )),
                                                /*Expanded(child: Column(children: <Widget>[
                                                  Text("3.098 km",style: TextStyle(fontSize: 16),),
                                                ],))*/
                                              ],
                                            ),
                                          ),
                                        ))
                                  ],
                                );
                              }))),
            ],
          ),
        ));
  }

  Future checkFavorite(index) async {
    await http
        .post("http://smileylion.com/mytutor/php/check_favorite.php", body: {
      "classid": tutordata[index]['classid'],
      "userid": widget.user.userid,
    }).then((res) {
      print(res);
      if (res.body == "not favorite") {
        setState(() {
          _isFavorite = false;
        });

        //Toast.show("Not Favorite", context,duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else {
        setState(() {
          _isFavorite = true;
        });

        //Toast.show("Favorite", context,duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
      _loadTutorDetail(index);
    }).catchError((err) {
      print(err);
    });
  }

  void _loadTutor() async {
    _searchcontroller.clear();
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Loading...");
    await pr.show();
    String url = "https://smileylion.com/mytutor/php/load_tutor_search.php";
    await http.post(url, body: {}).then((res) {
      if (res.body == "nodata") {
        title = "No Tutor Found";
        setState(() {
          tutordata = null;
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          tutordata = extractdata["tutors"];
          selectedsort = "Relevance";
        });
      }
    }).catchError((err) {
      print(err);
    });
    await pr.hide();
  }

  _loadsearchsortTutor(String selectedsort, String keyword) async {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Loading...");
    pr.show();
    String url = "https://smileylion.com/mytutor/php/load_tutor_search.php";
    await http.post(url, body: {
      "keyword": keyword,
      "sort": selectedsort,
    }).then((res) {
      if (res.body == "nodata") {
        print(res.body);

        setState(() {
          title = "No Tutor Found";
          tutordata = null;
        });
        Toast.show(
          "Search found no result",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
        );
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          tutordata = extractdata["tutors"];
        });
      }
    }).catchError((err) {
      print(err);
    });
    await pr.hide();
  }

  _loadTutorDetail(int index) {
    print(tutordata[index]['name']);
    Tutor tutor = new Tutor(
      tutorid: tutordata[index]["tutorid"],
      name: tutordata[index]["name"],
      email: tutordata[index]["email"],
      phone: tutordata[index]["phone"],
      gender: tutordata[index]["gender"],
      picture: tutordata[index]["picture"],
      description: tutordata[index]["description"],
      occupation: tutordata[index]["occupation"],
      education: tutordata[index]["education"],
      institution: tutordata[index]["institution"],
      status: tutordata[index]["status"],
      classid: tutordata[index]["classid"],
      subject: tutordata[index]["subject"],
      level: tutordata[index]["level"],
      taughtlanguage: tutordata[index]["taughtlanguage"],
      date: tutordata[index]['date'],
      time: tutordata[index]['time'],
      price: tutordata[index]["price"],
      duration: tutordata[index]["duration"],
      totalclass: tutordata[index]["totalclass"],
      quantity: tutordata[index]["quantity"],
      balance: tutordata[index]["balance"],
      lessonlocation: tutordata[index]["lessonlocation"],
      longitude: tutordata[index]["longitude"],
      latitude: tutordata[index]["latitude"],
      address: tutordata[index]["address"],
    );
    //String fav=_isFavorite.toString();
    //print(fav);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => TutorDetailsScreen(
                  tutor: tutor,
                  user: widget.user,
                  favorite: _isFavorite,
                )));
  }

  void updateReset() {
    setState(() {
      _isSelected1 = false;
      _isSelected2 = false;
      _isSelected3 = false;
      _isSelected4 = false;
    });
    _selectedItems.clear();
    print(_selectedItems);
  }

  _onImageDisplay(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            content: new Container(
          height: screenHeight / 2.5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  height: screenWidth / 2,
                  width: screenWidth / 2,
                  decoration: BoxDecoration(
                      //border: Border.all(color: Colors.black),
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(
                              "https://smileylion.com/mytutor/images/${tutordata[index]['picture']}.jpg?")))),
            ],
          ),
        ));
      },
    );
  }

  // ignore: unused_element
  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: new Text(
              'Are you sure?',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            content: new Text(
              'Do you want to exit an App',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            actions: <Widget>[
              MaterialButton(
                  onPressed: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                  child: Text(
                    "Exit",
                    style: TextStyle(
                      color: Color.fromRGBO(101, 255, 218, 50),
                    ),
                  )),
              MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Color.fromRGBO(101, 255, 218, 50),
                    ),
                  )),
            ],
          ),
        ) ??
        false;
  }

  // ignore: unused_element
  Widget _filter0() {
    return Container(
        child: Padding(
      padding: EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Sort"),
          SizedBox(
            height: 5,
          ),
          Container(
              height: 30,
              padding: EdgeInsets.only(left: 10, right: 10),
              //width: 120,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: DropdownButtonHideUnderline(
                child: Padding(
                  padding: const EdgeInsets.only(left: 14.0, right: 14),
                  child: DropdownButton(
                    isExpanded: true,
                    hint: Text('Sort'),
                    value: selectedsort,
                    underline: Container(
                      color: Colors.transparent,
                    ),
                    onChanged: (newValue) {
                      setState(() {
                        selectedsort = newValue;
                        print(selectedsort);
                        //_loadsearchsortTutor(selectedsort);
                      });
                    },
                    items: sort.map((selectedsort) {
                      return DropdownMenuItem(
                          child: Text(
                            selectedsort.toString(),
                          ),
                          value: selectedsort);
                    }).toList(),
                  ),
                ),
              )),
        ],
      ),
    ));
  }

  Widget _filter1() {
    return Container(
        child: Padding(
      padding: EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Subject Taught"),
          SizedBox(
            height: 5,
          ),
          Container(
              height: 30,
              padding: EdgeInsets.only(left: 10, right: 10),
              //width: 120,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: DropdownButtonHideUnderline(
                child: Padding(
                  padding: const EdgeInsets.only(left: 14.0, right: 14),
                  child: DropdownButton(
                    isExpanded: true,
                    hint: Text('Subject Taught'),
                    value: selectedsubject,
                    underline: Container(
                      color: Colors.transparent,
                    ),
                    onChanged: (newValue) {
                      setState(() {
                        selectedsubject = newValue;
                        print(selectedsubject);
                        //_loadTutor(selectedsubject);
                      });
                    },
                    items: subject.map((selectedsubject) {
                      return DropdownMenuItem(
                          child: Text(
                            selectedsubject.toString(),
                          ),
                          value: selectedsubject);
                    }).toList(),
                  ),
                ),
              )),
        ],
      ),
    ));
  }

  Widget _filter2() {
    return Container(
        child: Padding(
      padding: EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Syllabus"),
          SizedBox(
            height: 5,
          ),
          Container(
              height: 30,
              padding: EdgeInsets.only(left: 10, right: 10),
              //width: 120,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: DropdownButtonHideUnderline(
                child: Padding(
                  padding: const EdgeInsets.only(left: 14.0, right: 14),
                  child: DropdownButton(
                    isExpanded: true,
                    hint: Text('Syllabus'),
                    value: selectedsyllabus,
                    underline: Container(
                      color: Colors.transparent,
                    ),
                    onChanged: (newValue) {
                      setState(() {
                        selectedsyllabus = newValue;
                        print(selectedsyllabus);
                        //_loadTutor(selectedsyllabus);
                      });
                    },
                    items: syllabus.map((selectedsyllabus) {
                      return DropdownMenuItem(
                        child: Text(
                          selectedsyllabus.toString(),
                        ),
                        value: selectedsyllabus,
                      );
                    }).toList(),
                  ),
                ),
              )),
        ],
      ),
    ));
  }

  Widget _filter3() {
    return Container(
        child: Padding(
      padding: EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Price Range (RM)"),
          SizedBox(
            height: 5,
          ),
          Container(
            color: Colors.white,
            constraints: BoxConstraints(
              maxHeight: 30,
              maxWidth: screenWidth,
            ),
            //margin: EdgeInsets.only(left: 6, right: 6),
            child: TextField(
              autofocus: false,
              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                //_loadTutor2(_searchcontroller.text);
              },
              controller: _max,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 10, right: 10),
                hintText: 'Max',
                //filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
          ),
        ],
      ),
    ));
  }

  Widget _filter4() {
    return Container(
        child: Padding(
      padding: EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Taught Languages"),
          SizedBox(
            height: 5,
          ),
          Container(
              height: 30,
              padding: EdgeInsets.only(left: 10, right: 10),
              //width: 120,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: DropdownButtonHideUnderline(
                child: Padding(
                  padding: const EdgeInsets.only(left: 14.0, right: 14),
                  child: DropdownButton(
                    isExpanded: true,
                    hint: Text('Taught Languages'),
                    value: selectedtaughtLanguage,
                    underline: Container(
                      color: Colors.transparent,
                    ),
                    onChanged: (newValue) {
                      setState(() {
                        selectedtaughtLanguage = newValue;
                        print(selectedtaughtLanguage);
                        //_loadTutor(selectedtaughtLanguage);
                      });
                    },
                    items: taughtLanguage.map((selectedtaughtLanguage) {
                      return DropdownMenuItem(
                        child: Text(
                          selectedtaughtLanguage.toString(),
                        ),
                        value: selectedtaughtLanguage,
                      );
                    }).toList(),
                  ),
                ),
              )),
        ],
      ),
    ));
  }

  Widget _filter5() {
    return Container(
        child: Padding(
      padding: EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Lesson Location"),
          SizedBox(
            height: 5,
          ),
          Container(
              height: 30,
              padding: EdgeInsets.only(left: 10, right: 10),
              //width: 120,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: DropdownButtonHideUnderline(
                child: Padding(
                  padding: const EdgeInsets.only(left: 14.0, right: 14),
                  child: DropdownButton(
                    isExpanded: true,
                    hint: Text('Lesson Location'),
                    value: selectedlessonLocation,
                    underline: Container(
                      color: Colors.transparent,
                    ),
                    onChanged: (newValue) {
                      setState(() {
                        selectedlessonLocation = newValue;
                        print(selectedlessonLocation);
                        //_loadTutor(selectedlessonLocation);
                      });
                    },
                    items: lessonLocation.map((selectedlessonLocation) {
                      return DropdownMenuItem(
                        child: Text(
                          selectedlessonLocation.toString(),
                        ),
                        value: selectedlessonLocation,
                      );
                    }).toList(),
                  ),
                ),
              )),
        ],
      ),
    ));
  }

  Future<void> _getLocation() async {
    try {
      final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
      geolocator
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
          .then((Position position) async {
        _currentPosition = position;
        if (_currentPosition != null) {
          final coordinates = new Coordinates(
              _currentPosition.latitude, _currentPosition.longitude);
          var addresses =
              await Geocoder.local.findAddressesFromCoordinates(coordinates);
          setState(() {
            var first = addresses.first;
            _homeloc = first.addressLine;
            if (_homeloc != null) {
              latitude = _currentPosition.latitude;
              longitude = _currentPosition.longitude;

              return;
            }
          });
        }
      }).catchError((e) {
        print(e);
      });
    } catch (exception) {
      print(exception.toString());
    }
  }

  _loadMapDialog() {
    _controller = null;
    selectedsort = "Nearest Tutor";
    try {
      if (_currentPosition.latitude == null) {
        Toast.show("Current location not available. Please wait...", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _getLocation(); //_getCurrentLocation();
        return;
      }
      _controller = Completer();
      _userpos = CameraPosition(
        target: LatLng(latitude, longitude),
        zoom: 16,
      );
      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, newSetState) {
              var alheight = MediaQuery.of(context).size.height;
              var alwidth = MediaQuery.of(context).size.width;
              return AlertDialog(
                  //scrollable: true,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  title: Center(
                    child: Text("Select New Search Location",
                        style: TextStyle(color: Colors.black, fontSize: 14)),
                  ),
                  //titlePadding: EdgeInsets.all(5),
                  //content: Text(_homeloc),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          _homeloc,
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        ),
                        //Text("Latitude" + latitude.toString()),
                        //Text("Longitude" + longitude.toString()),
                        Container(
                          height: alheight - 300,
                          width: alwidth - 10,
                          child: GoogleMap(
                              mapType: MapType.normal,
                              initialCameraPosition: _userpos,
                              markers: markers.toSet(),
                              onMapCreated: (controller) {
                                _controller.complete(controller);
                              },
                              onTap: (newLatLng) {
                                _loadLoc(newLatLng, newSetState);
                              }),
                        ),
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          //minWidth: 200,
                          height: 30,
                          child: Text('Search'),
                          color: Colors.blue,
                          textColor: Colors.white,
                          elevation: 10,
                          onPressed: () => {
                            markers.clear(),
                            Navigator.of(context).pop(false),
                            _loadsearchsortTutor(
                                selectedsort, _searchcontroller.text),
                          },
                        ),
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          //minWidth: 200,
                          height: 30,
                          child: Text('Cancel'),
                          color: Colors.blue,
                          textColor: Colors.white,
                          elevation: 10,
                          onPressed: () => {
                            markers.clear(),
                            //_getLocation(),
                            Navigator.of(context).pop(false),
                          },
                        ),
                      ],
                    ),
                  ));
            },
          );
        },
      );
    } catch (e) {
      print(e);
      return;
    }
  }

  void _loadLoc(LatLng loc, newSetState) async {
    newSetState(() {
      print("insetstate");
      markers.clear();
      latitude = loc.latitude;
      longitude = loc.longitude;
      _getLocationfromlatlng(latitude, longitude, newSetState);
      _home = CameraPosition(
        target: loc,
        zoom: 16,
      );
      markers.add(Marker(
        markerId: markerId1,
        position: LatLng(latitude, longitude),
        infoWindow: InfoWindow(
          title: 'New Location',
          snippet: 'New Delivery Location',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      ));
    });
    _userpos = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 14.4746,
    );
    _newhomeLocation();
  }

  _getLocationfromlatlng(double lat, double lng, newSetState) async {
    final Geolocator geolocator = Geolocator()
      ..placemarkFromCoordinates(lat, lng);
    _currentPosition = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    //debugPrint('location: ${_currentPosition.latitude}');
    final coordinates = new Coordinates(lat, lng);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    newSetState(() {
      _homeloc = first.addressLine;
      if (_homeloc != null) {
        latitude = lat;
        longitude = lng;
        //_calculatePayment();
        return;
      }
    });
    setState(() {
      _homeloc = first.addressLine;
      if (_homeloc != null) {
        latitude = lat;
        longitude = lng;
        //calculatePayment();
        return;
      }
    });
  }

  Future<void> _newhomeLocation() async {
    gmcontroller = await _controller.future;
    gmcontroller.animateCamera(CameraUpdate.newCameraPosition(_home));
  }

  searchnewloc(String latitude, String longitude) async {
    print("Latitude" + latitude);
    print("Longitude" + longitude);
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Loading...");
    await pr.show();
    String url = "https://smileylion.com/mytutor/php/load_tutor2.php";
    await http.post(url, body: {}).then((res) {
      if (res.body == "nodata") {
        title = "No Tutor Found";
        setState(() {
          tutordata = null;
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          tutordata = extractdata["tutors"];
        });
      }
    }).catchError((err) {
      print(err);
    });
    await pr.hide();
  }
}
