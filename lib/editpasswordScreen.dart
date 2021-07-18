import 'package:flutter/material.dart';
import 'package:mytutor/user.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

void main() => runApp(EditPasswordScreen());

class EditPasswordScreen extends StatefulWidget {
  final User user;

  const EditPasswordScreen({Key key, this.user}) : super(key: key);

  @override
  _EditPasswordScreenState createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends State<EditPasswordScreen> {
  double screenHeight, screenWidth;
  TextEditingController _oldPwEditingController = new TextEditingController();
  TextEditingController _newPwEditingController = new TextEditingController();
  bool _passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Passwaord"),
        backgroundColor: Color.fromRGBO(14, 30, 64, 1),
      ),
      body: Container(
          child: Padding(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Column(children: <Widget>[
          Card(
              elevation: 10,
              child: Container(
                  padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                  width: screenWidth,
                  child: Column(children: <Widget>[
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text("Choose a New Password",
                            style: TextStyle(
                              color: Color.fromRGBO(14, 30, 64, 1),
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ))),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: _oldPwEditingController,
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
                      controller: _newPwEditingController,
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
                    SizedBox(
                      height: 20,
                    ),
                    MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        minWidth: 300,
                        height: 50,
                        child: Text('Change my Password',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            )),
                        color: Color.fromRGBO(14, 30, 64, 1),
                        //textColor: Colors.blue,
                        elevation: 10,
                        onPressed: () {
                          onchangePw(_oldPwEditingController.text,_newPwEditingController.text);
                        }),
                  ])))
        ]),
      )),
    );
  }

  void onchangePw(String oldPw,String newPw) {
    if (oldPw == "" || newPw == "") {
      Toast.show("Please enter your password", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    http.post("https://smileylion.com/mytutor/php/new_password.php", body: {
      "userid": widget.user.userid,
      "oldpassword": oldPw,
      "newpassword": newPw,
    }).then((res) {
      if (res.body == "success") {
        print('in success');
        setState(() {
          widget.user.password = newPw;
        });
        Toast.show("Success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.of(context).pop();
        return;
      } else {
         Toast.show("Failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
    });

  }

}
