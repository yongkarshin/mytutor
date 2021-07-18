import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mytutor/user.dart';
import 'package:mytutor/loginscreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mytutor/edittutorscreen.dart';
import 'package:mytutor/editprofilescreen.dart';
import 'package:mytutor/paymenthistoryscreen.dart';
import 'package:mytutor/tutor.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:mytutor/historyTab.dart';
import 'package:mytutor/editpasswordScreen.dart';

void main() => runApp(ProfileScreen());

class ProfileScreen extends StatefulWidget {
  final User user;
  final Tutor tutor;
  const ProfileScreen({Key key, this.user, this.tutor}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  GlobalKey<RefreshIndicatorState> refreshKey;
  double screenHeight, screenWidth;
  Future<void> _launched;
  String _phone;
  bool _isTutor = false;
  bool _isStudent = false;
  File _image;
  String pathAsset = 'assets/images/camera.png';
  bool updatepicture = true;
  bool postnewpicture = false;
  final TextEditingController passController = TextEditingController();
  final TextEditingController pass2Controller = TextEditingController();
   bool _passwordVisible = true;


  @override
  void initState() {
    super.initState();
    _loadPicture();
    
    if (widget.user.role == "Tutor") {
      _isTutor = true;
    }
    if (widget.user.role == "Student") {
      _isStudent = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        child: RefreshIndicator(
            key: refreshKey,
            onRefresh: () async {
              _loadPicture();
            },
            child: Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Card(
                          elevation: 5,
                          child: Container(
                            height: screenHeight / 3,
                            width: screenWidth,
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 10),
                                Container(
                                  height: 115,
                                  width: 115,
                                  child: Stack(
                                      fit: StackFit.expand,
                                      overflow: Overflow.visible,
                                      children: [
                                        GestureDetector(
                                          onTap: () => {_onImageDisplay()},
                                          child: Column(

                                            children: [
                                              Container(
                                                height: 115,
                                                width: 115,
                                               child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          300.0),
                                                  child: CachedNetworkImage(
                                                      fit: BoxFit.cover,
                                                      imageUrl:
                                                          "https://smileylion.com/mytutor/images/${widget.user.picture}.jpg?",
                                                      placeholder: (context,
                                                              url) =>
                                                          new SizedBox(
                                                              height: 10.0,
                                                              width: 10.0,
                                                              child:
                                                                  CircularProgressIndicator()),
                                                      errorWidget: (context,
                                                          url, error) {
                                                        return Image(
                                                            image: AssetImage(
                                                                "assets/images/profile.png"));
                                                      }
                                                      //errorWidget: (context, url,error) =>new Icon(Icons.error,size: 64.0),
                                                      ),
                                                ),
                                                  
                                                  
                                                
                                              ),
                                              /*Visibility(
                                                              visible: postnewpicture,
                                                              child: Container(
                                                                //height: 160,
                                                                //width: 160,
              
                                                                decoration: BoxDecoration(
                                                                    color: Colors.red,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            30.0),
                                                                    image:
                                                                        new DecorationImage(
                                                                      image: _image == null
                                                                          ? AssetImage(
                                                                              pathAsset)
                                                                          : FileImage(_image),
                                                                      fit: BoxFit.cover,
                                                                    )),
                                                              ),
                                                            )*/
                                            ],
                                          ),
                                        ),
                                        /*Positioned(
                                                      right: -16,
                                                      bottom: 0,
                                                      child: Container(
                                                          height: 46,
                                                          width: 46,
                                                          child: GestureDetector(
                                                              onTap: () {
                                                                _onImageSelect();
                                                              },
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                  color: Colors.grey[100],
                                                                  border: Border.all(
                                                                      width: 2,
                                                                      color: Colors.white),
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              30.0)),
                                                                ),
                                                                height: 160,
                                                                width: 160,
                                                                child: ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          300.0),
                                                                  child: Image.asset(
                                                                    "assets/images/camera3.png",
                                                                    fit: BoxFit.fitWidth,
                                                                  ),
                                                                ),
                                                              ))))*/
                                      ]),
                                ),
                                SizedBox(height: 10),

                                /*Text(widget.user.picture,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold)),*/
                                
                                Text(widget.user.name,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                Text(widget.user.email,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    )),
                                Text(widget.user.phone,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    )),
                                SizedBox(
                                  height: 2,
                                ),
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Card(
                        elevation: 10,
                        child: Container(
                            width: screenWidth,
                            child: Column(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    onEditProfile();
                                  },
                                  child: Container(
                                    width: screenWidth,
                                    height: 50,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(30, 10, 30, 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Wrap(
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.person,
                                                size: 20,
                                              ),
                                              SizedBox(width: 10),
                                              Text("My Personal Details",
                                                  style:
                                                      TextStyle(fontSize: 20)),
                                            ],
                                          ),
                                          //Icon(Icons.person),
                                          //Text("Edit Profile",style: TextStyle(fontSize: 18),),
                                          Icon(Icons.arrow_forward),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Divider(),
                                GestureDetector(
                                  onTap: () {
                                    onEditPw();
                                  },
                                  child: Container(
                                    width: screenWidth,
                                    height: 50,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(30, 10, 30, 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Wrap(
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.lock_open,
                                                size: 20,
                                              ),
                                              SizedBox(width: 10),
                                              Text("Change my Password",
                                                  style:
                                                      TextStyle(fontSize: 20)),
                                            ],
                                          ),
                                          //Icon(Icons.person),
                                          //Text("Edit Profile",style: TextStyle(fontSize: 18),),
                                          Icon(Icons.arrow_forward),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Divider(),
                                Visibility(
                                  visible: _isTutor,
                                  child: GestureDetector(
                                    onTap: () {
                                      onEditTutor();
                                    },
                                    child: Container(
                                      width: screenWidth,
                                      height: 50,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(30, 10, 30, 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Wrap(
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.person_add,
                                                  size: 20,
                                                ),
                                                SizedBox(width: 10),
                                                Text("My Tutor Details",
                                                    style: TextStyle(
                                                        fontSize: 20)),
                                              ],
                                            ),
                                            Icon(Icons.arrow_forward),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: _isStudent,
                                  child: GestureDetector(
                                    onTap: () {
                                      onHistory();
                                    },
                                    child: Container(
                                      width: screenWidth,
                                      height: 50,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(30, 10, 30, 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Wrap(
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.book,
                                                  size: 20,
                                                ),
                                                SizedBox(width: 10),
                                                Text("My Class History",
                                                    style: TextStyle(
                                                        fontSize: 20)),
                                              ],
                                            ),
                                            Icon(Icons.arrow_forward),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                //Divider(),
                               /* GestureDetector(
                                  onTap: () {
                                    onChangePassword();
                                  },
                                  child: Container(
                                    width: screenWidth,
                                    height: 50,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(30, 10, 30, 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Wrap(
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.lock,
                                                size: 20,
                                              ),
                                              SizedBox(width: 10),
                                              Text("Security",
                                                  style:
                                                      TextStyle(fontSize: 20)),
                                            ],
                                          ),
                                          //Icon(Icons.person),
                                          //Text("Edit Profile",style: TextStyle(fontSize: 18),),
                                          Icon(Icons.arrow_forward),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),*/
                                Divider(),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "     Contact us",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Divider(),
                                GestureDetector(
                                  onTap: () => setState(() {
                                    _launched = _makePhoneCall('tel:042212899');
                                  }),
                                  child: Container(
                                    width: screenWidth,
                                    height: 50,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(30, 10, 30, 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Wrap(
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.phone,
                                                size: 20,
                                              ),
                                              SizedBox(width: 10),
                                              Text("04 2212 899",
                                                  style:
                                                      TextStyle(fontSize: 20)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => setState(() {
                                    launch(_emailLaunchUri.toString());
                                  }),
                                  child: Container(
                                    width: screenWidth,
                                    height: 50,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(30, 10, 30, 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Wrap(
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.email,
                                                size: 20,
                                              ),
                                              SizedBox(width: 10),
                                              Text("help@mytutor.com",
                                                  style:
                                                      TextStyle(fontSize: 20)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Card(
                        elevation: 10,
                        child: Container(
                            width: screenWidth,
                            child: Column(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    logout();
                                  },
                                  child: Container(
                                    width: screenWidth,
                                    height: 50,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(30, 10, 30, 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Wrap(
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.directions_run,
                                                size: 20,
                                              ),
                                              SizedBox(width: 10),
                                              Text("Log Out",
                                                  style:
                                                      TextStyle(fontSize: 20)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      )
                    ],
                  ),
                ))),
      ),
    );
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'help@myTutor.com',
      queryParameters: {'subject': 'Help myTutor'});

  void logout() {
    print(widget.user.name);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Log Out?",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginScreen()));
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

  void _onImageDisplay() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: new Container(
              color: Colors.white,
              height: screenHeight / 2.2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: screenWidth / 1.5,
                    width: screenWidth / 1.5,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                    ),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl:
                          "https://smileylion.com/mytutor/images/${widget.user.picture}.jpg?",
                      placeholder: (context, url) => new SizedBox(
                          height: 10.0,
                          width: 10.0,
                          child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          new Icon(Icons.error, size: 64.0),
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  }

  void onEditTutor() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => EditTutorScreen(
                  user: widget.user,
                  tutor: widget.tutor,
                )));
  }

  void onEditPw(){
    Navigator.push(context, MaterialPageRoute(
      builder: (BuildContext context)=>EditPasswordScreen(
        user:widget.user,
      )));
  }
  void onEditProfile() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                EditProfileScreen(user: widget.user, tutor: widget.tutor)));
  }

  void onHistory() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => PaymentHistoryScreen(
                  user:widget.user,
                )));
  }

  void _loadPicture() {
    CachedNetworkImage(
      fit: BoxFit.cover,
      imageUrl:
          "https://smileylion.com/mytutor/images/${widget.user.picture}.jpg?",
      placeholder: (context, url) => new SizedBox(
          height: 10.0, width: 10.0, child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => new Icon(Icons.error, size: 64.0),
    );
  }

  void onChangePassword() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: new Text(
                "Change your password?",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              content: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: passController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: 'Old Password',
                        icon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(context).primaryColorLight,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        )),
                    obscureText: _passwordVisible,
                  ),
                  TextField(
                    controller: pass2Controller,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: 'New Password',
                        icon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(context).primaryColorLight,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        )),
                    obscureText: _passwordVisible,
                  ),
                ],
              ),
              actions: <Widget>[
                new FlatButton(
                    child: new Text(
                      "Yes",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    //onPressed: null,
                    onPressed: () => updatePassword(
                        passController.text, pass2Controller.text)),
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
              ]);
        });
  }

  updatePassword(String pw1, String pw2) {
    if (pw1 == "" || pw2 == "") {
      Toast.show("Please enter your password", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    http.post("https://smileylion.com/mytutor/php/update_profile.php", body: {
      "userid": widget.user.userid,
      "oldpassword": pw1,
      "newpassword": pw2,
    }).then((res) {
      if (res.body == "success") {
        print('in success');
        setState(() {
          widget.user.password = pw2;
        });
        Toast.show("Success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.of(context).pop();
        return;
      } else {}
    }).catchError((err) {
      print(err);
    });
  }
}
