import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mytutor/TutorClassScreen.dart';
import 'package:mytutor/profile.dart';
import 'package:mytutor/tutormainscreen.dart';
import 'package:mytutor/user.dart';
import 'package:mytutor/tutor.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

void main() => runApp(TabTutorScreen());

class TabTutorScreen extends StatefulWidget {
  final Tutor tutor;
  final User user;
  const TabTutorScreen({Key key, this.user,this.tutor}) : super(key: key);

  @override
  _TabTutorScreenState createState() => _TabTutorScreenState();
}

class _TabTutorScreenState extends State<TabTutorScreen> {
  int _current = 0;
  List<Widget> tabchildren;
  String maintitle = "MyTutor";

  @override
  void initState() {
    super.initState();
    tabchildren = [
      TutorClassScreen(user: widget.user, tutor: widget.tutor),
      TutorMainScreen(user: widget.user, tutor: widget.tutor,),
      ProfileScreen(user: widget.user, tutor: widget.tutor,),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text(maintitle),
          backgroundColor: Color.fromRGBO(14, 30, 64, 1),
        ),
        body: tabchildren[_current],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color.fromRGBO(14, 30, 64, 1),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.white,
          onTap: tabTapped,
          currentIndex: _current,
          items: [
            new BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text("Home"),
            ),
            new BottomNavigationBarItem(
              icon: Icon(Icons.book),
              title: Text("MyClass"),
            ),
            new BottomNavigationBarItem(
                icon: Icon(Icons.person), title: Text("Account"))
          ],
        ),
      ),
    );
  }

  void tabTapped(int index) {
    setState(() {
      _current = index;
      if (_current == 0) {
        maintitle = "MyTutor";
      }
      if (_current == 1) {
        maintitle = "MyClass";
      }
      if (_current == 2) {
        maintitle = "MyAccount";
      }
    });
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Confirm'),
              content: Text('Do you want to exit the App'),
              actions: <Widget>[
                FlatButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop(false); //Will not exit the App
                  },
                ),
                FlatButton(
                  child: Text('Yes'),
                  onPressed: () {
                    Navigator.of(context).pop(true); //Will exit the App
                  },
                )
              ],
            );
          },
        ) ??
        false;
  }


}
