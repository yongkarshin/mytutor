import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mytutor/user.dart';
import 'package:mytutor/tutor.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:mytutor/tabtutorscreen.dart';
import 'package:mytutor/tabscreen.dart';

void main() => runApp(EditProfileScreen());

class EditProfileScreen extends StatefulWidget {
  final User user;
  final Tutor tutor;
  const EditProfileScreen({Key key, this.user,this.tutor}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameCon = TextEditingController();
  final TextEditingController _phoneCon = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController pass2Controller = TextEditingController();

  double screenHeight, screenWidth;
  File _image;
  String pathAsset = 'assets/images/camera.png';
  bool updatepicture = true;
  bool postnewpicture = false;
  bool _passwordVisible = true;

  @override
  void initState() {
    super.initState();
    _nameCon.text = widget.user.name;
    _phoneCon.text = widget.user.phone;
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        backgroundColor: Color.fromRGBO(14, 30, 64, 1),
      ),
      body: Container(
        child: Padding(
            padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Container(
                    height: 115,
                    width: 115,
                    child: Stack(
                        fit: StackFit.expand,
                        overflow: Overflow.visible,
                        children: [
                          GestureDetector(
                            onTap: null, //() => {_onImageDisplay()},
                            child: Column(
                              children: [
                                Visibility(
                                    visible: updatepicture,
                                    child: Container(
                                      //color: Colors.blue,
                                      //height: 160,
                                      //width: 160,
                                       height: 115,
                                       width: 115,
                                      child: ClipOval(
                                        child: CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl:
                                              "https://smileylion.com/mytutor/images/${widget.user.picture}.jpg?",
                                          placeholder: (context, url) =>
                                              new SizedBox(
                                                  height: 10.0,
                                                  width: 10.0,
                                                  child:CircularProgressIndicator()),
                                          errorWidget:(context, url, error) {return Image(image: AssetImage("assets/images/profile.png"));}            
                                          //errorWidget: (context, url, error) =>new Icon(Icons.error, size: 64.0),
                                        ),

                                        /*child: FadeInImage.assetNetwork(
                                                        fit: BoxFit.fill,
                                                        image: "https://smileylion.com/mytutor/images/${widget.user.userid}.jpg?",
                                                        placeholder: 'assets/images/camera1.jpg',
                                                        //placeholder: (context,url){return Image(image: AssetImage("assets/images/camera.jpg"));},
                                                        //errorWidget:(context, url, error) {
                                                        //return Image(image: AssetImage("assets/images/camera.jpg"));}
                                                        imageErrorBuilder: (context,url, stackTrace) {return Image.asset('assets/images/class.png');})*/
                                      ),
                                    )),
                                Visibility(
                                  visible: postnewpicture,
                                  child: Container(
                                    //height: 160,
                                    //width: 160,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        image: new DecorationImage(
                                          image: _image == null
                                              ? AssetImage(pathAsset)
                                              : FileImage(_image),
                                          fit: BoxFit.cover,
                                        )),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Positioned(
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
                                              width: 2, color: Colors.white),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30.0)),
                                        ),
                                        height: 160,
                                        width: 160,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(300.0),
                                          child: Image.asset(
                                            "assets/images/camera3.png",
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                      ))))
                        ]),
                  ),
                  SizedBox(height: 5),
                  //Text("Click image to take photo",style: TextStyle(fontSize: 10.0, color: Colors.black)),
                  SizedBox(height: 5),
                  TextField(
                      controller: _nameCon,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Name",
                        icon: Icon(Icons.person),
                      )),
                  TextField(
                      controller: _phoneCon,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Phone",
                        icon: Icon(Icons.phone),
                      )),
                     
                  SizedBox(height: 10),
                  
                  SizedBox(height: 20),
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
                      onPressed: updateProfile),
                  
                  SizedBox(height: 10),
                ]))),
      ),
    );
  }

  _onImageSelect() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: new Container(
              height: screenHeight / 4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Take picture from:",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      )),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                          child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        minWidth: 100,
                        height: 100,
                        child: Text('Camera',
                            style: TextStyle(
                              color: Colors.white,
                            )),
                        color: Colors.blue,
                        textColor: Colors.white,
                        elevation: 10,
                        onPressed: () =>
                            {Navigator.pop(context), _chooseCamera()},
                      )),
                      SizedBox(width: 10),
                      Flexible(
                          child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        minWidth: 100,
                        height: 100,
                        child: Text('Gallery',
                            style: TextStyle(
                              color: Colors.white,
                            )),
                        color: Colors.blue,
                        textColor: Colors.white,
                        elevation: 10,
                        onPressed: () => {
                          Navigator.pop(context),
                          _chooseGallery(),
                        },
                      )),
                    ],
                  ),
                ],
              ),
            ));
      },
    );
  }

  void _chooseCamera() async {
    // ignore: deprecated_member_use
    _image = (await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 800, maxWidth: 800)) as File;
    _cropImage();
    setState(() {});
  }

  void _chooseGallery() async {
    // ignore: deprecated_member_use
    _image = (await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 800, maxWidth: 800)) as File;
    _cropImage();
    setState(() {});
  }

  Future<void> _cropImage() async {
    File croppedFile = (await ImageCropper.cropImage(
        sourcePath: _image.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
              ]
            : [
                CropAspectRatioPreset.square,
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Resize',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ))) as File;
    if (croppedFile != null) {
      _image = croppedFile;
      setState(() {
        updatepicture = false;
        postnewpicture = true;
        String base64Image = base64Encode(_image.readAsBytesSync());
        _uploadImage(base64Image);
      });
    }
  }

  void _uploadImage(String base64Image) async {
    if (_image != null) {
     //String base64Image = base64Encode(_image.readAsBytesSync());
      print(base64Image);
      await http
          .post("https://smileylion.com/mytutor/php/upload_image.php", body: {
        "encoded_string": base64Image,
        "userid": widget.user.userid,
        "email":widget.user.email,
        "role":widget.user.role,
      }).then((res) {
        print(res.body);
        if (res.body == "success") {
          setState(() {
            DefaultCacheManager manager = new DefaultCacheManager();
            manager.emptyCache();
            widget.user.picture=widget.user.userid;
          });
          Toast.show(
            "Success",
            context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM,
          );
          if(widget.user.role=="Tutor"){
            Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => TabTutorScreen(user: widget.user,tutor:widget.tutor)));
          }else{
            Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => TabScreen(user: widget.user)));
          }
          
          
          Navigator.pop(context);
        } else {
          Toast.show(
            "Failed",
            context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM,
          );
        }
      }).catchError((err) {
        print(err);
      });
    }
  }

  void updateProfile() {
    //if (_phone == "" || _phone == null || _phone.length < 9) {
    //Toast.show("Please enter your new phone number", context,
    //duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    //return;
    //}
    //String myImage = base64Encode(_image.readAsBytesSync());
    http.post("https://smileylion.com/mytutor/php/update_profile.php", body: {
      "userid": widget.user.userid,
      "name": widget.user.name,
      "phone": widget.user.phone,
      "role":widget.user.role,
    }).then((res) {
      if (res.body == "success") {
        print('success');
        setState(() {
          widget.user.name = _nameCon.text;
          widget.user.phone = _phoneCon.text;
        });
        Toast.show("Success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.of(context).pop();
        //return;
      } else {}
    }).catchError((err) {
      print(err);
    });
  }

 /*void onChangePassword() {
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
                    onPressed: ()=>updatePassword(passController.text, pass2Controller.text)),
                new FlatButton(
                  child: new Text(
                    "No",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  onPressed: () {Navigator.of(context).pop();},
                ),
              ]);
        });
  }*/

   updatePassword(String pw1, String pw2){
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


