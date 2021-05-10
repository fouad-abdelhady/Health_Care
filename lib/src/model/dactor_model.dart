import 'dart:convert';
import 'package:flutter_healthcare_app/src/classes/Rating.dart';
import 'package:flutter_healthcare_app/src/classes/address.dart';
import 'package:flutter_healthcare_app/src/classes/certificates.dart';
import 'package:flutter_healthcare_app/src/classes/system_users.dart';


class DoctorModel implements SystemUsers{
  static const JOB = "Doctor";
  static List<dynamic> SPECIALIZATION = [];
  static final DOCTORS_SPECIALIZATIONS_URL =
      "https://health-care000.herokuapp.com/doctors/types";

  String job = JOB;
  String fireBaseID; //
  String name; //
  String email; //
  String mobileNumber; //
  String about; //
  String specialization;
  String keywords;
  String accountStatus;
  String password; //
  bool isVerified;
  String image;
  String universityCertificate;
  String identitiyDocument;
  Address address;
  List<Certificates> certificates;
  Rating rate;
  bool isFavourit = false;

  DoctorModel(
      {this.fireBaseID,
      this.name,
      this.email,
      this.mobileNumber,
      this.about,
      this.specialization,
      this.keywords,
      this.accountStatus,
      this.isVerified,
      this.image,
      this.universityCertificate,
      this.identitiyDocument,
      this.address,
      this.rate,
      this.certificates});

  DoctorModel copyWith(
          {String fireBaseID,
          String name,
          String email,
          String mobileNumber,
          String about,
          String specialization,
          String keywords,
          String accountStatus,
          bool isVerified,
          String image,
          String universityCertificate,
          String identitiyDocument,
          Address address,
          List<Certificates> certificates,
          Rating rate}) =>
      DoctorModel(
        fireBaseID: fireBaseID ?? this.fireBaseID,
        name: name ?? this.name,
        email: email ?? this.email,
        mobileNumber: mobileNumber ?? this.mobileNumber,
        about: about ?? this.about,
        specialization: specialization ?? this.specialization,
        keywords: keywords ?? this.keywords,
        accountStatus: accountStatus ?? this.accountStatus,
        isVerified: isVerified ?? this.isVerified,
        image: image ?? this.image,
        universityCertificate:
            universityCertificate ?? this.universityCertificate,
        identitiyDocument: identitiyDocument ?? this.identitiyDocument,
        address: address ?? this.address,
        certificates: certificates ?? this.certificates,
        rate: rate ?? this.rate,
      );

  factory DoctorModel.fromRawJson(String str) =>
      DoctorModel.fromJson(json.decode(str));

  //  String toRawJson() => json.encode(toJson());

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    var certs = json["certificates"] as List;
    return DoctorModel(
      fireBaseID: json["fireBaseId"] == null ? null : json["fireBaseId"],
      name: json["name"] == null ? null : json["name"],
      email: json["email"] == null ? null : json["email"],
      mobileNumber: json["mobileNumber"] == null ? null : json["mobileNumber"],
      about: json["about"] == null ? null : json["about"],
      specialization:
          json["specialization"] == null ? null : json["specialization"],
      keywords: json["keywords"] == null ? null : json["keywords"],
      accountStatus:
          json["accountStatus"] == null ? null : json["accountStatus"],
      isVerified: json["verified"] == null ? null : json["verified"],
      image: json["image"] == null ? null : json["image"],
      universityCertificate: json["universityCertificate"] == null
          ? null
          : json["universityCertificate"],
      identitiyDocument:
          json["identitiyDocument"] == null ? null : json["identitiyDocument"],
      address:
          json["address"] == null ? null : Address.fromJson(json["address"]),
      certificates: json["certificates"] == null
          ? null
          : certs.map((cert) => Certificates.fromJson(cert)).toList(),
      rate: json["rating"] == null ? null : Rating.fromJson(json["rating"]),
    );
  }

  Map<String, dynamic> toJson() {
    List<Map> certificatesList = this.certificates != null
        ? this.certificates.map((cert) => cert.toJson()).toList()
        : null;
    Map addressMap = this.address != null ? this.address.toJson() : null;
    Map ratingMap = this.rate != null ? this.rate.toJson() : null;
    return {
      "fireBaseId": this.fireBaseID,
      "name": this.name,
      "email": this.email,
      "mobileNumber": this.mobileNumber,
      "about": this.about,
      "specialization": this.specialization,
      "keywords": this.keywords,
      "accountStatus": this.accountStatus,
      "verified": this.isVerified,
      "image": this.image,
      "universityCertificate": this.universityCertificate,
      "identitiyDocument": this.identitiyDocument,
      "address": addressMap,
      "certificates": certificatesList,
      "rating": ratingMap,
    };
  }

  String getObjJsonStr() => jsonEncode(this);
}
