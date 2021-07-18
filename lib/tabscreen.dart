import 'package:flutter/material.dart';
import 'package:mytutor/profile.dart';
import 'package:mytutor/mainscreen.dart';
import 'package:mytutor/test.dart';
import 'package:mytutor/tutor.dart';
import 'package:mytutor/user.dart';
import 'package:mytutor/favoritescreen.dart';

void main() => runApp(TabScreen());

class TabScreen extends StatefulWidget {
  
  final User user;
  const TabScreen({Key key,this.user}):super(key:key);

  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int _current = 0;
  List<Widget> tabchildren;
  String maintitle="MyTutor";
  @override
  void initState() {
    super.initState();
    tabchildren = [
      MainScreen(user: widget.user),
      
      FavoriteScreen(user:widget.user),
      ProfileScreen(user: widget.user),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child:Scaffold(
            appBar: AppBar(
             title: Text(maintitle),
             backgroundColor: Color.fromRGBO(14, 30, 64, 1),
            ),
            body: tabchildren[_current],
            bottomNavigationBar: 
            BottomNavigationBar(
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
                /*new BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  title: Text("Test"),

                ),*/
                new BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  title: Text("Favorite"),

                ),
                new BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  title: Text("Account"),
                ),
              ],
            ),
            
          ),
    );

  }
  void tabTapped(int index){
    setState(() {
      _current=index;
      if(_current==0){
        maintitle="MyTutor";
      }
      /*if(_current==1){
        maintitle="Testing";
      }*/
      if(_current==1){
        maintitle="Favorite";
      }
      if(_current==2){
        maintitle="Profile";
      }
    });
  }
  Future<bool> _onBackPressed(){
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
    ) ?? false;
  }
}
