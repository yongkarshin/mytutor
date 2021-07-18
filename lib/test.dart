
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:mytutor/filterItem.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:toast/toast.dart';


void main() => runApp(TestScreen());

class TestScreen extends StatefulWidget {
  
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final String apiURL="https://smileylion.com/mytutor/php/example.php";
  double screenHeight, screenWidth;
  TextEditingController _min = new TextEditingController();
  TextEditingController _max = new TextEditingController();
  List<String> _value = [
    'Tutors House',
    'Students House',
    'Neutral Location',
    'Online Tutoring'
  ];
  Map<String,bool> values={
    "English":false,
    "Malay":false,
    "Mandarin":false,
    "Tamil":false,
  };
  var tmpArray=[];
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
  TextEditingController addressController = TextEditingController();

  //List<String> _value1 = ['尊贵旗舰', '移动工作站', '高清游戏', '炒股理财', '30876.G18'];
  
  bool _isHideValue1 = true;
  bool _isHideValue2 = false;
  bool _isHideValue3 = true;
  bool _isHideValue4 = false;
  bool _isHideValue5 = false;
  bool _isHidePrimary = false;
  bool _isHideSeconadary = false;

  bool _isSelected1 = false;
  bool _isSelected2 = false;
  bool _isSelected3 = false;
  bool _isSelected4 = false;
  
  bool _visible=false;

  var myColor=Colors.white;

