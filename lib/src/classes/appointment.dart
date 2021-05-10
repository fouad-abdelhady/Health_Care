
import 'dart:convert';

class Appointments{
  int duration;
  int workStart;
  String firebaseId;
  String date;
  List<int> hours;

  Appointments({this.duration, this.workStart, this.firebaseId, this.date, this.hours});

  factory Appointments.fromJson(dynamic json) => Appointments(
    firebaseId: json["fireBaseId"] == null? null: json["fireBaseId"],
    duration: json["workDuration"] == null ? null : int.parse(json["workDuration"]),
    workStart:json["workBeginningTime"] == null ? null : int.parse(json["workBeginningTime"]),
    date: json["date"] == null ? null : json["date"],
    hours:json["hours"] == null ? null : List<int>.from(json["hours"].map((hour) => hour)),
  );

  Map<String, dynamic> toJson() => {
    'fireBaseId': this.firebaseId == null?  null: this.firebaseId,
    'workDuration': this.duration == null? 0 : this.duration,
    'workBeginningTime': this.workStart == null? 0 : this.workStart,
    'date': this.date == null? null : this.date,
    'hours': this.hours == null? [] : List<dynamic>.from(this.hours.map((hour) => hour))
  };
  String getObjJsonStr() => jsonEncode(this);
}