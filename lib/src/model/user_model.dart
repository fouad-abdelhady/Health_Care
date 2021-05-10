import 'dart:convert';

import 'package:flutter_healthcare_app/src/classes/system_users.dart';

class UserModel implements SystemUsers{
  static const JOB = "User";
  String fireBaseId;
  String name;
  String image;
  String country;
  String city;
  String state;
  String email;
  String password;
  String job = JOB;
  List<String> ratedDoctors;

  UserModel(
      {this.fireBaseId,
      this.name,
      this.image,
      this.country,
      this.city,
      this.state,
      this.email,
      this.password,
      this.ratedDoctors});

  factory UserModel.fromRawJson(String jsonStr) =>
      UserModel.fromJson(json.decode(jsonStr));

  factory UserModel.fromJson(Map<String, dynamic> userMap) => UserModel(
        fireBaseId:
            userMap["fireBaseId"] == null ? null : userMap["fireBaseId"],
        name: userMap["fullName"] == null ? null : userMap["fullName"],
        image: userMap["image"] == null ? null : userMap["image"],
        country: userMap["country"] == null ? null : userMap["country"],
        city: userMap["city"] == null ? null : userMap["city"],
        state: userMap["state"] == null ? null : userMap["state"],
        email: userMap["email"] == null ? null : userMap["email"],
        password: userMap["password"] == null ? null : userMap["password"],
        ratedDoctors: userMap["ratedDoctors"] == null
            ? null
            : List.from(userMap["ratedDoctors"]),
      );

  Map<String, dynamic> toJson() => {
        'fireBaseId': this.fireBaseId,
        'fullName': this.name,
        'ratedDoctors': [],
        'image': this.image == null ? "" : this.image,
        'country': this.country,
        'city': this.city,
        'state': this.state == null ? "" : this.state,
        'email': this.email,
        'password': this.password
      };

  String getObjJsonStr() => jsonEncode(this);
}
