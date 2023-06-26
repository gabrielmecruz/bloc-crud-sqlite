import 'dart:convert';

class Student {
  int? id;
  String name;
  String email;
  String phone;
  num payment;
  String password;
  String? note;
  String? active = '1';

  Student(
      {this.id,
      required this.name,
      required this.email,
      required this.phone,
      required this.payment,
      required this.password,
      this.note,
      this.active = '1'});

  List<Student> noteFromJson(String str) =>
      List<Student>.from(json.decode(str).map((x) => Student.fromJson(x)));

  String noteToJson(List<Student> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        payment: json["payment"],
        password: json["password"],
        note: json["note"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "payment": payment,
        "password": password,
        "note": note,
        "active": active,
      };

  Student clone(
      {int? id,
      String? name,
      String? email,
      String? phone,
      num? payment,
      String? password,
      String? note,
      String? active}) {
    return Student(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        payment: payment ?? this.payment,
        password: password ?? this.password,
        note: note ?? this.note,
        active: active ?? this.active);
  }

  @override
  String toString() {
    return 'Student{id:$id, name:$name, email:$email, phone:$phone, payment:$payment, password:$password, note: $note, active: $active}';
  }
}
