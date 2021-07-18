import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:mytutor/tabscreen.dart';
import 'package:toast/toast.dart';
import 'package:random_string/random_string.dart';
import 'package:mytutor/loginscreen.dart';
import 'package:mytutor/registerstudentscreen.dart';

void main() => runApp(RegisterTutorScreen());

class RegisterTutorScreen extends StatefulWidget {
  @override
  _RegisterTutorScreenState createState() => _RegisterTutorScreenState();
}

class _RegisterTutorScreenState extends State<RegisterTutorScreen> {
  double screenHeight, screenWidth;
  TextEditingController _nameEditingController = new TextEditingController();
  TextEditingController _emailEditingController = new TextEditingController();
  TextEditingController _passEditingController = new TextEditingController();
  TextEditingController _phoneEditingController = new TextEditingController();
  final focus = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  bool _passwordVisible = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: _onBackPress,
      child: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
              title: Text('Registration Tutor'),
              backgroundColor: Color.fromRGBO(14, 30, 64, 1)),
          body: Stack(
            children: <Widget>[
              upperPart(context),
              lowerPart(context),
            ],
          )),
    );
  }

  Future<bool> _onBackPress() async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
    return Future.value(false);
  }

  Widget upperPart(BuildContext context) {
    return Container(
      height: screenHeight / 1,
      child: Image.asset(
        'assets/images/loginsc.png',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget lowerPart(BuildContext context) {
    return Container(
      //height: screenHeight / 2,
      margin: EdgeInsets.only(top: screenHeight / 7),
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Card(
        elevation: 10,
        child: Container(
          padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(2),
            children: <Widget>[
              SizedBox(height: 5),
              TextFormField(
                style: TextStyle(
                  color: Colors.blue,
                ),
                controller: _nameEditingController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (v) {
                  FocusScope.of(context).requestFocus(focus);
                },
                decoration: InputDecoration(
                  labelText: 'Name',
                  icon: Icon(Icons.person),
                ),
              ),
              TextFormField(
                style: TextStyle(
                  color: Colors.blue,
                ),
                controller: _emailEditingController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                focusNode: focus,
                onFieldSubmitted: (v) {
                  FocusScope.of(context).requestFocus(focus1);
                },
                decoration: InputDecoration(
                  labelText: 'Email',
                  icon: Icon(Icons.email),
                ),
              ),
              TextFormField(
                style: TextStyle(
                  color: Colors.blue,
                ),
                controller: _phoneEditingController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                focusNode: focus1,
                onFieldSubmitted: (v) {
                  FocusScope.of(context).requestFocus(focus2);
                },
                decoration: InputDecoration(
                  labelText: 'Phone',
                  icon: Icon(Icons.phone),
                ),
              ),
              TextFormField(
                style: TextStyle(
                  color: Colors.blue,
                ),
                controller: _passEditingController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                focusNode: focus2,
                onFieldSubmitted: (v) {
                  FocusScope.of(context).requestFocus(focus3);
                },
                decoration: InputDecoration(
                    labelText: 'Password',
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
              SizedBox(height:5),
              Text("*Password should be more than 8 characters long. It should contain at least one Uppercase ( Capital ) letter, at least one lowercase character, at least digit and special character."
              ,style: TextStyle(fontSize: 12),
              textAlign: TextAlign.justify,),
              SizedBox(height:10),
              MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      minWidth: 300,
                      height: 50,
                      child: Text('Register',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )),
                      color: Color.fromRGBO(14, 30, 64, 1),
                      //textColor: Colors.blue,
                      elevation: 10,
                      onPressed: () {
                        onRegister();
                      }),
              
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Already register?  ",
                    style: TextStyle(
                        fontSize: 16, color: Color.fromRGBO(14, 30, 64, 1)),
                  ),
                  GestureDetector(
                      onTap: _loginScreen,
                      child: Text(
                        "Login",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(14, 30, 64, 1)),
                      ))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Register as Student?  ",
                    style: TextStyle(
                        fontSize: 16, color: Color.fromRGBO(14, 30, 64, 1)),
                  ),
                  GestureDetector(
                      onTap: _registerstudent,
                      child: Text(
                        "Student",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(14, 30, 64, 1)),
                      ))
                ],
              )

            ],
          ),
        ),
      ),
    );
  }

  void _loginScreen() {
    Navigator.pop(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
  }
  void _registerstudent() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>RegisterStudentScreen()));
  }

  void onRegister() {
    String name = _nameEditingController.text;
    String email = _emailEditingController.text;
    String phone = _phoneEditingController.text;
    String password = _passEditingController.text;

    if (name.length <=4) {
      Toast.show("The length of name do not less than 5", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (phone.length <=9) {
      Toast.show("The length of phone do not less than 9", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    print(validateEmail(email));
    if (validateEmail(email)==false) {
      Toast.show("The email is not available", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    if (!isPasswordCompliant(password)) {
      Toast.show(
          "Password should be more than 8 characters long. It should contain at least one Uppercase ( Capital ) letter, at least one lowercase character, at least digit and special character.",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP);
      return;
    }

    print(isPasswordCompliant(password));

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            title: Text("Register?", style: TextStyle(color: Colors.black)),
            content: Text(
              "Are you sure?",
              style: TextStyle(color: Colors.black),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text(
                  "Yes",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  registerUser();
                },
              ),
              new FlatButton(
                child: new Text(
                  "No",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
  String generateUserid(){
    String userid= randomNumeric(6);
    return userid;
  }

  Future<void> registerUser() async {
    String name = _nameEditingController.text;
    String email = _emailEditingController.text;
    String phone = _phoneEditingController.text;
    String password = _passEditingController.text;
    String role ="Tutor";

    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Registration loading...");
    await pr.show();
    
    ////https://smileylion.com/mytutor/php/PHPMailer-master/register.php
    ///https://smileylion.com/mytutor/php/register.php
    http.post("https://smileylion.com/mytutor/php/register_user.php", body: {
      "userid": generateUserid(),
      "name": name,
      "email": email,
      "phone": phone,
      "password": password,
      "role": role,
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Navigator.pop(context);
        //Navigator.pop(context,MaterialPageRoute(builder: (BuildContext context) => TabScreen()));
        //Toast.show("Registration succes. An email has been sent to .$email.Please check your email for OTP verification. Also check in your spam folder.", context,
            //duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Toast.show("Successful Register, Please login go to Account >> MyTutor Details update to active your tutor account.",context,duration:Toast.LENGTH_LONG,gravity: Toast.BOTTOM);
      } 
      else if(res.body == "found"){
        Toast.show("This email is registered.", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
      else {
        Toast.show("Failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
    });
    await pr.hide();
  }

  bool validateEmail(String value){
    Pattern pattern=r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regexp=new RegExp(pattern);
    return (!regexp.hasMatch(value))?false:true;
 }

  /*bool validatePassword(String value){
    String pattern= r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
    RegExp regexp=new RegExp(pattern);
    return regexp.hasMatch(value);
  }*/

  bool isPasswordCompliant(String password,[int minLength=6]){
  if(password==null || password.isEmpty){
  return false;
  }
  bool hasUppercase = password.contains(new RegExp(r'[A-Z]'));
  bool hasDigits=password.contains(new RegExp(r'[0-9]'));
  bool hasLowerCase=password.contains(new RegExp(r'[a-z]'));
  bool hasSpecialCharacters = password.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  bool hasMinLength = password.length >= minLength;

  return hasDigits & hasUppercase & hasLowerCase & hasSpecialCharacters & hasMinLength;
  }
}
