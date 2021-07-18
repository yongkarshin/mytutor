import 'package:flutter/material.dart';
import 'package:mytutor/user.dart';
import 'package:mytutor/tutor.dart';
//import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

void main() => runApp(EditTutorScreen());

class EditTutorScreen extends StatefulWidget {
  final User user;
  final Tutor tutor;
  const EditTutorScreen({Key key, this.user, this.tutor}) : super(key: key);

  @override
  _EditTutorScreenState createState() => _EditTutorScreenState();
}

class _EditTutorScreenState extends State<EditTutorScreen> {
  //picture
  final TextEditingController _genderCon = TextEditingController();
  final TextEditingController _descriptionCon = TextEditingController();
  final TextEditingController _occupationCon = TextEditingController();
  final TextEditingController _educationCon = TextEditingController();
  final TextEditingController _institutionCon = TextEditingController();
  int _radioValue = 0;
  String _gender="Male";

  @override
  void initState() {
    super.initState();
    _genderCon.text = widget.tutor.gender;
    _descriptionCon.text = widget.tutor.description;
    _occupationCon.text = widget.tutor.occupation;
    _educationCon.text = widget.tutor.education;
    _institutionCon.text = widget.tutor.institution;
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Tutor Details"),
        backgroundColor: Color.fromRGBO(14, 30, 64, 1)
      ),
      body: Container(
          child: Padding(
              padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
              child: SingleChildScrollView(
                  child: Column(
                children: <Widget>[
                  //Text(widget.tutor.tutorid),
                 Container(
                        height: 30,
                        child: Row(
                          children: [
                            //Icon(Icons.location_on),
                            Tab(icon: Container(
                              child:Image(image:AssetImage("assets/images/gender.png"),fit: BoxFit.cover,),
                              width:25,height:25
                            ),),
                            
                            SizedBox(
                              width: 5,
                            ),
                             new Radio(
                              value: 0,
                              groupValue: _radioValue,
                              onChanged: _handleRadioValueChange),
                            new Text("Male"),
                            new Radio(
                              value: 1,
                              groupValue: _radioValue,
                              onChanged: _handleRadioValueChange),
                            new Text("Female"),

                          ],
                        )),
                  /*TextField(
                      controller: _genderCon,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: 'Gender', 
                          icon:Image.asset("assets/images/gender.png",width:25,height:25,color: Colors.grey[600]))),
                  */
                  SizedBox(height: 5,),
                  Container(
                    alignment: Alignment.topLeft,
                    height:320,
                    child:TextField(
                      controller: _descriptionCon,
                      keyboardType: TextInputType.text,
                      maxLines: 30,
                      maxLength: 500,
                      maxLengthEnforced: true,
                      decoration: InputDecoration(
                          border: new OutlineInputBorder(
                            borderRadius:new BorderRadius.circular(5),
                            borderSide: new BorderSide(),
                          ),
                          hintText: "Short bio about yourself",
                          labelText: 'Description',
                          fillColor: Colors.white,
                          icon: Icon(Icons.assignment_ind))),
                  ),
                  
                  TextField(
                      controller: _occupationCon,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: 'Occupation', icon: Icon(Icons.work))),
                  TextField(
                      controller: _educationCon,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: 'Education', icon: Icon(Icons.school))),
                  TextField(
                      controller: _institutionCon,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: 'Institution', icon: Icon(Icons.business))),
                  SizedBox(height: 10),
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
                      onPressed: updateTutorDialog,
                      ),
                  
                  SizedBox(height: 10),
                ],
              )))),
    );
  }
  void _handleRadioValueChange(int value){
    setState(() {
      _radioValue=value;
      switch(_radioValue){
        case 0: _gender="Male";
        break;
        case 1 : _gender="Female";
        break;
      }
    });
  }

  void updateTutor() {
    print(_gender);
  //String _gender = _genderCon.text;
  String _description = _descriptionCon.text;
  String _occupation = _occupationCon.text;
  String _education = _educationCon.text;
  String _institution = _institutionCon.text;
    /*if (prnameEditingController.text.length < 4) {
      Toast.show("Please enter product name", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (qtyEditingController.text.length < 1) {
      Toast.show("Please enter product quantity", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (priceEditingController.text.length < 1) {
      Toast.show("Please enter product price", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (weigthEditingController.text.length < 1) {
      Toast.show("Please enter product weight", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }*/
    http.post("https://smileylion.com/mytutor/php/update_tutor.php",body: {
      "tutorid": widget.tutor.tutorid,
      "gender": _gender,
      "picture": widget.user.userid,
      "description": _description,
      "occupation": _occupation,
      "education": _education,
      "institution": _institution,
    }).then((res){
      print(res.body);
      if(res.body=="success"){
        Toast.show(
          "Success",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
        );
        widget.tutor.description=_descriptionCon.text;
        widget.tutor.occupation=_occupationCon.text;
        widget.tutor.gender=_gender;
        widget.tutor.education=_educationCon.text;
        widget.tutor.institution=_institutionCon.text;
        Navigator.pop(context);
      }else{
        Toast.show(
          "Failed",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
        );
      }
    }).catchError((err){
      print(err);
    });

  }

  void updateTutorDialog() {

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Update Tutor Detail? ",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          content:
              new Text("Are you sure?", style: TextStyle(color: Colors.black)),
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
                updateTutor();
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
}
