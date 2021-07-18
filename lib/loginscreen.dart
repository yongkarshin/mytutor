import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mytutor/registerstudentscreen.dart';
import 'package:mytutor/registertutorscreen.dart';
import 'package:mytutor/tabtutorscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:mytutor/user.dart';
import 'package:mytutor/tabscreen.dart';
import 'package:mytutor/tutor.dart';
import 'package:mytutor/resetpasswordscreen.dart';

void main() => runApp(LoginScreen());

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  double screenHeight, screenWidth;
  TextEditingController _emailEditingController = new TextEditingController();
  TextEditingController _passEditingController = new TextEditingController();
  
  bool _rememberMe = false;
  //String urlLogin = "https://smileylion.com/mytutor/php/login_user1.php";
  bool _passwordVisible = true;
  bool _tutor = true;
  bool _student = false;
  String _role = "Tutor";

  @override
  void initState() {
    super.initState();
    loadpref();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
            title: Text('Login'),
            backgroundColor: Color.fromRGBO(14, 30, 64, 1)),
        body: Stack(children: <Widget>[
          upperPart(context),
          lowerPart(context),
        ]),
      ),
    );
  }

  Widget upperPart(BuildContext context) {
    return Container(
        child: Image.asset(
      'assets/images/loginsc.png',
      fit: BoxFit.fitHeight,
    ));
  }

  Widget lowerPart(BuildContext context) {
    return Container(
        height: screenHeight / 1,
        margin: EdgeInsets.only(top: screenHeight / 12),
        child: Column(
          children: <Widget>[
            Card(
              elevation: 10,
              child: Container(
                padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                child: Column(children: <Widget>[
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text("Welcome",
                          style: TextStyle(
                            color: Color.fromRGBO(14, 30, 64, 1),
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                          ))),
                  Align(
                      alignment: Alignment.topCenter,
                      child: Text("Login as:",
                          style: TextStyle(
                            color: Color.fromRGBO(14, 30, 64, 1),
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ))),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        width: 110,
                        height: 110,
                        child: GestureDetector(
                          onTap: null,
                          child: Stack(
                            children: <Widget>[
                              FittedBox(
                                fit: BoxFit.fill,
                                child: ClipRRect(
                                    child: Container(
                                        width: 90,
                                        height: 90,
                                        child: Card(
                                          elevation: 5.0,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              side: BorderSide(
                                                  width: 1,
                                                  color: Colors.black)),
                                          child: Image.asset(
                                              'assets/images/teacher.png'),
                                        ))),
                              ),
                              Positioned(
                                right: 1,
                                bottom: 1,
                                child: Checkbox(
                                    value: _tutor,
                                    onChanged: (bool value) {
                                      _onTutor(value);
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 110,
                        height: 110,
                        child: GestureDetector(
                          onTap: null,
                          child: Stack(
                            children: <Widget>[
                              FittedBox(
                                fit: BoxFit.fill,
                                child: ClipRRect(
                                    child: Container(
                                        width: 90,
                                        height: 90,
                                        child: Card(
                                          elevation: 5.0,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              side: BorderSide(
                                                  width: 1,
                                                  color: Colors.black)),
                                          child: Image.asset(
                                              'assets/images/student.png'),
                                        ))),
                              ),
                              Positioned(
                                right: 1,
                                bottom: 1,
                                child: Checkbox(
                                    value: _student,
                                    onChanged: (bool value) {
                                      _onStudent(value);
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  TextField(
                    controller: _emailEditingController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        labelText: 'Email', icon: Icon(Icons.email)),
                  ),
                  SizedBox(height: 5),
                  TextField(
                    controller: _passEditingController,
                    keyboardType: TextInputType.text,
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
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (bool value) {
                          _onRememberMeChanged(value);
                        },
                      ),
                      Text('Remember Me ',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(14, 30, 64, 1))),
                    ],
                  ),
                  MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      minWidth: 300,
                      height: 50,
                      child: Text('Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )),
                      color: Color.fromRGBO(14, 30, 64, 1),
                      //textColor: Colors.blue,
                      elevation: 10,
                      onPressed: () {
                        _userLogin(_role);
                      }),
                ]),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Don't have an account? ",
                    style: TextStyle(
                        fontSize: 16.0, color: Color.fromRGBO(14, 30, 64, 1))),
                GestureDetector(
                  onTap: selectRoleUserDialog,
                  child: Text(
                    "Create Account",
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(14, 30, 64, 1)),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Forgot your password ",
                    style: TextStyle(
                        fontSize: 16.0, color: Color.fromRGBO(14, 30, 64, 1))),
                GestureDetector(
                  onTap: _forgotPassword,
                  child: Text(
                    "Reset Password",
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(14, 30, 64, 1)),
                  ),
                ),
              ],
            )
          ],
        ));
  }

  void _onTutor(bool newValue) => setState(() {
        _tutor = newValue;
        if (_tutor) {
          _student = false;

          print("tutor");
          updateRole();
        } else {
          _student = true;

          updateRole();
        }
      });

  void _onStudent(bool newValue) {
    setState(() {
      _student = newValue;
      if (_student) {
        _tutor = false;
        print("student");
        updateRole();
      } else {
        _tutor = true;

        updateRole();
      }
    });
  }

  void updateRole() {
    setState(() {
      if (_tutor) {
        _role = "Tutor";
        print("Selected :" + _role);
      }
      if (_student) {
        _role = "Student";
        print("Selected :" + _role);
      }
    });
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: new Text(
              'Are you sure?',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            content: new Text(
              'Do you want to exit an App',
              style: TextStyle(color: Colors.black),
            ),
            actions: <Widget>[
              MaterialButton(
                  onPressed: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                  child: Text(
                    "Exit",
                    style: TextStyle(
                      color: Color.fromRGBO(14, 30, 64, 1),
                    ),
                  )),
              MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Color.fromRGBO(14, 30, 64, 1),
                    ),
                  )),
            ],
          ),
        ) ??
        false;
  }

  void selectRoleUserDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            title: Text("Select Register As:"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  minWidth: 200,
                  height: 50,
                  onPressed: _registerUserTutor,
                  color: Color.fromRGBO(14, 30, 64, 1),
                  elevation: 10,
                  child: Text("Tutor",
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
                SizedBox(height: 10),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  minWidth: 200,
                  height: 50,
                  onPressed: _registerUserStudent,
                  color: Color.fromRGBO(14, 30, 64, 1),
                  elevation: 10,
                  child: Text("Student",
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                )
              ],
            ),
            actions: <Widget>[
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              )
            ],
          );
        });
  }

  void _registerUserStudent() {
    Navigator.of(context).pop();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => RegisterStudentScreen()));
  }

  void _registerUserTutor() {
    Navigator.of(context).pop();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => RegisterTutorScreen()));
  }

  Future<void> _userLogin(String _role) async {
    String _email = _emailEditingController.text;
    String _password = _passEditingController.text;
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Login...");
    await pr.show();
    //String url = "https://smileylion.com/mytutor/php/login_user1.php";
    String url = "https://smileylion.com/mytutor/php/login_multirole.php";
    http.post(url, body: {
      "email": _email,
      "password": _password,
      "role": _role,
    }).then((res) {
      print(res.body);
      List userdata = res.body.split("-");
      if (userdata[0] == "success") {
        Toast.show("Login Success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        User user = new User(
          userid: userdata[1],
          name: userdata[2],
          email: _email,
          phone: userdata[4],
          password: _password,
          picture: userdata[6],
          role: _role,
          
        );

        if (_role == "Student") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => TabScreen(user: user)));
        } else {
          List tutordata = res.body.split("-");
          if (tutordata[0] == "success") {
            Tutor tutor = new Tutor(
              tutorid: tutordata[8],
              gender: tutordata[9],
              picture: tutordata[10],
              description: tutordata[11],
              occupation: tutordata[12],
              education: tutordata[13],
              institution: tutordata[14],
              status: tutordata[15],
            );
            Toast.show(
              "Load Success",
              context,
              duration: Toast.LENGTH_LONG,
              gravity: Toast.BOTTOM,
            );
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        TabTutorScreen(user: user, tutor: tutor)));
          } else {
            Toast.show(
              "Load failed",
              context,
              duration: Toast.LENGTH_LONG,
              gravity: Toast.BOTTOM,
            );
          }
        }
      } else {
        Toast.show("Login Failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
    });
    await pr.hide();
  }

  void _onRememberMeChanged(bool newValue) => setState(() {
        _rememberMe = newValue;
        print(_rememberMe);
        if (_rememberMe) {
          savepref(true);
        } else {
          savepref(false);
        }
      });

  Future<void> loadpref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _email = (prefs.getString('email')) ?? '';
    String _password = (prefs.getString('password')) ?? '';
    //bool _rememberMe = (prefs.getBool('rememberme')) ?? false;
    if (_email.isNotEmpty) {
      setState(() {
        _emailEditingController.text = _email;
        _passEditingController.text = _password;
        _rememberMe = true;
      });
    }
  }

  void savepref(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _email = _emailEditingController.text;
    String _password = _passEditingController.text;

    if (value) {
      print(validateEmail(_email));
      print(isPasswordCompliant(_password));
      if (validateEmail(_email) == false && !isPasswordCompliant(_password)) {
        print("EMAIL/PASSWORD EMPTY");
        _rememberMe = false;
        Toast.show("Check your email or password and try again", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        return;
      } else {
        await prefs.setString('email', _email);
        await prefs.setString('password', _password);
        await prefs.setBool('rememberme', value);
        Toast.show("Saved", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        print('Preferences saved');
      }
    } else {
      await prefs.setString('email', _email);
      await prefs.setString('password', _password);
      await prefs.setBool('rememberme', false);
      setState(() {
        _emailEditingController.text = "";
        _passEditingController.text = "";
        _rememberMe = false;
      });
      Toast.show("Unsaved", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void _forgotPassword() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            title: Text("Reset Your Password"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  minWidth: 200,
                  height: 50,
                  onPressed: () {
                    resetpassword("Tutor");
                  },
                  color: Color.fromRGBO(14, 30, 64, 1),
                  elevation: 10,
                  child: Text("Tutor",
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
                SizedBox(height: 10),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  minWidth: 200,
                  height: 50,
                  onPressed: () {
                    resetpassword("Student");
                  },
                  color: Color.fromRGBO(14, 30, 64, 1),
                  elevation: 10,
                  child: Text("Student",
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                )
              ],
            ),
            actions: <Widget>[
              /* MaterialButton(onPressed: (){
                                  Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => ResetPasswordScreen()));
                                },
                                child: Text("Reset Password",style: TextStyle(color:Colors.black,fontSize: 16),),
                                ),*/
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              )
            ],
          );
        });
  }

  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regexp = new RegExp(pattern);
    return (!regexp.hasMatch(value)) ? false : true;
  }

  bool isPasswordCompliant(String password, [int minLength = 6]) {
    if (password == null || password.isEmpty) {
      return false;
    }
    bool hasUppercase = password.contains(new RegExp(r'[A-Z]'));
    bool hasDigits = password.contains(new RegExp(r'[0-9]'));
    bool hasLowerCase = password.contains(new RegExp(r'[a-z]'));
    bool hasSpecialCharacters =
        password.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    bool hasMinLength = password.length >= minLength;

    return hasDigits &
        hasUppercase &
        hasLowerCase &
        hasSpecialCharacters &
        hasMinLength;
  }

  void resetpassword(String role) {
    Navigator.of(context).pop();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => ResetPasswordScreen(
              role:role,
            )));
  }
}
