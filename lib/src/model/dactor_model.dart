import 'dart:convert';
import 'package:flutter_healthcare_app/src/classes/address.dart';
import 'package:flutter_healthcare_app/src/classes/certificates.dart';

class DoctorModel {
    static List<dynamic> SPECIALIZATION = [];
    static final DOCTORS_SPECIALIZATIONS_URL = "https://health-care000.herokuapp.com/doctors/types";

    String name; //
    String type;
    String description; //
    String email; //
    String image;
    String mobileNumber; //
    double rating;
    double good;
    double medium;
    double bad;
    bool isFavorite;
    bool isVerified;
    Address address;
    List<String> keywords;
    List<Certificates> certificates;

    DoctorModel({
        this.name,
        this.type,
        this.description,
        this.rating,
        this.good,
        this.medium,
        this.bad,
        this.isFavorite,
        this.image,
        this.address,
        this.isVerified,
        this.email,
        this.mobileNumber,
        this.keywords,
        this.certificates
    });

    DoctorModel copyWith({
        String name,
        String type,
        String description,
        double rating,
        double good,
        double medium,
        double bad,
        bool isFavorite,
        String image,
        Address address,
        bool isVerified,
        String email,
        String mobileNumber,
        List<String> keywords,
        List<Certificates> certificates
    }) => 
        DoctorModel(
            name: name ?? this.name,
            type: type ?? this.type,
            description: description ?? this.description,
            rating: rating ?? this.rating,
            good: good ?? this.good,
            medium: medium ?? this.medium,
            bad: bad ?? this.bad,
            isFavorite: isFavorite ?? this.isFavorite,
            image: image ?? this.image,
            address: address ?? this.address,
            isVerified: isVerified ?? this.isVerified,
            email: email ?? this.email,
            mobileNumber: mobileNumber ?? this.mobileNumber,
            keywords: keywords ?? this.keywords,
            certificates: certificates ?? this.certificates
        );

    factory DoctorModel.fromRawJson(String str) => DoctorModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory DoctorModel.fromJson(Map<String, dynamic> json) => DoctorModel(
        name: json["name"] == null ? null : json["name"],
        type: json["type"] == null ? null : json["type"],
        description: json["description"] == null ? null : json["description"],
        rating: json["rating"] == null ? null : json["rating"].toDouble(),
        good: json["goodReviews"] == null ? null : json["goodReviews"].toDouble(),
        medium: json["totalScore"] == null ? null : json["totalScore"].toDouble(),
        bad: json["satisfaction"] == null ? null : json["satisfaction"].toDouble(),
        isFavorite: json["isfavourite"] == null ? null : json["isfavourite"],
        image: json["image"] == null ? null : json["image"],

    );

    Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "type": type == null ? null : type,
        "description": description == null ? null : description,
        "rating": rating == null ? null : rating,
        "goodReviews": good == null ? null : good,
        "totalScore": medium == null ? null : medium,
        "satisfaction": bad == null ? null : bad,
        "isfavourite": isFavorite == null ? null : isFavorite,
        "image": image == null ? null : image,
    };

}
