

class Tutordata{
  String id;
  String name;
  String phone;
  String subject;
  Tutordata({this.id,this.name,this.phone,this.subject});

  factory Tutordata.fromJson(Map<String, dynamic> json) {
    return Tutordata(
      id: json['ID'],
      name: json['NAME'],
      phone: json['PHONE'],
      subject: json['SUBJECT']
 
    );
  }
}

