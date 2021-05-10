import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_healthcare_app/src/widgets/dialogs.dart';

import 'DataManager.dart';

class MediaStorage {
  static MediaStorage mediaStorage = MediaStorage._mediaStorage();
  static final IMAGES_DIR = "UsersData/Images/";

  FirebaseStorage _storage;

  factory MediaStorage() {
    mediaStorage.intialize();
    return mediaStorage;
  }

  MediaStorage._mediaStorage();

  void intialize() {
    if (_storage == null) _storage = FirebaseStorage.instance;
  }

  Future upLoadImages({String dir, File image, BuildContext context}) async {
    if (await DataManager.checkInternetConnection() == false) {
      Dialogs.showErrorDialog(
          message: "Check your Internet Connection", context: context);
      return null;
    }

    print("-___________-----___----______ in upload doce");

    TaskSnapshot snapShot = await _storage
        .ref(IMAGES_DIR + dir)
        .putFile(image)
        .onError((error, stackTrace) {
      Dialogs.showErrorDialog(message: error.toString(), context: context);
      print(error.toString());
      print(error.toString());
      return null;
    });

    String downLoadUrl = await snapShot.ref.getDownloadURL();
    print("-___________-----___----______the certificate URL: $downLoadUrl");
    return downLoadUrl;
  }

  Future getDirDownloadUrl({String dir})async{
    String downloadUrl = await _storage.ref(dir).getDownloadURL().onError((error, stackTrace) => null);
    if(downloadUrl.isEmpty || downloadUrl == null)
      return null;
    return downloadUrl;
  }
}
