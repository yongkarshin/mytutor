import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mytutor/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:mytutor/tutordetail.dart';
import 'package:mytutor/tutor.dart';
void main() => runApp(FavoriteScreen());

class FavoriteScreen extends StatefulWidget {
  final User user;
  const FavoriteScreen({Key key, this.user}) : super(key: key);
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List favoritedata;
  double screenHeight, screenWidth;
  String title = "Loading favorite...";
  bool _isFavorite=true;
  void initState() {
    super.initState();
    _loadFavorite();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            favoritedata == null
                ? Flexible(child: Container(child: Center(child: Text(title))))
                : Flexible(
                    child: ListView.builder(
                        itemCount: favoritedata.length,
                        itemBuilder: (context, index) {
                          return Column(children: <Widget>[
                            
                            InkWell(
                                onTap: () => {
                                      _loadTutorDetail(index),
                                    },
                                child: Card(
                                  elevation: 10,
                                  child: Padding(
                                    padding: EdgeInsets.all(5),
                                    child: Row(
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: null,
                                          child: ClipOval(
                                            //height: screenHeight / 5,
                                            //width: screenWidth / 2.5,
                                            child: CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl:
                                                  "https://smileylion.com/mytutor/images/${favoritedata[index]['picture']}.jpg?",
                                              height: screenHeight / 6,
                                              width: screenWidth / 3.6,
                                              placeholder: (context, url) =>
                                                  new CircularProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      new Icon(Icons.error),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            //Text(favoritedata[index]['picture']),
                                            Text(
                                              favoritedata[index]['name']
                                                  .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                            Text(
                                              favoritedata[index]['subject'].toString() + " - "+
                                              favoritedata[index]['level'].toString(),
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            Text(favoritedata[index]['lessonlocation'].toString(),
                                                  style:TextStyle(fontSize: 18),
                                                ),
                                            Text("RM "+ favoritedata[index]['price']+" Onwards",style: TextStyle(fontSize: 19,color: Colors.red),),
                                            //Text("RM " +favoritedata[index]['price'] +" / " +favoritedata[index]['duration'] +" min",
                                              //style: TextStyle(fontSize: 20,color: Colors.red)),
                                          ],
                                        )),
                                        /*Expanded(child: Column(children: <Widget>[
                                                  Text("3.098 km",style: TextStyle(fontSize: 16),),
                                                ],))*/
                                      ],
                                    ),
                                  ),
                                ))
                          ]);
                        }))
          ],
        ),
      ),
    );
  }
  void _loadFavorite() async {
    
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Loading...");
    await pr.show();
    String url = "https://smileylion.com/mytutor/php/load_favorite.php";
    await http.post(url, body: {
      "userid": widget.user.userid,
    }).then((res) {
      if (res.body == "nodata") {
        title = "No Favorite Tutor Found";
        setState(() {
          favoritedata = null;
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          favoritedata = extractdata["favtutors"];
        });
      }
    }).catchError((err) {
      print(err);
    });
    await pr.hide();
  }


  _loadTutorDetail(int index) {
    print(favoritedata[index]['name']);
    Tutor tutor = new Tutor(
      tutorid:favoritedata[index]["tutorid"],
      name:favoritedata[index]["name"],
      email:favoritedata[index]["email"],
      phone:favoritedata[index]["phone"],
      gender:favoritedata[index]["gender"],
      picture:favoritedata[index]["picture"],
      description:favoritedata[index]["description"],
      occupation:favoritedata[index]["occupation"],
      education:favoritedata[index]["education"],
      institution:favoritedata[index]["institution"],
      status:favoritedata[index]["status"],
      classid:favoritedata[index]["classid"],
      subject:favoritedata[index]["subject"],
      level:favoritedata[index]["level"],
      taughtlanguage:favoritedata[index]["taughtlanguage"],
      date: favoritedata[index]['date'],
      time: favoritedata[index]['time'],
      price:favoritedata[index]["price"],
      duration:favoritedata[index]["duration"],
      totalclass:favoritedata[index]["totalclass"],
      quantity:favoritedata[index]["quantity"],
      balance:favoritedata[index]["balance"],
      lessonlocation:favoritedata[index]["lessonlocation"],
      longitude:favoritedata[index]["longitude"],
      latitude:favoritedata[index]["latitude"],
      address:favoritedata[index]["address"],
    );
    //String fav=_isFavorite.toString();
    //print(fav);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => TutorDetailsScreen(
                  tutor: tutor,
                  user: widget.user,
                  favorite: _isFavorite,
                )));
  }
}