  @override
  void initState(){
    super.initState();
    _selectedItems.clear();
    _getLocation();
    addressController.text=_homeloc;
  }
  
  
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        key: _scaffoldKey,
        //appBar: AppBar(title:Text("Apply Item Filter on JSON ListView")),
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
                              padding: EdgeInsets.only(
                                  left: 6, top: 6, right: 25, bottom: 6),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Search Filter",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )),
                          //Divider(),
                          //_filter(),
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
                            onTap: ()=>updateReset(),
                            ),
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
                            onTap: null,
                            //()=>_filterItem(_selectedItems),
                            ),
                            
                          ],
                        )),
                    SizedBox(height: 10),
                  ],
                ))),
        body: Container(
          decoration: BoxDecoration(
            gradient : LinearGradient(
              /*stops: [
                0.1,
                0.4,
                0.6,
                0.9,
              ],*/
              colors:[
                Colors.blue,
                //Colors.pink,
                Colors.cyan,
              //Colors.yellow,
                //Colors.red,
                //Colors.indigo,
                //Colors.teal,
              
            ],begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            )
          ),
          width: screenWidth,
          //color: Colors.purpleAccent[200],
          child: Column(
            children: <Widget>[
              TextField(
                controller: addressController,
                 decoration: InputDecoration(
    border: OutlineInputBorder(),
    hintText: 'Enter a search term'
  ),

              ),

              GestureDetector(
                child: Text("Set/Change Location",
                style: TextStyle(color: Colors.white,
                fontWeight: FontWeight.bold)),
                onTap: ()=>{
                  _loadMapDialog(),
                }
                ,
              ),
              Text(_homeloc,
                style: TextStyle(color: Colors.white,
                fontWeight: FontWeight.bold)),
              Text("Latitude  "+ latitude.toString()),
              Text("Longitude   "+ longitude.toString()),
              Stack(children: [
          /*GlassmorphicContainer(
      height: 130,
      blur: 3,
      shadowStrength: 10,
      opacity: 0.2,
      width: 230,
      //this below code to remove border
      border: Border.fromBorderSide(BorderSide.none),
      borderRadius: BorderRadius.circular(10),
      child: Center(child: Text("Glass Container"),),
),   */   
          IconButton(
              icon: Icon(Icons.menu, color: Colors.blue),
              onPressed: () {
                _scaffoldKey.currentState.openEndDrawer();
              })
        ]),
        
        
            ],
          ),
        )
        
        
        );
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
          var addresses =await Geocoder.local.findAddressesFromCoordinates(coordinates);
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
  // Method for retrieving the address


    _loadMapDialog() {
    _controller = null;
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
                    child: Text("Select New Delivery Location",
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
                        Text("Latitude"+ latitude.toString()),
                        Text("Longitude"+ longitude.toString()),
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
                          child: Text('Close'),
                          color: Colors.red,
                          textColor: Colors.white,
                          elevation: 10,
                          onPressed: () => {
                            markers.clear(),
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

  
 

  void updateReset(){
    setState(() {
      _isSelected1=false;
      _isSelected2=false;
      _isSelected3=false;
      _isSelected4=false;
    });
      _selectedItems.clear();
      print(_selectedItems);
    
  }
  Future<void> _filterItem(List<String>keyword)async{
    print(keyword);
    ProgressDialog pr=ProgressDialog(context,type:ProgressDialogType.Normal,isDismissible:false);
    pr.style(message:"Loading...");
    await pr.show();
    http.post("https://smileylion.com/mytutor/php/load_tutor.php",
    body: {
      "keyword":keyword,
    }).then((res){
      if(res.body=="nodata"){
         //tutordata = null;
         setState(() {
           print("No Tutor Found");
         });
      }else{
        setState(() {
          //var extractdata=json.decode(res.body);
          //tutordata = extractdata["tutors"];
          
        });
      }
    }).catchError((err){
      print(err);
    });
    await pr.hide();
    
  }
  /*Widget _typeGridWidget(List<String> items, {double childAspectRatio = 3.0}) {
    return GridView.count(
        primary: false,
        shrinkWrap: true,
        crossAxisCount: 2,
        mainAxisSpacing: 5.0,
        crossAxisSpacing: 5.0,
        childAspectRatio: childAspectRatio,
        padding: EdgeInsets.only(left: 5, right: 5, top: 5),
        
        //    padding: EdgeInsets.all(6),
        children: items.map((value) {
          return InkWell(
            onTap: (){
              setState(() {
                _isSelected=!_isSelected;
                //widget.isSelected(_isSelected);
              });
            },
             child: Container(
                decoration: BoxDecoration(
                    color:_isSelected ? Colors.blue : Colors.red,
                    borderRadius: BorderRadius.circular(5.0)),
                child: Center(
                    child: Text(value,
                        style:
                            TextStyle(color: Colors.black, fontSize: 14.0)))),
          );
           
          
        }).toList());
  }*/

  Widget _filter1() {
    return Container(
        child: Column(
      children: <Widget>[
        Row(children: <Widget>[
          SizedBox(
            width: 6,
          ),
          Expanded(
            child: Text('Lesson Location',
                style: TextStyle(fontSize: 15, color: Colors.black)),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _isHideValue1 = !_isHideValue1;
              });
            },
            child: Icon(
              _isHideValue1
                  ? Icons.keyboard_arrow_down
                  : Icons.keyboard_arrow_up,
              color: Colors.grey,
            ),
          ),
          SizedBox(
            width: 6,
          ),
        ]),
        //_typeGridWidget(_value),
        Visibility(
            visible: _isHideValue1,
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Column(children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      width: screenWidth / 3,
                      child: FlatButton(
                         color: _isSelected1?Colors.grey[300] :Colors.grey[100],
                          onPressed: (){
                              setState((){
                              if(!_isSelected1){
                                _selectedItems.add("Tutor's House");
                                _isSelected1=true;
                                //myColor=Colors.blue;
                              }else{
                                _selectedItems.remove("Tutor's House");
                                _isSelected1=false;
                                //myColor=Colors.red;
                              }
                              
                             print(_selectedItems);
                            });
                            
                          },
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            // Replace with a Row for horizontal icon + text
                            children: <Widget>[
                              Text(
                                "Tutor's House",
                                style: TextStyle(color: Colors.black),
                              )
                            ],
                          )),
                    ),
                    Container(
                      width: screenWidth / 3,
                      child: FlatButton(
                          color: _isSelected2?Colors.grey[300] :Colors.grey[100],
                          onPressed: (){
                              setState((){
                              if(!_isSelected2){
                                _selectedItems.add("Student's House");
                                _isSelected2=true;
                                //myColor=Colors.blue;
                              }else{
                                _selectedItems.remove("Student's House");
                                _isSelected2=false;
                                //myColor=Colors.red;
                              }
                              
                             print(_selectedItems);
                            });
                            
                          },
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            // Replace with a Row for horizontal icon + text
                            children: <Widget>[
                              Text(
                                "Student's House",
                                style: TextStyle(color: Colors.black),
                              )
                            ],
                          )),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      width: screenWidth / 3,
                      child: FlatButton(
                          color: _isSelected3?Colors.grey[300] :Colors.grey[100],
                          onPressed: (){

                            setState((){
                              if(!_isSelected3){
                                _selectedItems.add("Neutral Location");
                                _isSelected3=true;
                                //myColor=Colors.blue;
                              }else{
                                _selectedItems.remove("Neutral Location");
                                _isSelected3=false;
                                //myColor=Colors.red;
                              }
                              
                             print(_selectedItems);
                            });
                            
                          },
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            // Replace with a Row for horizontal icon + text
                            children: <Widget>[
                              Text(
                                "Neutral Location",
                                style: TextStyle(color: Colors.black),
                              )
                            ],
                          )),
                    ),
                    Container(
                      width: screenWidth / 3,
                      child: FlatButton(
                          color: _isSelected4?Colors.grey[300] :Colors.grey[100],
                          onPressed: (){
                            setState((){
                              if(!_isSelected4){
                                _selectedItems.add("Online Tutoring");
                                _isSelected4=true;
                                //myColor=Colors.blue;
                              }else{
                                _selectedItems.remove("Online Tutoring");
                                _isSelected4=false;
                                //myColor=Colors.red;
                              }
                              
                             print(_selectedItems);
                            });
                            
                          },
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            // Replace with a Row for horizontal icon + text
                            children: <Widget>[
                              Text(
                                "Online Tutoring",
                                style: TextStyle(color: Colors.black),
                              )
                            ],
                          )),
                    ),
                  ],
                )
              ]),
            ))
      ],
    ));
  }
  getCheckboxItems(){
    values.forEach((key, value) {
      if(value==true){
        tmpArray.add(key);
      }
    });
    print(tmpArray);
    tmpArray.clear();
  }

  Widget _filter2() {
    return Container(
        child: Column(
      children: <Widget>[
        Row(children: <Widget>[
          SizedBox(
            width: 6,
          ),
          Expanded(
            child: Text('Taught Languages',
                style: TextStyle(fontSize: 15, color: Colors.black)),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _isHideValue2 = !_isHideValue2;
              });
            },
            child: Icon(
              _isHideValue2
                  ? Icons.keyboard_arrow_down
                  : Icons.keyboard_arrow_up,
              color: Colors.grey,
            ),
          ),
          SizedBox(
            width: 6,
          ),
        ]),
        //_typeGridWidget(_value),
        Visibility(
            visible: _isHideValue2,
            child: Column(
              children: <Widget>[
                Container(
              child:Padding(
                padding:const EdgeInsets.all(16.0),
                child:Text("Offers",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                )
              )
            ),
            Wrap(
              direction:Axis.horizontal,
              spacing:10.0,
                  runSpacing:5.0,
                  children: <Widget>[
                    myChips("Sales"),
                    myChips("Discounts"),
                    myChips("Clearance"),
                    myChips("gifts"),
                    myChips("summersale"),
                  ],
            ),
            Divider(),
              ],
            )
            
            
              
              /*Column(children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      width: screenWidth / 3,
                      child: FlatButton(
                          onPressed: null,
                          color: Colors.grey,
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            // Replace with a Row for horizontal icon + text
                            children: <Widget>[
                              Text(
                                "English",
                                style: TextStyle(color: Colors.black),
                              )
                            ],
                          )),
                    ),
                    Container(
                      width: screenWidth / 3,
                      child: FlatButton(
                          onPressed: () => Null,
                          color: Colors.grey,
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            // Replace with a Row for horizontal icon + text
                            children: <Widget>[
                              Text(
                                "Malay",
                                style: TextStyle(color: Colors.black),
                              )
                            ],
                          )),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      width: screenWidth / 3,
                      child: FlatButton(
                          onPressed: () => Null,
                          color: Colors.grey,
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            // Replace with a Row for horizontal icon + text
                            children: <Widget>[
                              Text(
                                "Mandarin Chinese",
                                style: TextStyle(color: Colors.black),
                              )
                            ],
                          )),
                    ),
                    Container(
                      width: screenWidth / 3,
                      child: FlatButton(
                          onPressed: () => Null,
                          color: Colors.grey,
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            // Replace with a Row for horizontal icon + text
                            children: <Widget>[
                              Text(
                                "Tamil",
                                style: TextStyle(color: Colors.black),
                              )
                            ],
                          )),
                    ),
                  ],
                )
              ]),*/
            )
      ],
    ));
  }
  Container myChips(String chipName) {
    return Container(
          child: RaisedButton(
            color: Color(0xffededed),
              child: Text(chipName,
                style:TextStyle(
                  color: new Color(0xff6200ee),
                ),),
              onPressed: () {
                
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      30.0))
          ),
    );
  }

  /*void toggleSelection(){
    setState(() {
      if(_isSelected){
        myColor=Colors.white;
        _isSelected=false;
      }else{
        myColor=Colors.grey[300];
        _isSelected=true;
      }
    });
  }*/
  Widget _filter3() {
    return Container(
        child: Column(
      children: <Widget>[
        Row(children: <Widget>[
          SizedBox(
            width: 6,
          ),
          Expanded(
            child: Text('Price Range (RM)',
                style: TextStyle(fontSize: 15, color: Colors.black)),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _isHideValue3 = !_isHideValue3;
              });
            },
            child: Icon(
              _isHideValue3
                  ? Icons.keyboard_arrow_down
                  : Icons.keyboard_arrow_up,
              color: Colors.grey,
            ),
          ),
          SizedBox(
            width: 6,
          ),
        ]),
        //_typeGridWidget(_value),
        Visibility(
            visible: _isHideValue3,
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Column(children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      color: Colors.grey[100],
                      constraints: BoxConstraints(
                        maxHeight: 25,
                        maxWidth: screenWidth / 4,
                      ),
                      //margin: EdgeInsets.only(left: 6, right: 6),
                      child: TextField(
                        controller: _min,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10, right: 10),
                          hintText: 'Min',
                          //filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Container(
                      width: 20,
                      height: 1,
                      color: Colors.grey[500],
                    ),
                    Container(
                      color: Colors.grey[100],
                      constraints: BoxConstraints(
                        maxHeight: 25,
                        maxWidth: screenWidth / 4,
                      ),
                      //margin: EdgeInsets.only(left: 6, right: 6),
                      child: TextField(
                        controller: _max,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10, right: 10),
                          hintText: 'Max',
                          //filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                
              ]),
            ))
      ],
    ));
  }

  Widget _filter4() {
    return Container(
        child: Column(
      children: <Widget>[
        Row(children: <Widget>[
          SizedBox(
            width: 6,
          ),
          Expanded(
            child: Text('Subject Taught',
                style: TextStyle(fontSize: 15, color: Colors.black)),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _isHideValue4 = !_isHideValue4;
              });
            },
            child: Icon(
              _isHideValue4
                  ? Icons.keyboard_arrow_down
                  : Icons.keyboard_arrow_up,
              color: Colors.grey,
            ),
          ),
          SizedBox(
            width: 6,
          ),
        ]),
        //_typeGridWidget(_value),
        Visibility(
            visible: _isHideValue4,
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Column(
                children: <Widget>[

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      width: screenWidth / 3,
                      child: FlatButton(
                          onPressed: () => Null,
                          color: Colors.grey,
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            // Replace with a Row for horizontal icon + text
                            children: <Widget>[
                              Text(
                                "English",
                                style: TextStyle(color: Colors.black),
                              )
                            ],
                          )),
                    ),
                    Container(
                      width: screenWidth / 3,
                      child: FlatButton(
                          onPressed: () => Null,
                          color: Colors.grey,
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            // Replace with a Row for horizontal icon + text
                            children: <Widget>[
                              Text(
                                "Malay",
                                style: TextStyle(color: Colors.black),
                              )
                            ],
                          )),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      width: screenWidth / 3,
                      child: FlatButton(
                          onPressed: () => Null,
                          color: Colors.grey,
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            // Replace with a Row for horizontal icon + text
                            children: <Widget>[
                              Text(
                                "Mandarin Chinese",
                                style: TextStyle(color: Colors.black),
                              )
                            ],
                          )),
                    ),
                    Container(
                      width: screenWidth / 3,
                      child: FlatButton(
                          onPressed: () => Null,
                          color: Colors.grey,
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            // Replace with a Row for horizontal icon + text
                            children: <Widget>[
                              Text(
                                "Hindi",
                                style: TextStyle(color: Colors.black),
                              )
                            ],
                          )),
                    ),
                  ],
                )
              ]),
            ))
      ],
    ));
  }

  Widget _filter5() {
    return Container(
        child: Column(
      children: <Widget>[
        Row(children: <Widget>[
          SizedBox(
            width: 6,
          ),
          Expanded(
            child: Text('Syllabus',
                style: TextStyle(fontSize: 15, color: Colors.black)),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _isHideValue5 = !_isHideValue5;
              });
            },
            child: Icon(
              _isHideValue5
                  ? Icons.keyboard_arrow_down
                  : Icons.keyboard_arrow_up,
              color: Colors.grey,
            ),
          ),
          SizedBox(
            width: 6,
          ),
        ]),
        //_typeGridWidget(_value),
        Visibility(
            visible: _isHideValue5,
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Column(children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      width: screenWidth / 3,
                      child: FlatButton(
                          onPressed: () => Null,
                          color: Colors.grey,
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            // Replace with a Row for horizontal icon + text
                            children: <Widget>[
                              Text(
                                "English",
                                style: TextStyle(color: Colors.black),
                              )
                            ],
                          )),
                    ),
                    Container(
                      width: screenWidth / 3,
                      child: FlatButton(
                          onPressed: () => Null,
                          color: Colors.grey,
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            // Replace with a Row for horizontal icon + text
                            children: <Widget>[
                              Text(
                                "Malay",
                                style: TextStyle(color: Colors.black),
                              )
                            ],
                          )),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      width: screenWidth / 3,
                      child: FlatButton(
                          onPressed: () => Null,
                          color: Colors.grey,
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            // Replace with a Row for horizontal icon + text
                            children: <Widget>[
                              Text(
                                "Mandarin Chinese",
                                style: TextStyle(color: Colors.black),
                              )
                            ],
                          )),
                    ),
                    Container(
                      width: screenWidth / 3,
                      child: FlatButton(
                          onPressed: () => Null,
                          color: Colors.grey,
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            // Replace with a Row for horizontal icon + text
                            children: <Widget>[
                              Text(
                                "Hindi",
                                style: TextStyle(color: Colors.black),
                              )
                            ],
                          )),
                    ),
                  ],
                )
              ]),
            ))
      ],
    ));
  }
  /*Widget _buildGroup() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            SizedBox(
              width: 6,
            ),
            Expanded(
              child: Text('Filter by Lesson Location',
                  style: TextStyle(fontSize: 14, color: Color(0xFF6a6a6a))),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isHideValue1 = !_isHideValue1;
                });
              },
              child: Icon(
                _isHideValue1
                    ? Icons.keyboard_arrow_down
                    : Icons.keyboard_arrow_up,
                color: Colors.grey,
              ),
            ),
            SizedBox(
              width: 6,
            ),
          ],
        ),
        _typeGridWidget(_value),
        Offstage(
          offstage: _isHideValue1,
          child: _typeGridWidget(_value1),
        ),
        Container(
            margin: EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
                //      color: Colors.red,
                border:
                    Border(bottom: BorderSide(width: 1, color: Colors.grey)))),
      ],
    );
  }*/

 
}


