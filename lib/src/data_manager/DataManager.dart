import 'package:http/http.dart' as http;
import 'dart:convert';

class DataManager{
  static final DataManager _dataManager = DataManager._internal();
  var _client;

  factory DataManager(){
    return _dataManager;
  }
  DataManager._internal();

  void openClientConnection(){
    this._client = http.Client();
  }

  void closeClientConnection(){
    this._client.close();
  }

  Future getData({String url}) async {
    http.Response response = await http.get(url);
    return jsonDecode(response.body);
  }

}
