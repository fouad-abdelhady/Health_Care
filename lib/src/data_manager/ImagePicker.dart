import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_healthcare_app/src/config/permissionsManager.dart';

class UsersImagePicker {
  static final UsersImagePicker imagePicker = UsersImagePicker._internal();
  static final int CAMERA = 0;
  static final int GALLARY = 1;

  final _picker = ImagePicker();

  final PermissionsManager permissionsManager = PermissionsManager();

  factory UsersImagePicker() => imagePicker;

  UsersImagePicker._internal();

  Future getImage(int choice) async {
    final source = choice == UsersImagePicker.CAMERA
        ? ImageSource.camera
        : ImageSource.gallery;

    if (_permissionsGranted()) {
      return null;
    }
    final pickedFile = await _picker.getImage(source: source);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  bool _permissionsGranted() {
    bool cameraGranet = false;
    bool storgeGranet = false;
    permissionsManager
        .checkAndRequestPermission(PermissionsManager.CAMERA_PERMISSION)
        .then((value) {
      storgeGranet = value;
    });
    permissionsManager
        .checkAndRequestPermission(PermissionsManager.STORGE_PERMISSIONS)
        .then((value) {
      cameraGranet = value;
    });
    if (cameraGranet && storgeGranet) return true;
    return false;
  }
}
