import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DataManager {
  static const int ITEMS_LIMIT = 10;
  static const String PAGE = "page=";
  static const String LIMIT = "&limit=";
  static const String COUNTRY = "&country=";
  static const String STATE = "&state=";
  static const String CITY = "&city=";
  static const String KEYWORD = "&keywords=";

  static const String ADD_RATED_DOC =
      "https://health-care000.herokuapp.com/users/addToRatedDocs?userId=";
  static const String NEW_USER_URL =
      "https://health-care000.herokuapp.com/users/new-user";
  static const String USER_DATA_URL =
      "https://health-care000.herokuapp.com/users/user?id=";
  static const String NEW_TEMP_USER_URL =
      "https://health-care000.herokuapp.com/temp/user";
  static const String TEMP_USER_DATA_URL =
      "https://health-care000.herokuapp.com/temp/data?userId=";
  static const String TEMP_USER_DELETE_URL =
      "https://health-care000.herokuapp.com/temp/delete?userId=";
  static const String USER_RATED_DOC_URL =
      "https://health-care000.herokuapp.com/users/isDocRated?";
  static const String DOCTOR_DATA_URL =
      "https://health-care000.herokuapp.com/doctors/doctor?id=";
  static const String NEW_DOCTOR_URL =
      "https://health-care000.herokuapp.com/doctors/new-doctor";
  static const String REPLACE_DOCTOR =
      "https://health-care000.herokuapp.com/doctors/update";
  static const String GET_DOCTORS_LIST_URL =
      "https://health-care000.herokuapp.com/doctors?";
  static const String DAY_APPOINTMENTS_URL =
      "https://health-care000.herokuapp.com/appointment/getAppointment?";
  static const String WORKING_HOURS_URL =
      "https://health-care000.herokuapp.com/appointment/getDoctorsTimes?id=";
  static const String UPDATE_HOURS_URL =
      "https://health-care000.herokuapp.com/appointment/update/day";

  static String getWorkingHoursUrl(String id) =>
      WORKING_HOURS_URL + id;

  static String getDayAppointment(String date, String id)=>
      DAY_APPOINTMENTS_URL+"id=$id&date=$date";

  static String getTempUserDataUrl({String firebaseID}) =>
      TEMP_USER_DATA_URL + firebaseID;

  static String getTempUserDeleteUrl({String firebaseID}) =>
      TEMP_USER_DELETE_URL + firebaseID;

  static String getDoctorDataUrl({String firebaseID}) =>
      DOCTOR_DATA_URL + firebaseID;

  static String getDoctorsList(int page,
      {String country, String state, String city, String searchText}) {

    String plusUrl = PAGE + page.toString() +
        LIMIT + ITEMS_LIMIT.toString() +
        COUNTRY + country +
        STATE + state;

    if(city != null)
      plusUrl += CITY + city;
    if(searchText != null)
      plusUrl += KEYWORD + searchText;

    return GET_DOCTORS_LIST_URL + plusUrl;
  }

  static String getRatedDocUrl({String uid, String docId}) =>
      USER_RATED_DOC_URL+"userId="+uid+"&doctorId="+docId;

  static String getUserDataUrl({String firebaseId}) => USER_DATA_URL + firebaseId;

  static String getAddRatedDocUrl({String userId, String doctorId}) =>ADD_RATED_DOC+userId+"&doctorId="+doctorId;



  static final DataManager _dataManager = DataManager._internal();
  var _client;


  factory DataManager() {
    return _dataManager;
  }



  DataManager._internal();

  void openClientConnection() {
    this._client = http.Client();
  }

  void closeClientConnection() {
    this._client.close();
  }

  Future getData({String url}) async {
    bool connected = await checkInternetConnection();
    if (!connected) return null;
    print("---------------------------- " + url);
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 404) return null;

    return jsonDecode(response.body);
  }

  Future postData({String postBody, String url}) async {
    bool connected = await checkInternetConnection();
    print("------------------------------------------------------------");
    print(postBody);
    print("------------------------------------------------------------");
    if (!connected) return false;

    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: postBody,
    );

    if (response.statusCode == 404)
      return false;
    else
      return true;
  }

  static Future checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) return true;
    } on SocketException catch (e) {
      return false;
    }
  }
}
