import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
 
void main() => runApp(ResetPasswordScreen());
 
class ResetPasswordScreen extends StatefulWidget {
  final String role;
  ResetPasswordScreen({this.role});
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController _resetpwCon = new TextEditingController();
  String verifylink;
  bool verifyButton=false;
  int newpass =0;
  double screenHeight, screenWidth;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(title:Text("Reset Pasword")),
      body: Stack(children: <Widget>[
          upperPart(context),
          lowerPart(context),
        ]),
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
        //height: screenHeight / 2,
        margin: EdgeInsets.only(top: screenHeight / 4),
        child: Column(
          children: <Widget>[
            Card(
              elevation: 10,
              child: Container(
                height: screenHeight / 3,
                padding: EdgeInsets.fromLTRB(30, 20, 30, 10),
                child: Column(children: <Widget>[
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text("Enter your registered email.",
                          style: TextStyle(
                            color: Color.fromRGBO(14, 30, 64, 1),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ))),
                  TextField(
              controller: _resetpwCon,
              decoration: InputDecoration(
                hintText: "abc@example.com,"
              ),
            ),
            SizedBox(height: 10,),
            MaterialButton(
              child: Text("Reset Pasword",style: TextStyle(color: Colors.white,fontSize: 20),),
              color: Colors.blue,
              onPressed: (){
                checkUser();
              }),

              verifyButton 
              ? MaterialButton(                 
              child: Text("Verify Pasword",style: TextStyle(color: Colors.white,fontSize: 20),),
              color: Colors.amber,
              onPressed: (){
                resetPassword(verifylink);
              })
              : Container(),

              newpass == 0 ?Container(
                child: Column(
                  children: <Widget>[
                    Text("This email is not found in our database"),
                  ],
                ),
              ) : Text("New Password is : $newpass",style: TextStyle(fontSize: 20),),
                ])))]));}       
                
  Future checkUser()async{
    var response=await http.post("http://smileylion.com/mytutor/php/check.php",
    body: {
      "email":_resetpwCon.text.toString(),
      "role":widget.role,
    });
    var link=json.decode(response.body);
    if(link == "Invalid Email"){
      Toast.show("Invalid Email", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }else{
      setState(() {
        verifylink=link;
        verifyButton=true;
      });
      showToast("Click Verify Button to Reset Password",duration:Toast.LENGTH_LONG,gravity: Toast.BOTTOM);
      //Toast.show("Click Verify Button to Reset Password", context,duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
    print(link);
  }

  Future resetPassword(String verifylink) async{
     var response=await http.post(verifylink);
     var link=json.decode(response.body);
     setState(() {
       newpass=link;
       verifyButton=false;
     });
     print(link);
     showToast("Your Password has been reset : $newpass",duration:Toast.LENGTH_LONG,gravity: Toast.BOTTOM);
     //Toast.show("Your Password has been reset : $newpass", context,duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  }
  showToast(String msg,{int duration,int gravity}){
    Toast.show(msg, context,duration: duration,gravity: gravity);
  }

}