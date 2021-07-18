import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mytutor/profile.dart';
import 'package:mytutor/tutormainscreen.dart';
import 'package:mytutor/user.dart';
import 'package:mytutor/tutor.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

void main() => runApp(HistoryTabScreen());

class HistoryTabScreen extends StatefulWidget {
  final Tutor tutor;
  final User user;
  const HistoryTabScreen({Key key, this.user,this.tutor}) : super(key: key);

  @override
  _HistoryTabScreenState createState() => _HistoryTabScreenState();
}

class _HistoryTabScreenState extends State<HistoryTabScreen> {
  int _current = 0;
  List<Widget> tabchildren;
  String maintitle = "ToPay";

  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom:TabBar(
              tabs:[
                Tab(icon: Icon(Icons.directions_car)),
                Tab(icon: Icon(Icons.directions_transit)),
                Tab(icon: Icon(Icons.directions_bike)),
              ],
            ),
            title:  Text("History"),
          ),
          body: TabBarView(
            children:[
              Icon(Icons.directions_car),
              Icon(Icons.directions_transit),
              Icon(Icons.directions_bike),
            ]
          )
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
        maintitle = "My Account";
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
